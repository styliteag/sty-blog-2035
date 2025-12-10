# Screenshots für ZFS Snapshot-Replikation Artikel

## Benötigte Screenshots (in TrueNAS SCALE)

### 1. Replication Tasks Übersicht
**Dateiname:** `screenshot-01-replication-tasks.png`
**Ort:** Data Protection → Replication Tasks
**Zeigen:**
- Hauptansicht mit Liste der Tasks
- "Add" Button sichtbar
- Eventuell ein existierender Task (optional)

---

### 2. Wizard - What and Where
**Dateiname:** `screenshot-02-what-and-where.png`
**Ort:** Replication Task Wizard → What and Where
**Zeigen:**
- Source Location: "On this System"
- Destination Location: "On a Different System"
- Dataset-Browser (Folder Icon)
- SSH Connection Dropdown
- Recursive Checkbox

---

### 3. Wizard - When (Scheduling)
**Dateiname:** `screenshot-03-when-schedule.png`
**Ort:** Replication Task Wizard → When
**Zeigen:**
- "Run Automatically" vs "Run On Demand" Toggle
- Schedule Dropdown (Daily, Hourly, Custom)
- Zeitauswahl-Optionen

---

### 4. Wizard - Security and Task Name
**Dateiname:** `screenshot-04-security-taskname.png`
**Ort:** Replication Task Wizard → Security and Task Name
**Zeigen:**
- Encryption Options (Encrypted/Unencrypted)
- Task Name Feld
- Advanced Options expandiert:
  - "Use Sudo for ZFS Commands"
  - "Stream Compression"

---

### 5. Task Status in Liste
**Dateiname:** `screenshot-05-task-status.png`
**Ort:** Data Protection → Replication Tasks (nach Task-Erstellung)
**Zeigen:**
- Task in der Liste mit Status (SUCCESS oder PENDING)
- "State" Spalte
- "Last Snapshot Sent" Info
- Action Buttons (Edit, Run Now, Delete)

---

### 6. SSH Connection Setup
**Dateiname:** `screenshot-06-ssh-connection.png`
**Ort:** Credentials → Backup Credentials → SSH Connections → Add
**Zeigen:**
- Setup Method: "Semi-automatic (TrueNAS only)"
- TrueNAS URL Feld
- Username/Password Felder
- Name Feld

---

## Optional (falls Zeit vorhanden)

### 7. Periodic Snapshot Task
**Dateiname:** `screenshot-07-periodic-snapshot.png` (optional)
**Ort:** Data Protection → Periodic Snapshot Tasks
**Zeigen:** Periodic Snapshot Task Setup für Source-Dataset

### 8. Task Details/Logs
**Dateiname:** `screenshot-08-task-logs.png` (optional)
**Ort:** Replication Task → Expand → Logs
**Zeigen:** Detaillierte Task-Logs nach erfolgreicher Replikation

---

## Hinweise für die Screenshots

- **Auflösung:** Mindestens 1920x1080 (Full HD)
- **Format:** PNG (verlustfrei)
- **Inhalt anonymisieren:**
  - Keine echten Server-IPs (verwende 192.168.x.x oder 10.x.x.x)
  - Keine echten Hostnamen/Servernamen
  - Beispiel-Dataset-Namen: `tank/production`, `backup/replicated`

- **GUI-Sprache:** Deutsch bevorzugt (wenn verfügbar), ansonsten Englisch OK

- **Wichtig:**
  - Alle Menüs/Dropdowns sichtbar
  - Keine Fehlermeldungen im Screenshot (außer für Troubleshooting-Abschnitt)
  - Cursor nicht über wichtigen Elementen

## Nach Screenshot-Erstellung

1. Screenshots in dieses Verzeichnis kopieren
2. TODO-Kommentare im `index.md` auskommentieren (entfernen)
3. Bilder einbinden durch entfernen der `<!-- -->` Kommentare

Beispiel:
```markdown
<!-- TODO: Screenshot einfügen: ... -->
<!-- ![Beschreibung](screenshot-01.png) -->
```

Wird zu:
```markdown
![Beschreibung](screenshot-01.png)
```
