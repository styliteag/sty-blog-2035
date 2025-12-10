---
title: "Was ist ZFS eigentlich – und warum reden alle darüber?"
date: 2025-10-09T00:00:00+00:00
slug: "was-ist-zfs"
authors: ["Matteo Keller"]
tags: ["Storage", "ZFS", "TrueNAS"]
keywords: ["ZFS Dateisystem", "Enterprise Storage", "OpenZFS", "TrueNAS ZFS", "Storage-Lösungen", "Datensicherheit", "Copy-on-Write", "RAID-Z"]
showHero: true
heroAlt: "ZFS Storage-System mit Datenintegritätsprüfung und Enterprise-Features für moderne Rechenzentren"
description: "ZFS vereint Dateisystem und Volume Manager in einer integrierten Lösung. Erfahren Sie, warum Rechenzentren weltweit auf diese Technologie setzen."
---

![Header-Bild](feature.png)

Wer im Enterprise-Storage unterwegs ist, kommt an drei Buchstaben nicht vorbei: **ZFS**. Aber was steckt dahinter? Und warum schwören Rechenzentren weltweit auf dieses Dateisystem?

## ZFS ist anders

ZFS vereint Dateisystem und Volume Manager in einer einzigen, integrierten Lösung. Das klingt erst mal unspektakulär, hat aber massive Auswirkungen auf Datensicherheit, Performance und Wartbarkeit.

### Die Grundidee: Durchgängige Kontrolle

ZFS betrachtet Ihre komplette Storage-Infrastruktur als Ganzes – von der physischen Festplatte bis zur einzelnen Datei:

- **Konsistente Verwaltung** über alle Ebenen
- **Kontinuierliche Datenintegritätsprüfung** in Echtzeit
- **Datenfehler werden erkannt**, bevor sie zum Problem werden

## Von Sun Microsystems zu OpenZFS

Ursprünglich 2005 von Sun Microsystems entwickelt, wurde ZFS nach der Übernahme durch Oracle 2010 zu einem Wendepunkt: Oracle schloss die Open-Source-Entwicklung und führte ZFS als proprietäre Technologie in Oracle Solaris weiter.

Die Community reagierte mit dem **illumos-Projekt** und gründete 2013 **OpenZFS** – heute die Grundlage für Enterprise-Storage weltweit, insbesondere für **TrueNAS**.

Die erfolgreiche Open-Source-Geschichte zeigt: Transparente Entwicklung schafft robuste Technologie.

## 5 Gründe, warum ZFS die Spielregeln ändert

### 📝 Copy-on-Write (CoW)

Datenblöcke werden niemals direkt überschrieben, sondern bei jeder Änderung in einen neuen Speicherbereich geschrieben. Der Originalzustand bleibt erhalten – perfekt für Datensicherheit und Ausfallschutz.

### 📸 Snapshots

Backup-ähnliche Momentaufnahmen in Sekunden – ohne nennenswerte Performance-Einbußen und ohne Wartezeiten für Anwendungen.

### 🛡️ RAID-Z

Kosteneffiziente und flexible Alternative zu hardwarebasierten RAID-Systemen mit besserer Performance-Skalierung.

### ✅ Data Integrity

Datenfehler werden beim Lesen automatisch auf Integrität geprüft und korrigiert – selbstheilende Storage-Infrastruktur.

### 💾 Compression

Mehr Daten auf weniger physischem Speicher durch transparente Komprimierung ohne Performance-Verlust.

## Warum TrueNAS auf ZFS setzt

TrueNAS ist aktiv an der Entwicklung von OpenZFS beteiligt und nutzt dessen Stärken konsequent:

**🔄 Selbstheilend**
ZFS erkennt Fehler automatisch und korrigiert sie – ohne Ihr Zutun. Ihre Daten bleiben integer, selbst wenn Hardware ausfällt.

**📈 Grenzenlos skalierbar**
Von 10 TB bis 10 PB – ZFS skaliert linear. Mehr Platten = mehr Performance. So einfach.

**🔓 Transparenz durch Open Source**
Kein Vendor Lock-in. Kein Rätselraten. Der komplette Code ist offen einsehbar. Ihre Daten gehören Ihnen.

## Das ist Enterprise-Storage, wie es sein sollte

ZFS ist mehr als ein Dateisystem – es ist eine komplette Storage-Philosophie, entwickelt für eine Zukunft, in der Datenvolumen exponentiell wachsen und Datensicherheit oberste Priorität hat.

---

## 📖 Ausblick: TrueNAS SCALE in der Praxis

In **Teil 2 dieser Serie** nehme ich Sie mit auf meine Reise:

- TrueNAS SCALE auf neuer Hardware installieren
- Erste Schritte aus Nicht-Techniker-Perspektive
- Was funktioniert intuitiv – und wo braucht man Unterstützung?

Ein ehrlicher Erfahrungsbericht: Wie zugänglich ist Enterprise-Storage wirklich? **Bleiben Sie dran!**

---

*Matteo Keller ist im Marketing bei Stylite AG tätig und beschäftigt sich schwerpunktmäßig mit Enterprise-Storage-Lösungen und TrueNAS-Systemen.*

**Stylite AG** – Ihr TrueNAS Partner für professionelle Storage-Lösungen.
