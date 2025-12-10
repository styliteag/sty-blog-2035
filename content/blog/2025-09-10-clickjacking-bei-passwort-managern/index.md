---
title: "Achtung: Neue Sicherheitslücke bei Passwort-Managern entdeckt!"
date: 2025-09-10T00:00:00+01:00
slug: "clickjacking-bei-passwort-managern"
authors: ["Matteo Keller"]
tags: ["cybersicherheit", "passwort-manager", "sicherheit", "clickjacking"]
categories: ["cybersicherheit", "datensicherheit"]
showHero: true
heroAlt: "Warnung vor Sicherheitslücke bei Passwort-Programmen"
description: "Eine neue Sicherheitslücke gefährdet beliebte Passwort-Manager. So schützen Sie Ihre Daten."
keywords: [
  "2025",
  "Passwort-Manager Sicherheitslücke",
  "Passwort-Manager Schutz",
  "Browser-Sicherheit",
  "Datenschutz",
  "Passwort-Sicherheit",
  "Online-Sicherheit"
  ]
aliases: ["/blog/2025-09-10-clickjacking-bei-passwort-managern/"]
---

Viele Menschen nutzen heute Programme, die ihre Passwörter sicher aufbewahren. Diese sogenannten Passwort-Manager machen das Leben einfacher, weil sie automatisch die richtigen Zugangsdaten in Login-Formulare eintragen.

Doch jetzt wurde eine neue Sicherheitslücke entdeckt. Hacker können diese Programme austricksen und so an Ihre persönlichen Daten kommen. Betroffen sind beliebte Tools wie [1Password](https://1password.com/), [Bitwarden](https://bitwarden.com/) und andere.

## Was ist diese neue Sicherheitslücke?

Stellen Sie sich vor, Sie sitzen in einem Restaurant und wollen die Speisekarte lesen. Jemand legt unbemerkt ein anderes Blatt Papier über Ihre Karte. Sie glauben, Sie zeigen auf "Pizza Margherita", aber in Wirklichkeit zeigen Sie auf "Pizza mit extra scharfen Chilischoten".

Genau so funktioniert dieser Angriff: Hacker legen eine unsichtbare Schicht über eine harmlose Website. Sie glauben, Sie klicken auf einen "OK"-Button für Cookies oder eine Werbung, aber in Wahrheit aktivieren Sie Ihr Passwort-Programm. Das Programm trägt dann automatisch Ihre persönlichen Daten in ein verstecktes Formular ein, das der Hacker kontrolliert.

## Wie läuft der Angriff genau ab?

Der Trick funktioniert in fünf Schritten:

1. **Der Köder**: Sie besuchen eine Website mit einem unsichtbaren Formular darunter
2. **Die Falle**: Über der Website liegt ein harmlos aussehender Button (z.B. "Cookies akzeptieren")
3. **Der Klick**: Sie klicken auf den Button und aktivieren dabei unbemerkt Ihr Passwort-Programm
4. **Die Daten**: Ihr Passwort-Manager trägt automatisch Benutzername und Passwort ein
5. **Der Diebstahl**: Die Daten landen direkt beim Hacker

Das Gefährliche: Sie merken nichts davon! Sie denken, Sie haben nur einen harmlosen Button gedrückt.

## Betroffene Passwort-Manager

Von der Schwachstelle betroffen sind zahlreiche Produkte, darunter:
- [1Password](https://1password.com/)
- [Bitwarden](https://bitwarden.com/)
- [Dashlane](https://www.dashlane.com/)
- [Enpass](https://www.enpass.io/)
- [iCloud Passwords](https://support.apple.com/de-de/HT204085)
- [Keeper](https://www.keepersecurity.com/)
- [LastPass](https://www.lastpass.com/)
- [NordPass](https://nordpass.com/)
- [ProtonPass](https://proton.me/pass)
- [RoboForm](https://www.roboform.com/)

Besonders gefährlich: Die Hacker können nicht nur Ihre Login-Daten stehlen, sondern auch andere persönliche Informationen wie Adresse, Telefonnummer oder Kreditkartendaten.

## Warum ist diese Lücke so gefährlich?

Diese Sicherheitslücke ist besonders tückisch, weil:

- **Sie merken nichts**: Der Angriff läuft komplett im Hintergrund ab
- **Vertrauen wird ausgenutzt**: Sie denken, Sie klicken nur einen harmlosen Button
- **Alle Daten sind gefährdet**: Nicht nur Passwörter, sondern alle gespeicherten Informationen
- **Schwer zu erkennen**: Es gibt keine verdächtigen Pop-ups oder Warnungen

Im Vergleich zu anderen Sicherheitslücken ist diese hier besonders gemein, weil sie Ihr Vertrauen in die Technik ausnutzt.

## Wie Sie sich schützen können

### 1. Halten Sie Ihre Programme aktuell
Die Hersteller der Passwort-Manager haben bereits Sicherheits-Updates herausgebracht. Stellen Sie sicher, dass Ihr Programm automatisch Updates installiert.

### 2. Seien Sie vorsichtig beim Klicken
Überlegen Sie zweimal, bevor Sie auf Buttons klicken:
- Ist der Button wirklich da, wo er hingehört?
- Vertrauen Sie der Website?
- Gibt es verdächtige Overlays oder Banner?

### 3. Schränken Sie Berechtigungen ein

In den Einstellungen Ihres Browsers können Sie festlegen, dass Ihr Passwort-Programm nicht automatisch auf allen Websites funktioniert, sondern nur wenn Sie es ausdrücklich erlauben.

Bei 1Password können Sie zusätzlich ein Bestätigungs-Popup aktivieren, das vor jedem automatischen Ausfüllen erscheint. Dies gibt Ihnen eine zusätzliche Sicherheitsschicht gegen Clickjacking-Angriffe.

{{<image src="images/2025-09-02-1PW-Screen.png" alt="1Password Einstellungen für zusätzliche Bestätigung" class="image-small">}}

Das führt dazu, dass bei jedem Ausfüllen nachgefragt wird:

{{<image src="images/2025-10-09-Blog-PW-Manager.png" alt="1Password Browser-Erweiterung Konfiguration" class="image-small">}}

### 4. Verwenden Sie zusätzliche Sicherheit
Aktivieren Sie die Zwei-Faktor-Authentifizierung für alle wichtigen Konten. Auch wenn jemand Ihre Zugangsdaten stiehlt, kommt er ohne den zweiten Faktor nicht hinein.

### 5. Seien Sie skeptisch bei verdächtigen Websites
Wenn eine Website seltsam aussieht oder Sie komische Pop-ups bekommen, verlassen Sie sie besser schnell.

## Was die Hersteller jetzt tun

Die Entwickler der Passwort-Manager arbeiten bereits an Lösungen:

- **Sicherheits-Updates**: Neue Versionen mit verbessertem Schutz
- **Bessere Überprüfungen**: Vor dem automatischen Ausfüllen wird genauer geprüft
- **Zusätzliche Sicherheitsschichten**: Mehr Bestätigungen und Warnungen

Die Tech-Industrie lernt aus solchen Vorfällen und macht die Programme sicherer. Aber auch Sie können viel tun, um sich zu schützen.

## Zusammenfassung

Passwort-Manager sind sehr praktisch und machen das Online-Leben einfacher. Aber wie bei allen technischen Hilfsmitteln gibt es auch Risiken. Diese neue Sicherheitslücke zeigt uns, dass wir vorsichtig bleiben müssen.

**Die gute Nachricht**: Die meisten Menschen werden wahrscheinlich nie Opfer dieses speziellen Angriffs. Aber es ist besser, vorbereitet zu sein.

**Was Sie jetzt tun können**:
- Installieren Sie Updates für Ihre Passwort-Programme
- Aktivieren Sie Zwei-Faktor-Authentifizierung
- Seien Sie vorsichtig beim Surfen im Internet

## Für Unternehmen

Firmen sollten besonders aufmerksam sein:

- **Schulungen für Mitarbeiter**: Erklären Sie, worauf sie achten müssen
- **Regelmäßige Updates**: Sorgen Sie dafür, dass alle Programme aktuell sind
- **Zusätzliche Sicherheit**: Nutzen Sie Zwei-Faktor-Authentifizierung überall
- **Überwachung**: Behalten Sie Browser-Erweiterungen im Auge

## Brauchen Sie Hilfe?

Haben Sie Fragen zu Passwort-Management oder brauchen Sie Unterstützung bei der Absicherung Ihrer Daten? Unser Team hilft Ihnen gerne weiter.

[Kontakt aufnehmen](mailto:info@stylite.de)

## Quellen & Weiterführende Links

### Nachrichten & Berichte
- [Passwort-Manager: Browser-Erweiterungen können Datenklau ermöglichen](https://www.heise.de/news/Passwort-Manager-Browser-Erweiterungen-koennen-Datenklau-ermoeglichen-10569024.html)
- [Passwort-Manager: Sicherheitslücken durch Clickjacking in Browser-Erweiterungen](https://www.connect.de/news/passwort-manager-sicherheitsluecken-clickjacking-browser-erweiterungen-3210379.html)

### Offizielle Security Advisories
- [Bitwarden Security Updates](https://bitwarden.com/blog/)
- [1Password Security Advisories](https://support.1password.com/security-updates/)
- [LastPass Security Center](https://www.lastpass.com/security/)
- [Dashlane Security Blog](https://www.dashlane.com/blog/category/security)

### Technische Ressourcen
- [OWASP Clickjacking Prevention Cheat Sheet](https://owasp.org/www-community/attacks/Clickjacking)
- [DEF CON 33 Presentations](https://defcon.org/html/defcon-33/dc-33-index.html)
- [Browser Extension Security Best Practices](https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/Security_best_practices)
