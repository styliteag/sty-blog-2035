# SEO Keywords Strategy Guide

Dieser Leitfaden erklärt die SEO-Keyword-Strategie für die Stylite AG Website.

## System-Überblick

### Dual-System: Tags vs. Keywords

**👥 Tags (User-sichtbar):**
- Werden in Navigation, Menüs und Tag-Seiten angezeigt
- Sauber, kategoriebasiert, benutzerfreundlich
- Für interne Verlinkung und Site-Navigation
- Beispiel: `["Storage", "Security", "ZFS", "Tools"]`

**🔍 Keywords (SEO-hidden):**
- Nur in Meta-Tags und strukturierten Daten
- Long-Tail Keywords mit geringer Konkurrenz
- Spezifisch und zielgruppenorientiert
- Beispiel: `["ZFS Performance Tuning", "Enterprise Storage Setup", "Ransomware Protection"]`

## Keyword-Strategien nach Thema

### Storage-Artikel
```yaml
tags: ["Storage", "ZFS", "Tools"]
keywords: [
  "ZFS Performance Tuning",
  "TrueNAS Enterprise Setup", 
  "OpenZFS Configuration",
  "Enterprise Storage Solutions",
  "NAS vs SAN Vergleich",
  "Storage Hardware Optimization"
]
```

### Security-Artikel
```yaml
tags: ["Security", "Tools"]
keywords: [
  "Cybersecurity Implementation",
  "Phishing Prevention Strategies",
  "IT Security Unternehmen",
  "Ransomware Protection",
  "Email Security Solutions",
  "Network Security Monitoring"
]
```

### Cloud-Artikel
```yaml
tags: ["Cloud", "Tools"]
keywords: [
  "SaaS Implementation",
  "Private Cloud Setup",
  "Cloud Migration Strategy",
  "Enterprise Cloud Solutions",
  "Self-Hosted Cloud",
  "Cloud Security Best Practices"
]
```

### Tools-Artikel
```yaml
tags: ["Tools", "Docker", "Monitoring"]
keywords: [
  "Open Source Tools",
  "Docker Container Management",
  "DevOps Automation",
  "Self-Hosted Solutions",
  "System Monitoring Tools",
  "Enterprise Tool Stack"
]
```

## Long-Tail Keyword Beispiele

### Warum Long-Tail?
- **Geringere Konkurrenz**: Einfacher zu ranken
- **Höhere Conversion**: Spezifischere Suchintention
- **Bessere CTR**: Genau das, wonach User suchen

### Storage Long-Tail Keywords
- ❌ "Storage" (zu breit, Millionen Konkurrenten)
- ✅ "ZFS Performance Tuning Enterprise" (spezifisch, weniger Konkurrenz)

- ❌ "NAS" (zu generisch)  
- ✅ "TrueNAS Setup für KMU" (zielgruppenspezifisch)

- ❌ "Backup" (überfüllt)
- ✅ "ZFS Snapshot Backup Strategie" (technisch spezifisch)

### Security Long-Tail Keywords
- ❌ "Security" (zu breit)
- ✅ "Phishing Prevention für Unternehmen" (zielgruppe + lösung)

- ❌ "Ransomware" (umkämpft)
- ✅ "Ransomware Schutz mit ZFS Snapshots" (technische Lösung)

- ❌ "VPN" (gesättigt)
- ✅ "ZTNA vs VPN Unternehmensvergleich" (spezifischer Vergleich)

## Deutsche vs. Englische Keywords

### Deutsche Keywords (Primärzielgruppe)
- "IT-Sicherheit Unternehmen"
- "Storage-Lösung Deutschland" 
- "Cybersicherheit Beratung"
- "NAS-System Vergleich"

### Englische Keywords (Secondary)
- "Enterprise Storage Solutions"
- "ZFS Performance Optimization"
- "Self-Hosted Monitoring"
- "Docker Container Security"

## Keyword-Recherche Tools

### Kostenlose Tools
- Google Keyword Planner
- Ubersuggest (limitiert)
- Answer The Public
- Google Trends

### Paid Tools
- SEMrush
- Ahrefs
- Moz Keyword Explorer

## Best Practices

### Do's ✅
- **6-8 Keywords pro Artikel** (nicht übertreiben)
- **Mix aus Brand + Generic Keywords**
- **Deutsche Keywords für DE-Zielgruppe**
- **Technische Spezifität** ("ZFS" statt "Storage")
- **Zielgruppe einbeziehen** ("Unternehmen", "Enterprise", "KMU")

### Don'ts ❌
- **Keyword Stuffing** (zu viele Keywords)
- **Zu generische Terms** ("Tools", "Security")  
- **Konkurrenz mit Amazon/Wikipedia** (unmöglich zu gewinnen)
- **Keyword Kannibalisierung** (gleiche Keywords auf mehreren Seiten)

## Technische Implementation

### Frontmatter Struktur
```yaml
---
title: "Artikel Titel"
tags: ["User", "Friendly", "Tags"]
keywords: ["SEO Specific Keywords", "Long Tail Keywords", "Target Audience Terms"]
heroAlt: "Alt text für Feature Image mit Keywords"
description: "SEO Description mit Primary Keyword"
---
```

### Meta-Tag Rendering
```html
<!-- Automatisch generiert durch layouts/partials/head-seo.html -->
<meta name="keywords" content="ZFS Performance Tuning, Enterprise Storage, TrueNAS Setup" />
```

### JSON-LD Integration
```json
{
  "@context": "https://schema.org",
  "@type": "BlogPosting",
  "keywords": ["ZFS Performance Tuning", "Enterprise Storage", "TrueNAS Setup"]
}
```

## Performance Tracking

### Metriken zu überwachen
- **Organic Traffic**: Zunahme durch bessere Rankings
- **Keyword Rankings**: Position für Target-Keywords
- **CTR**: Click-Through-Rate in Search Results
- **Bounce Rate**: Relevanz des Contents für Keywords

### Tools für Tracking
- Google Analytics 4
- Google Search Console  
- Matomo (bereits implementiert)
- Semrush Position Tracking

## Konkurrenz-Analyse

### Hauptkonkurrenten (Storage)
- TrueNAS Documentation
- ZFS on Linux Wiki
- Enterprise Storage Blogs
- IT-Systemhaus Blogs

### Keyword-Gaps finden
- Was rankt bei Konkurrenten?
- Welche Keywords sind unbesetzt?
- Wo können wir technische Expertise ausspielen?

---

*Dieser Guide wird regelmäßig basierend auf SEO-Performance und Keyword-Trends aktualisiert.*