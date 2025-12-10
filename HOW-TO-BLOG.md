# HOW-TO-BLOG.md

Dieser Leitfaden erklärt, wie Blog-Einträge für die Stylite AG blogsite erstellt werden.

Die Seite ist mit "Hugo" erstellt, einem Static Site Generator.

## URL

Die URL des Blogs im Internet ist https://blog.stylite.de/blog/

Wenn der lokale Server läuft ist die URL http://localhost:1313/blog/

## Struktur der Blog-Einträge

### Dateistruktur
Blog-Einträge werden in folgendem Format organisiert:
```
content/blog/YYYY-MM-DD-slug-name/
├── index.md          # Hauptinhalt
├── feature.png       # Header-Bild (1536x1024px)
└── <anyname>.png       # Weitere Bilder

```

# Neuer Blog Beitrag
Wenn der User einen neuen Blog Beitrag erstellt könnte er in "content/blog/new" files hinlegen die du beachten must!
Sorge dafür das du die assets von dort überimmst und das das verzeichniss danach leer ist.




### Frontmatter Format
Jeder Blog-Eintrag beginnt mit einem YAML-Frontmatter:

```yaml
---
title: "Titel des Artikels"
date: <heutiges datum>
slug: "short-seo-slug"
authors: ["Vorname Nachname"]
tags: ["tag1", "tag2", "tag3"]
keywords: ["Spezifische SEO Keywords", "Long-Tail Keywords", "Technische Begriffe", "Zielgruppen-Keywords"]
showHero: true
heroAlt: "Beschreibung des Feature-Images für Accessibility und SEO"
description: "Kurze Beschreibung des Artikels für SEO und Vorschau"
---
```

**Wichtige Felder:**
- `title`: Aussagekräftiger Titel
- `date`: heutiges Datum im ISO-Format (Uhrzeit 00:00)
- `draft`: `false` für veröffentlichte Artikel
- `authors`: Array mit Autorennamen
- `tags`: Relevante Schlagwörter für User-Navigation (Benutze nicht zuviele gleichzeitig)
- `keywords`: **SEO-spezifische Keywords** (versteckt, nur für Suchmaschinen)
- `showHero`: Zeigt das Header-Bild an
- `heroAlt`: Alt-Text für das Feature-Image (Accessibility + SEO)
- `description`: SEO-optimierte Beschreibung

### SEO Keywords vs. Tags

**Tags** (👥 User-sichtbar):
- Werden in der Navigation angezeigt
- Für Kategorisierung und interne Verlinkung  
- Bleiben sauber und benutzerfreundlich
- Beispiel: `["Storage", "Tools", "ZFS"]`

**Keywords** (🔍 SEO-hidden):
- Nur für Suchmaschinen (Meta-Tags)
- Long-Tail Keywords mit geringer Konkurrenz
- Spezifisch und zielgruppenorientiert
- Beispiel: `["ZFS Performance Tuning", "TrueNAS Enterprise Setup", "Storage-Analyse Tools"]`

## SEO Keywords Strategien

### User-freundliche Tags (für Navigation)
- ZFS
- Storage  
- Security
- Tools
- Cloud
- News
- Open Source
- Docker
- Performance

### SEO Keywords Beispiele (versteckt, für Suchmaschinen)

**Storage-Artikel:**
- "ZFS Performance Tuning", "TrueNAS Setup", "Enterprise Storage"
- "OpenZFS Konfiguration", "NAS vs SAN", "Storage-Hardware"
- "RAID-Z Performance", "ZFS Snapshots", "Backup-Strategien"

**Security-Artikel:**  
- "Ransomware Schutz", "Phishing Prävention", "IT-Sicherheit Unternehmen"
- "ZTNA Implementation", "VPN Alternative", "Zero Trust Security"
- "Dovecot Troubleshooting", "E-Mail-Server Problem", "UTM Optimierung"

**Tools-Artikel:**
- "FIO Benchmarking", "Storage-Analyse", "Performance Monitoring"
- "Open Source Tools", "Docker Monitoring", "ZFS Management"
- "Self-Hosted Monitoring", "Container Orchestration"

**Tipp:** Long-Tail Keywords haben weniger Konkurrenz und höhere Conversion-Rate!

## Header-Bild

![Header-Bild](feature.png)

Das Bild sollte vermitteln was in dem Blog Eintrag steht. 
Es kann auch von einm AU tool generiert werden.

### Feature-Bild automatisch generieren (OpenAI)

Du kannst das Header-Bild direkt aus dem Terminal generieren. Es gibt ein Skript im Repo, das die OpenAI Images API nutzt und das Bild automatisch auf die Blog‑Größe (1536×1024) zuschneidet.

Voraussetzungen:
- `OPENAI_API_KEY` ist in deiner Shell gesetzt: `export OPENAI_API_KEY="sk-…"`
- Tools: `curl`, `python3`, optional ImageMagick (`magick` oder `convert`) für das Zuschneiden.

Empfohlener Ablauf (im Artikel-Ordner):
```bash
cd content/blog/YYYY-MM-DD-dein-slug/
../../../generate-feature-image.sh "Kurzer Motiv‑Prompt" feature.png
```

Beispiele:
- Einfach: `../../../generate-feature-image.sh "ZFS Storage im Rechenzentrum" feature.png`
- Mit Debug und fester Größe: `../../../generate-feature-image.sh --debug --size 1536x1024 "Ransomware Abwehr" feature.png`

Hinweise:
- Das Skript ergänzt automatisch unseren Stil (dunkles Theme, Stylite‑Rot #dc2626, Header‑Look).
- Wenn ImageMagick installiert ist, wird das Bild nach dem Download exakt auf 1536×1024 zugeschnitten.
- Mit `--debug` zeigt das Skript zusätzliche Pfade zu Anfrage/Antwort an (nützlich bei Fehlersuche).

## Content-Richtlinien

### Sprache und Stil
- **Primäre Sprache**: Deutsch (deutsche Zielgruppe)
- **Stil**: Professionell, technisch, B2B-orientiert
- **Zielgruppe**: IT-Entscheider, Systemadministratoren, Unternehmen

### Themen-Fokus
- Storage-Lösungen (ZFS, TrueNAS, NAS/SAN)
- IT-Security und Cybersicherheit
- Open-Source-Technologien
- Docker/Containerisierung
- Enterprise-Lösungen
- Themen rund um MacOS, Github

### Autoren
**Wim Bonis**
  - email: wb@stylite.de
  - github: github.com/wbonis
  - linkedin: linkedin.com/in/wbonis
  - Postion: CTO, Technik, Nerd
  - Bevorzugt den Leser weder mit Du noch mit Sie anzusprechen
    Er bevorzugt eine neutrale Anrede/Ansprache
  - Pronomen: Er/Ihm He/Him
  - Er selbst redet lieber auch neutral:
    - "Ich habe .." sollte vermieden werden
    - "Wir haben .." ist möglich (meint dann die Firma und ihre Angestellte)
    - "Dazu wurde .." ist möglich


**Matteo Keller**
  - email: mk@stylite.de
  - linkedin: linkedin.com/in/matteo-keller-9554bb133/
  - Pronomen: Er/Ihm He/Him
  - Position: Marketing
  - Bevorzugt eine Formale Anrede "Sie"
**André Keller**
  - email: ak@stylite.de
  - Pronomen: Er/Ihm He/Him
  - Bevorzugt eine Formale Anrede "Sie"
  - linkedin: linkedin.com/in/andr%C3%A9-keller-9866ba4/
  - Position: CEO, Founder, Sales

### Die Firma
**Stylite AG**
- Stylite Rechenzentrum
- Website https://www.stylite.de
- Sitz in Bensheim
- Aussenstellen in Kaiserslautern, Weinheim, Mainz
- Gegründet in Mainz
- Schwerpunkte:
    - Storage
    - Cybersicherheit
    - SaaS
    - PaaS

### Struktur-Empfehlungen

#### 1. Einleitung
- Kurze, prägnante Einführung ins Thema
- Persönliche Perspektive des Autors bei Stylite AG
- Problembeschreibung oder Motivation

#### 2. Hauptteil
- Logische Gliederung mit H2/H3-Überschriften (`##` / `###`)
- Konkrete Beispiele und Praxisbezug
- Code-Blöcke mit Syntax-Highlighting
- Screenshots und Visualisierungen

#### 3. Technische Details
- Installation/Setup-Anleitungen
- Konfigurationsbeispiele
- Best Practices

#### 4. Fazit
- Zusammenfassung der wichtigsten Punkte
- Ausblick auf zukünftige Entwicklungen
- Call-to-Action oder Kontaktmöglichkeit

## Bild-Spezifikationen

### Header-Bild (feature.png)
- **Größe**: 1536x1024px
- **Format**: PNG
- **Stil**: Dunkles Theme, professionell
- **Inhalt**: Thematisch passend, mit Stylite-Branding

### Content-Bilder
- **Speicherort**: Lokal im Artikel-Ordner
- **Format**: PNG oder JPG
- **Einbindung**: `![Alt-Text](/images/bildname.png)`

#### Kleine Bilder einbinden (Größenkontrolle)

**Problem:** Standardmäßig nimmt Hugo/Blowfish-Theme Bilder in voller Breite ein. Für Logos, Icons oder kleine Screenshots ist das oft zu groß.

**Lösung:** Verwende Hugo-Shortcodes oder CSS-Klassen für kontrollierte Bildgrößen.

##### Option 1: Hugo Shortcode (Empfohlen - Content von Layout trennen)

```markdown
{{<image src="images/truenas-logo.png" alt="TrueNAS Logo" class="image-small">}}
{{<image src="images/screenshot.png" alt="Screenshot" class="image-medium">}}
{{<image src="images/icon.png" alt="Icon" class="image-inline">}}
{{<image src="images/custom.png" alt="Custom Größe" width="300" height="200">}}
{{<image src="images/with-caption.png" alt="Bild mit Beschriftung" class="image-small" caption="Abbildung 1: Beschreibung">}}
```

##### Option 2: HTML-Alternative (Fallback)

```html
<img src="images/truenas-logo.png" alt="TrueNAS Logo" class="image-small" />
<img src="images/screenshot.png" alt="Screenshot" class="image-medium" />
<img src="images/icon.png" alt="Icon" class="image-inline" />
```

##### Verfügbare CSS-Klassen

| Klasse | Max. Breite | Verwendung |
|--------|-------------|------------|
| `.image-small` | 200px | Kleine Logos, Icons |
| `.image-medium` | 400px | Screenshots, Diagramme |
| `.image-inline` | 150px | Icons im Textfluss |
| `.figure-small` | 200px | Wrapper für Figure-Elemente |

##### Technische Details

**Shortcode-Template** (`/layouts/shortcodes/image.html`):
```html
{{- $src := .Get "src" -}}
{{- $alt := .Get "alt" | default "" -}}
{{- $class := .Get "class" | default "" -}}
{{- $width := .Get "width" -}}
{{- $height := .Get "height" -}}
{{- $caption := .Get "caption" -}}

{{- if $class -}}
  <img src="{{ $src }}" alt="{{ $alt }}" class="{{ $class }}"
    {{- if $width }} width="{{ $width }}"{{- end }}
    {{- if $height }} height="{{ $height }}"{{- end }}
    loading="lazy" />
{{- else -}}
  <img src="{{ $src }}" alt="{{ $alt }}"
    {{- if $width }} width="{{ $width }}"{{- end }}
    {{- if $height }} height="{{ $height }}"{{- end }}
    loading="lazy" />
{{- end -}}

{{- if $caption }}
  <p class="image-caption">{{ $caption }}</p>
{{- end }}
```

**CSS-Klassen** (in `/assets/css/input.css`):
```css
/* Custom image sizing utilities */
.image-small {
  max-width: 200px;
  height: auto;
  margin: 1em auto;
}

.image-medium {
  max-width: 400px;
  height: auto;
  margin: 1em auto;
}

.image-inline {
  max-width: 150px;
  height: auto;
  display: inline-block;
  margin: 0 0.5em;
  vertical-align: middle;
}

.image-caption {
  text-align: center;
  font-size: 0.875em;
  color: #a1a1aa;
  margin-top: 0.5em;
  margin-bottom: 1em;
}
```

##### Tailwind Safelist (für neue Klassen)

Bei neuen CSS-Klassen diese zur Safelist in `/tailwind.config.js` hinzufügen:

```javascript
safelist: [
  'image-small',
  'image-medium',
  'image-inline',
  'image-caption',
  'figure-small'
]
```

##### Build-Prozess

Nach CSS-Änderungen immer neu kompilieren:
```bash
npm run build-css
```

##### Troubleshooting

**Shortcode-Fehler?** Hugo neu starten:
```bash
pkill -f hugo && npm run dev
```

**CSS-Klassen fehlen?** Safelist prüfen und neu kompilieren:
```bash
# tailwind.config.js bearbeiten
npm run build-css
```

##### Best Practices

✅ **Shortcode bevorzugen** für saubere Trennung von Content/Layout
✅ **Alt-Texte verwenden** für SEO und Accessibility
✅ **Lazy Loading** ist automatisch aktiviert
✅ **CSS-Klassen konsistent** verwenden
✅ **Safelist pflegen** für neue Klassen

#### Bild generiere


- Alternativ (manuell/ohne Skript):
- oder du nutzt den MCP server "imagegen"
- Oder du nutzt https:/pexels.com oder https://unsplash.com um nach passenden Bildern zu suchen
  
## Code-Beispiele

### Bash-Kommandos
```bash
# Kommentar zur Erklärung
sudo zpool create mypool /dev/sdb
sudo zfs create mypool/data
```

### Konfigurationsdateien
```yaml
# docker-compose.yml
version: '3.8'
services:
  app:
    image: nginx:latest
    ports:
      - "80:80"
```

## Markdown-Elemente

### Einklappbare Sections (Collapsible Details)

Für lange Artikel mit vielen Detailinformationen können Sections eingeklappt werden, um die Übersichtlichkeit zu erhöhen.

**Verwendung:**
```html
<details>
<summary>Titel der einklappbaren Section – klicken für Details</summary>

### Überschrift innerhalb

- Hier normaler Markdown-Inhalt
- Listen, Code-Blöcke, etc.
- Wird erst beim Klick auf den Titel sichtbar

</details>
```

**Best Practices:**
- Verwende für lange "Advanced Options", "Häufige Probleme", "Best Practices", etc.
- Summary-Text klar formulieren: "Was ist drin – klicken für Details"
- Innerhalb normal Markdown schreiben (Überschriften, Listen, Code)
- Nicht für wichtige Hauptinhalte nutzen (nur für optionale Details)

**Styling:**
- Automatisch gestylte Box (grüner Border, leichter Hintergrund)
- Caret-Symbol (▸/▾) vor dem Titel
- "Click to Open" Hinweis bei geschlossener Box
- Bei geöffnet: Box umschließt gesamten Inhalt

**Beispiele:**
```html
<details>
<summary>Erweiterte Konfigurationsoptionen – klicken für Details</summary>

- **Option 1**: Beschreibung
- **Option 2**: Beschreibung
- **Option 3**: Beschreibung

</details>

<details>
<summary>Häufige Probleme – klicken für Details</summary>

### Problem 1

Lösung hier...

### Problem 2

Lösung hier...

</details>
```

### Listen

**WICHTIG: Alle Listen MÜSSEN mit `- ` (Bindestrich + Leerzeichen) beginnen!**

- **Aufzählungen**: Für Features, Vorteile, Schritte
- **Nummerierte Listen**: Für Anleitungen, Checklisten (verwende `1. `, `2. `, etc.)

#### Ansprechende Listen mit Emojis und Struktur

Für Vor-/Nachteile oder Pro-/Kontra-Listen empfiehlt sich folgendes Format:

```markdown
### ✅ Vorteile

- **Hauptpunkt**: Kurze Beschreibung des Vorteils in einem Satz.
- **Zweiter Punkt**: Weitere Erklärung mit konkretem Nutzen.
- **Dritter Punkt**: Spezifische Details oder Beispiele.

### ⚠️ Herausforderungen

- **Erste Herausforderung**: Beschreibung des Problems oder der Einschränkung.
- **Zweite Herausforderung**: Weitere Details zur Komplexität.
```

**Empfohlene Emojis für Listen:**
- ✅ Vorteile, Erfolg, Best Practices
- ⚠️ Herausforderungen, Achtung, Wichtige Hinweise
- ❌ Nachteile, Fehler, Was vermieden werden sollte
- 💡 Tipps, Ideen, Empfehlungen
- 🔧 Technische Details, Konfiguration
- 📋 Checklisten, Anforderungen
- 🚀 Performance, Optimierung
- 🔒 Sicherheit, Datenschutz

**Best Practices:**
- **Immer `- ` verwenden**: Jeder Listenpunkt beginnt mit Bindestrich + Leerzeichen
- **Titel fett + Doppelpunkt**: `**Titel**: Beschreibung` in einer Zeile
- **Konsistente Struktur**: Einheitliches Format innerhalb einer Liste
- **Max. 4-5 Punkte**: Bessere Lesbarkeit durch Begrenzung
- **Emojis sparsam**: Gezielt einsetzen für visuelle Orientierung

### Hervorhebungen
- **Fett**: `**Wichtige Begriffe**`
- **Kursiv**: `*Betonung*`
- **Code**: `inline code`

### Verlinkungen
- **Interne Links**: `[Linktext](../anderer-artikel/)`
- **Externe Links**: `[GitHub](https://github.com/styliteag/projekt)`
- **Projektverweise**: Immer GitHub-Links zu Stylite-Projekten einbinden

## Typische Artikel-Patterns

### Tool-Vorstellung
1. **Problem/Motivation**: Warum wurde das Tool entwickelt?
2. **Lösung**: Was macht das Tool?
3. **Features**: Hauptfunktionen auflisten
4. **Installation**: Schritt-für-Schritt-Anleitung
5. **Praxisbeispiele**: Konkrete Anwendungsfälle
6. **Fazit**: Nutzen und Ausblick

### Tutorial/How-To
1. **Voraussetzungen**: Was wird benötigt?
2. **Schritt-für-Schritt**: Nummerierte Anleitung
3. **Troubleshooting**: Häufige Probleme und Lösungen
4. **Erweiterte Konfiguration**: Optionale Vertiefung

### Technologie-Vergleich
1. **Überblick**: Was wird verglichen?
2. **Kriterien**: Bewertungsmaßstäbe
3. **Detailvergleich**: Pro/Contra für jede Option
4. **Empfehlung**: Für welchen Anwendungsfall was?

## Qualitätssicherung

### Vor Veröffentlichung prüfen:
- [ ] Rechtschreibung und Grammatik
- [ ] Technische Korrektheit
- [ ] Funktionsfähigkeit aller Code-Beispiele
- [ ] Bilddarstellung und -größen
- [ ] Interne/externe Links funktionieren
- [ ] SEO-Optimierung (Titel, Description, Tags, Keywords, HeroAlt)

### Hugo-Befehle

```bash
# Neuen Artikel erstellen
# Benutzte das heutige Datum!
hugo new blog/YYYY-MM-DD-artikel-name/index.md

# Lokale Vorschau mit Drafts
npm run dev

# Build für Produktion
npm run build
```

## Stylite-spezifische Elemente

### Autorenzeile
Artikel enden typischerweise mit:
```markdown
---

*[Autor Name] ist [Position] bei Stylite AG und beschäftigt sich schwerpunktmäßig mit [Fachbereich].*
```

### Projekt-Verweise
Immer GitHub-Links zu relevanten Stylite-Projekten einbinden:
```markdown
**Related Project**: [projekt-name](https://github.com/styliteag/projekt-name) - Kurze Beschreibung
```

### Kontakt-Call-to-Action
```markdown
Für Fragen zur Implementierung oder spezifischen Anwendungsfällen im [Bereich] stehe ich gerne zur Verfügung.
```

## Beispiel-Template

```markdown
---
title: "ZFS Performance-Optimierung für Enterprise-Systeme"
date: 2025-08-30T00:00:00+00:00
slug: "zfs-performance-enterprise"
authors: ["Wim Bonis"]
tags: ["Storage", "ZFS", "Performance"]
keywords: ["ZFS Performance Tuning", "Enterprise Storage Optimierung", "OpenZFS Benchmark", "Storage-Performance Analyse", "ZFS Konfiguration", "TrueNAS Performance"]
showHero: true
heroAlt: "ZFS Performance-Dashboard mit Tuning-Optionen und Benchmark-Ergebnissen für Enterprise-Storage-Systeme"
description: "Detaillierte Anleitung zur ZFS Performance-Optimierung in Enterprise-Umgebungen. Benchmarking, Tuning-Parameter und Best Practices."
---

![Header-Bild](feature.png)

Einleitender Absatz mit Problembeschreibung und Motivation...
```

## Hauptüberschrift

Hauptinhalt mit technischen Details...

### Unterüberschrift

Spezifische Implementierung oder Konfiguration...

```bash
# Code-Beispiel
sudo command --option value
```

## Fazit

Zusammenfassung und Ausblick...

---

*Autor Name ist Position bei Stylite AG und beschäftigt sich schwerpunktmäßig mit Fachbereich.*
```

Dieser Leitfaden stellt sicher, dass alle Blog-Einträge der Stylite AG Website ein konsistentes, professionelles Erscheinungsbild haben und technisch korrekt implementiert sind.

## SEO & URLs

- Slug: Füge in der Frontmatter stets einen kurzen, prägnanten `slug:` hinzu (3–6 Wörter, Kleinbuchstaben, Bindestriche), z. B. `slug: "zfs-vergleich-truenas"`.
- Beschreibung: Pflege `description:` mit 150–160 Zeichen je Artikel.
- Bilder: Sinnvolle `alt`‑Texte und sprechende Dateinamen verwenden.
- Interne Verlinkung: Verweise auf thematisch verwandte Artikel einbauen.

### Kürzere Artikel‑URLs (optional, empfohlen)

Aktuell enthalten Blog‑Pfadnamen ein Datum (z. B. `/blog/2025-08-29-dein-artikel/`). Für kürzere, stabile URLs kannst du auf `/blog/:slug/` umstellen:

1) Bestandsartikel vorbereiten (Slugs ergänzen und alte URLs als Aliases behalten):

```bash
node scripts/add-slugs-and-aliases.js --dry   # Vorschau
node scripts/add-slugs-and-aliases.js        # anwenden
```

2) Danach in `config/_default/hugo.toml` setzen:

```toml
[permalinks]
  blog = "/blog/:slug/"
```

Wichtig: Erst migrieren (Slugs + Aliases), dann die Permalinks umstellen, um 404s zu vermeiden.
