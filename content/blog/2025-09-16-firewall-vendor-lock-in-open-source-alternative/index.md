---
title: "Can't Live Without You? Die Firewall-Illusion und die Realität"
date: 2025-09-16T00:00:00+00:00
slug: "firewall-vendor-lock-in-open-source-alternative"
authors: ["Wim Bonis"]
tags: ["Security", "Firewall", "IT-Management", "Vendor-Beziehungen", "Open Source"]
keywords: ["Firewall Support Probleme", "IT-Vendor Enttäuschung", "Open Source Alternativen", "Linux Firewall Tools", "Vendor Lock-in", "Firewall Markt Krise", "IT-Support Frustration"]
showHero: true
heroAlt: "Leeres Firewall-Gehäuse mit gebrochenen Netzwerkkabeln, symbolisiert verlorene Liebe und Enttäuschung"
description: "Eine emotionale Geschichte über die Enttäuschung mit einer Firewall und eine kritische Analyse des Firewall-Marktes. Warum Open-Source-Tools oft besser sind als Vendor-Lösungen."
draft: false
---

{{<image src="feature.png" class="image-medium">}}

## I Can't Live, If Living Is Without You

Es begann wie in dem berühmten Song von Harry Nilsson - mit großen Hoffnungen und dem Glauben an die perfekte Partnerschaft:

## Die Verliebtheitsphase

Als wir die Firewall zum ersten Mal trafen, war es Liebe auf den ersten Blick. Sie war wunderschön - rote Farbe, elegante Formen, beeindruckende Spezifikationen. Der Verkäufer war charmant, lud uns zu Veranstaltungen ein, und die Demos liefen perfekt.

*"I can't live  
If living is without you..."*

Wir stellten uns eine Zukunft voller Sicherheit und Zuverlässigkeit vor. Die Implementierung verlief zunächst reibungslos, und wir waren überzeugt, die perfekte Firewall für unsere Infrastruktur gefunden zu haben.

## Die Ersten Zweifel

Doch dann kamen die ersten Probleme. Features, die als Standard angepriesen wurden, funktionierten nur teilweise. Die Performance brach unter Last ein, und komplexere Konfigurationen erwiesen sich als problematisch.

*"I can't give anymore..."*

Der Support reagierte langsam, die Antworten waren nichtssagend. Wir fühlten uns allein gelassen.

*"I can't live  
I can't give anymore..."*

## Das Tiefe Tal der Enttäuschung

Die Situation verschlechterte sich weiter. Kritische Sicherheitsfeatures versagten, und der Hersteller zeigte wenig Bereitschaft, die Probleme ernsthaft anzugehen. Wir investierten unzählige Stunden in Workarounds und Troubleshooting, doch nichts schien zu helfen.

*"Can't sleep at night  
Keep waking up..."*

Unsere Hoffnungen schwanden, und wir erkannten, dass diese "Beziehung" nicht die erfüllende Partnerschaft war, die wir uns vorgestellt hatten.

## Die Ernüchterung

Nach 6 Monaten voller Frustration und vergeudeter Ressourcen trafen wir die ernüchternde Erkenntnis: Diese Partnerschaft war nicht das romantische Märchen, das wir uns erhofft hatten. Wir blieben zusammen, aber die Begeisterung war verflogen.

*"I can't live
If living is without you..."*

Doch im Gegensatz zum Song haben wir gelernt, dass wir mit dieser Firewall leben können - wir müssen nur unsere Erwartungen anpassen und pragmatischer werden.

### Die Zweifel kommen auf

Im Laufe der Zeit stellten wir uns immer häufiger die Frage: **Hat es sich überhaupt gelohnt, diese Beziehung einzugehen?** Hätten wir nicht einfach alles mit Standard-Linux-Mitteln umsetzen sollen?

- **iptables** für die grundlegende Paketfilterung
- **nginx** als Reverse Proxy und Load Balancer
- **HAProxy** für fortschrittliches Load Balancing
- **OpenVPN** und **IPsec** für sichere VPN-Verbindungen

All das geht auch ohne Vendor-Lock-in und ohne teure Lizenzen. Und da steht ja kein "certified"-Stempel drauf, der suggeriert, dass es offiziell abgesegnet wäre. Aber funktioniert es deswegen schlechter? Oft im Gegenteil - es ist flexibler und besser dokumentiert.

### Die Krise der kleinen Firewalls

Diese Erfahrung lässt uns über die gesamte IT-Infrastruktur nachdenken: **Wie gehen wir heute mit Vendor-Abhängigkeiten um?** Kleine Firewall-Hersteller sterben reihenweise aus, weil sie die heutigen Anforderungen an die Softwarehersteller nicht umsetzen können:

- Komplexe Compliance-Anforderungen (GDPR, ISO 27001, etc.)
- Moderne Bedrohungslandschaft (Zero Trust, Cloud-Integration)
- Skalierbarkeit und Hochverfügbarkeit
- 24/7-Support und regelmäßige Security-Updates

Nur noch die großen Firewall-Anbieter überleben. Aber sind die wirklich besser? Oft sind sie genauso problematisch:

- **Proprietäre Lock-ins** statt offener Standards
- **Teure Maintenance-Verträge** statt kostengünstiger Alternativen
- **Langsame Feature-Entwicklung** durch bürokratische Prozesse
- **Vendor-Support**, der oft genauso schlecht ist wie bei den Kleinen

### Die Alternative: Open Source First

Vielleicht ist es an der Zeit, die Denkweise zu ändern: **Open Source First, Vendor Second.** Warum nicht mit bewährten Open-Source-Tools starten und nur dann zu kommerziellen Lösungen wechseln, wenn die Anforderungen es wirklich erzwingen?

*"I can't live
If living is without you..."*

Doch vielleicht können wir sehr wohl ohne diese spezielle Firewall leben - und sogar besser, mit Tools die wir kontrollieren können.

## Lessons Learned

Aus dieser schmerzhaften Erfahrung haben wir wichtige Erkenntnisse gewonnen:

### 1. Gründliche Evaluierung
- Nicht nur auf Marketing-Versprechen verlassen
- Eigene Proof-of-Concept Tests durchführen
- Referenzkunden intensiv befragen

### 2. Vertragsgestaltung
- Service-Level-Agreements vertraglich fixieren
- Support-Response-Zeiten definieren
- Exit-Strategien planen

### 3. Relationship-Management
- Regelmäßige Reviews etablieren
- Multiple Ansprechpartner definieren
- Eskalationsprozesse festlegen

### 4. Open Source First Strategie
- **Standard-Linux-Tools** als Ausgangspunkt wählen (iptables, nginx, HAProxy)
- **Vendor-Lösungen** nur bei nachgewiesenen Mehrwerten implementieren
- **Zertifizierungen** kritisch hinterfragen - "certified" bedeutet nicht automatisch "besser"
- **Kosten-Nutzen-Analyse** vor jeder Vendor-Entscheidung durchführen
- **Exit-Strategien** von Anfang an planen

## Die Neue Perspektive

Heute haben wir eine realistischere Sicht auf unsere Firewall-Beziehung. Wir sind vorsichtiger geworden, unsere Erwartungen sind angepasst, und wir wissen, dass nicht jedes "perfekte Match" auch ein romantisches Märchen garantiert.

*"I can't live
If living is without you..."*

Aber wir können - und wir tun es jeden Tag, indem wir unsere Anforderungen pragmatisch managen und die Stärken der Lösung optimal nutzen.

## Fazit

IT-Vendor-Beziehungen können wie Liebesgeschichten sein: Sie beginnen mit großen Versprechungen und werden manchmal zu pragmatischen Partnerschaften. Der Unterschied ist nur, dass wir bei Technologie die Wahl haben, unsere Erwartungen anzupassen oder uns zu trennen.

*"I can't live
If living is without you..."*

Doch im Gegensatz zum Song haben wir gelernt, dass wir mit dieser Firewall leben können - wir müssen nur unsere Erwartungen anpassen und pragmatisch mit den Gegebenheiten umgehen.

---

**Postscriptum**: Falls jemand vom ursprünglichen Hersteller mitliest - wir haben uns weiterentwickelt und sind jetzt in einer realistischeren "Beziehung" mit unserer aktuellen Firewall-Lösung.

---

*Wim Bonis ist CTO bei Stylite AG und hat in über 20 Jahren IT-Erfahrung viele "Liebesgeschichten" mit Technologie erlebt - sowohl die erfüllenden als auch die enttäuschenden.*
*Die Songzeilen sind von Harry Nilsson, der Titel ist "Without You".*