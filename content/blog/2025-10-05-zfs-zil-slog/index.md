---
title: "ZIL und SLOG in ZFS: Architektur, Wirkung, Risiken (Teil 3)"
date: 2025-10-05T00:03:00+00:00
slug: "zfs-zil-slog"
authors: ["Wim Bonis"]
tags: ["Storage", "ZFS", "Performance"]
keywords: ["ZFS ZIL", "ZFS SLOG", "Sync Writes", "TrueNAS SLOG", "OpenZFS Intent Log"]
showHero: true
heroAlt: "ZFS ZIL/SLOG Architektur mit Latenzpfaden"
description: "ZIL ist immer da, SLOG ist optional. Wie Sync-Writes funktionieren, wann ein SLOG hilft und was beim Ausfall passiert."
---

![Header-Bild](feature.png)

## ZIL und SLOG: Intent Log verstehen

**Wichtige Unterscheidung:**
- **ZIL (ZFS Intent Log):** Logische Komponente, immer vorhanden
- **SLOG (Separate Log Device):** Optionales Device, das nur die ZIL aufnimmt

**ZIL ist kein Write-Cache.** Es dient ausschließlich der Crash-Consistency für synchrone Writes.

### Transaction Group Mechanik

```
TXG-Zyklus (gesteuert durch zfs_txg_timeout, Default: 5s):
┌─────────────────────────────────────────────────┐
│ t=0s: Neue TXG startet                          │
│ t=0-5s: Writes sammeln                          │
│   ├─ Async Writes → RAM-Buffer (ACK sofort)     │
│   └─ Sync Writes → RAM + ZIL (ACK nach ZIL)     │
│ t=5s: TXG-Commit → Alle Daten auf Pool          │
└─────────────────────────────────────────────────┘
```

**TXG-Timeout anpassen:**
```bash
# TXG-Zyklus verlängern (weniger Fragmentation)
echo 10 > /sys/module/zfs/parameters/zfs_txg_timeout  # 10s statt 5s

# Persistent via /etc/modprobe.d/zfs.conf:
options zfs zfs_txg_timeout=10
```

### SLOG: Nur für Sync-Writes relevant

Ein SLOG lagert die ZIL auf dediziertes Flash aus. Es beschleunigt NUR synchrone Writes.

| Workload | Sync-Write-Anteil | SLOG-Benefit |
|----------|-------------------|--------------|
| NFS (sync=always) | ~80–100% | sehr hoch |
| SMB (strict sync) | ~60–80% | hoch |
| iSCSI (default) | ~40–60% | mittel |
| Local ZFS | <10% | gering |

### Latenz vs. Durchsatz

Wählen Sie SLOG nach Latenz, nicht nach Durchsatz. Beispiel: HDD-Pool (~10–20ms) vs. Optane (~0.01ms).

### Kein SLOG? Default-ZIL auf dem Pool

Ohne SLOG liegt die ZIL auf den Pool-Vdevs. Moderne NVMe/SSD-Pools bieten oft schon sehr gute Sync-Latenzen.

| Pool-Vdev-Typ | ZIL-Latency | SLOG-Benefit | Empfehlung |
|---------------|-------------|--------------|------------|
| NVMe Mirror | ~0.1–0.2ms | Minimal | SLOG meist unnötig |
| SSD Mirror | ~0.3–0.5ms | Gering | Optional |
| SSD RAIDZ | ~0.5–1ms | Moderat | Bei hoher Last |
| HDD Pool | ~10–20ms | Enorm | SLOG stark empfohlen |

### SLOG-Sizing: Klein aber fein

**Faustregel:**
```
SLOG-Größe = (Max Sync-Write-Rate * 10 Sekunden) * 2
Beispiel: 500 MB/s Sync → 5 GB * 2 = 10 GB SLOG ausreichend
```

TrueNAS Empfehlung: 16-32 GB pro SLOG-Device (gespiegelt!)

**SLOG-Status prüfen:**
```bash
# Pool MIT SLOG:
zpool iostat -v tank 1
              capacity  operations  bandwidth
pool         alloc free  read write  read write
tank         5.2T  2.8T   142  8247  45M  2.1G
  raidz2     5.2T  2.8T   142  8247  45M  2.1G
    sda         -     -    18  1031  5.6M  262M
logs            -     -     -     -     -     -
  mirror     2.1G  13.9G    0  8247   0   2.1G  ← SLOG aktiv!

# Pool OHNE SLOG (ZIL auf Vdevs):
zpool status tank
  pool: tank
  config:
        NAME          STATE
        tank          ONLINE
          mirror-0    ONLINE       # ZIL liegt auf diesen Devices
            nvme0n1   ONLINE
            nvme1n1   ONLINE
        # Kein "logs" Abschnitt = ZIL auf Pool-Vdevs
```

### SLOG: Write-Only im Normalbetrieb

SLOG-Devices werden im Normalbetrieb nicht gelesen, nur beschrieben. Reads passieren nur beim Crash-Recovery (ZIL-Replay).

### SLOG-Ausfall: Was passiert

- Pool bleibt ONLINE, ZIL wechselt auf die Haupt-Vdevs
- Bereits bestätigte Sync-Writes liegen im RAM und werden beim nächsten TXG-Commit persistiert
- Risiko besteht nur beim Doppel-Ereignis: SLOG-Ausfall und unmittelbar danach ein Strom/OS-Crash

```bash
zpool import -m tank  # Import trotz fehlendem Log-Device
```

### Mirroring: Best Practice, nicht Pflicht

| Setup | Risk | Beschreibung |
|-------|------|--------------|
| Single SLOG | Mittel | 0–5s Datenverlust bei Crash möglich |
| Mirrored SLOG | Minimal | Redundanz, stabilere Latenz |
| Kein SLOG | Keins | Langsamer, aber sicher |


### Status/Diagnose – kompakt
```bash
# Pool mit SLOG: Schreiblasteinsicht
zpool iostat -v tank 1

# Import trotz fehlendem SLOG (Crash-Recovery)
zpool import -m tank
```

### Schlüsse (praxisnah)
- **SLOG optimiert Latenz, nicht Durchsatz** – Auswahl nach μs, nicht MB/s.
- **NVMe/SSD‑Pools**: Häufig ausreichend schnell → SLOG meist optional.
- **HDD‑Pools**: SLOG bringt große Effekte; gespiegelt für Produktion.
- **SLOG‑Ausfall ≠ Datenverlust**: Nur Doppelereignis (Ausfall + Crash) riskant.


---

### Weiterlesen
- **Übersicht**: [Serie](/blog/zfs-arc-l2arc-slog/)
- **Vorheriger Teil**: [L2ARC](/blog/zfs-l2arc/)
- **Nächster Teil**: [Best Practices](/blog/zfs-slog-best-practices/)