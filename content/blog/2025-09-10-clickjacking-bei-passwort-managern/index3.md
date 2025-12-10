---
title: "Neue Clickjacking Sicherheitslücke bei Passwort-Managern"
date: 2025-09-10T00:00:00+01:00
slug: "clickjacking-bei-passwort-managern"
authors: ["Matteo Keller"]
tags: ["cybersicherheit", "passwort-manager", "sicherheit", "clickjacking"]
categories: ["cybersicherheit", "datensicherheit"]
showHero: true
heroAlt: "Passwort-Manager Sicherheitslücke - Clickjacking Angriff auf Browser-Erweiterungen"
description: "Neue Clickjacking-Lücke gefährdet Passwort-Manager wie 1Password, Bitwarden und Co. Erfahren Sie, wie Sie sich schützen können."
keywords: [
  "2025",
  "Clickjacking",
  "Passwort-Manager Sicherheitslücke",
  "Clickjacking Angriff",
  "Browser-Erweiterung Schwachstelle",
  "1Password",
  "Bitwarden Clickjacking",
  "Passwort-Manager Schutz",
  "Browser-Sicherheit 2025",
  "IT-Sicherheit Unternehmen"
  ]
aliases: ["/blog/2025-09-10-clickjacking-bei-passwort-managern/"]
---

{{<image src="images/2025-10-09-Blog-PW-Manager.png" alt="Passwort-Manager Sicherheitsübersicht" class="image-small">}}

Passwort-Manager gehören für viele Nutzer längst zum Alltag: Sie erleichtern die Verwaltung komplexer und einzigartiger Passwörter, indem sie Zugangsdaten sicher speichern und mit praktischen Browser-Erweiterungen direkt in Online-Formulare einfügen. Doch eine neue Schwachstelle zeigt, dass auch die beliebtesten Tools wie [1Password](https://1password.com/), [Bitwarden](https://bitwarden.com/) und Co. nicht vor raffinierten Angriffen gefeit sind.

## Neue Clickjacking-Lücke bei Passwort-Managern

Ein IT-Forscher hat im Rahmen der [Defcon 33](https://defcon.org/) einen neuen Typ von [Clickjacking](https://owasp.org/www-community/attacks/Clickjacking)-Angriffen auf Browser-Erweiterungen von Passwort-Managern demonstriert. Angreifer nutzen dabei manipulierte Websites, die unsichtbare Formulare und Banner einblenden. Durch gezieltes Manipulieren des [Document Object Model (DOM)](https://developer.mozilla.org/en-US/docs/Web/API/Document_Object_Model) wird das Interface der Erweiterung ebenfalls unsichtbar – Opfer glauben, etwa auf ein Cookie-Banner zu klicken, lösen aber in Wirklichkeit das automatische Ausfüllen durch die Erweiterung aus. So können Angreifer sensible Daten wie Namen, Adressen oder Kreditkartendetails abgreifen.

### Wie der Angriff technisch funktioniert

Bei diesem speziellen Clickjacking-Angriff wird das DOM der Zielwebsite so manipuliert, dass:

1. **Unsichtbare Formulare** werden über der eigentlichen Website platziert
2. **Cookie-Banner oder Werbebanner** dienen als Köder für den Klick
3. **Die Browser-Erweiterung** wird durch den Klick aktiviert
4. **Sensible Daten** werden automatisch in die unsichtbaren Formulare eingetragen
5. **Daten werden an den Angreifer** übertragen

Dieser Angriff ist besonders gefährlich, weil er die Vertrauensstellung der Passwort-Manager ausnutzt – Nutzer erwarten schließlich, dass diese Tools ihre Daten schützen.

### Wie der Angriff im Detail funktioniert

Der Clickjacking-Angriff nutzt folgende Techniken:

1. **DOM-Manipulation**: Angreifer injizieren unsichtbare `<iframe>`-Elemente
2. **CSS-Overlay**: Banner werden über der echten Website platziert
3. **Event-Capturing**: Klicks werden abgefangen und umgeleitet
4. **Auto-Fill Trigger**: Die Browser-Erweiterung wird aktiviert

**Vereinfachter Angriffscode:**
```javascript
// Beispiel für DOM-Manipulation
const iframe = document.createElement('iframe');
iframe.src = 'https://victim-site.com';
iframe.style.opacity = '0';
iframe.style.position = 'absolute';
iframe.style.zIndex = '-1';
document.body.appendChild(iframe);

// Overlay für Clickjacking
const overlay = document.createElement('div');
overlay.style.position = 'absolute';
overlay.style.top = '0';
overlay.style.left = '0';
overlay.style.width = '100%';
overlay.style.height = '100%';
overlay.innerHTML = '<button>Cookie akzeptieren</button>';
document.body.appendChild(overlay);
```

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

Besonders kritisch: Auch nicht-Domain-spezifische Informationen können so abgegriffen werden, solange die Erweiterung so konfiguriert ist, dass sie auf beliebigen Seiten ausgefüllt wird.

## Vergleich mit anderen Browser-Extension-Lücken

| Lücke | Art | Auswirkung | Komplexität | Häufigkeit |
|-------|-----|------------|-------------|------------|
| **Clickjacking** | UI-Manipulation | Datenklau | Mittel | Häufig |
| **XSS in Extensions** | Code-Injection | Vollzugriff | Hoch | Selten |
| **Permission Abuse** | API-Missbrauch | Datenzugriff | Niedrig | Häufig |
| **Man-in-the-Middle** | Netzwerk-Interception | Session-Hijacking | Hoch | Mittel |

*Clickjacking ist besonders tückisch, da es keine offensichtlichen Code-Schwachstellen ausnutzt, sondern das Vertrauen der Nutzer in die Benutzeroberfläche.*

## So können Nutzer sich schützen

### Automatische Updates aktivieren
Die Entwickler mehrerer Passwort-Manager (u. a. Dashlane, Keeper, Nordpass, ProtonPass, RoboForm, Bitwarden) haben bereits Sicherheitsupdates bereitgestellt. Nutzer sollten die aktuelle Version ihres Passwort-Managers nutzen und automatische Updates aktiv halten.

### Automatisches Ausfüllen deaktivieren
Wer das Risiko minimieren will, sollte das automatische Ausfüllen in kritischen Fällen abstellen und Login-Daten manuell kopieren.

### Einstellung für exakte URL-Übereinstimmung wählen
Viele Passwort-Manager bieten die Option, das Ausfüllen nur bei exakter Adress-Übereinstimmung zu erlauben. Das verhindert, dass etwa Subdomains missbraucht werden.

### Browser-Berechtigungen einschränken
Bei Chromium-Browsern kann in den Erweiterungseinstellungen das Recht „Auf allen Webseiten" auf „Nur bei Klick" reduziert werden – die Erweiterung füllt dann nur nach gezieltem Klick die Daten aus.

### Tools zur Erkennung von Clickjacking

Für fortgeschrittene Nutzer und Sicherheitsexperten stehen folgende Tools zur Verfügung:

- **[OWASP ZAP](https://www.zaproxy.org/)**: Kostenloser Security Scanner mit speziellen Clickjacking-Tests
- **[Burp Suite](https://portswigger.net/burp)**: Professionelles Penetration Testing Tool mit DOM-Manipulation-Modulen
- **Browser DevTools**: CSS- und DOM-Inspektion zur Erkennung von Overlays
- **Custom Scripts**: Browser-Erweiterungen wie "[uBlock Origin](https://ublockorigin.com/)" mit Anti-Clickjacking-Regeln

*Regelmäßige Sicherheitsscans können helfen, potenzielle Clickjacking-Angriffe frühzeitig zu erkennen.*

## Langfristige Lösungsansätze für Entwickler

Passwort-Manager-Entwickler sollten diese Maßnahmen implementieren, um Clickjacking nachhaltig zu verhindern:

### Technische Maßnahmen
- **[Content Security Policy (CSP)](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP)**: Strenge CSP-Header implementieren
- **[Same-Origin-Policy](https://developer.mozilla.org/en-US/docs/Web/Security/Same-origin_policy)**: Ursprungsprüfungen für alle API-Calls
- **User Interaction Checks**: Explizite Bestätigung vor Auto-Fill-Operationen
- **Extension API Security**: Sichere Kommunikation zwischen Extension und Webseite

### Browser-Integration
- **[WebExtensions API](https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions)**: Moderne, sicherere Browser-APIs verwenden
- **Permission Model**: Granulare Berechtigungen statt "Alle Websites"
- **[Secure Contexts](https://developer.mozilla.org/en-US/docs/Web/Security/Secure_Contexts)**: Nur HTTPS-Verbindungen erlauben

### Monitoring und Reaktion
- **Security Audits**: Regelmäßige Code-Reviews und Penetration-Tests
- **Incident Response**: Schnelle Reaktion auf entdeckte Schwachstellen
- **User Education**: Integrierte Sicherheitshinweise in der Software

*Die Industrie arbeitet aktiv an der Verbesserung der Sicherheit von Browser-Erweiterungen, aber auch Entwickler tragen eine große Verantwortung.*

## Fazit

Passwort-Manager sind wertvolle Werkzeuge, doch auch sie sind nicht unfehlbar. Es lohnt sich, Einstellungen kritisch zu prüfen und die eigene Software konsequent aktuell zu halten, um neue Angriffsmöglichkeiten wie DOM-basiertes Clickjacking nachhaltig auszuschließen.

Der Nutzer sollte überlegen, ob man aus Gründen der Sicherheit den zusätzlichen Klick machen möchte. Es ist auch zu beachten, dass diese Einstellung in jedem Browser durchzuführen ist. Das vollständige Ausschalten des automatischen Ausfüllens des Passworts führt nicht unbedingt zu mehr Sicherheit, sondern bringt neue Probleme mit sich, hier kommt der Faktor Mensch wieder mehr ins Spiel. Es handelt sich hierbei um ein vorerst theoretisches Sicherheitsproblem, welches aber schnell Realität werden kann.

{{<image src="images/2025-09-02-1PW-Screen.png" alt="1Password Sicherheitseinstellungen gegen Clickjacking" class="image-small">}}

Bei 1Password führt die erweiterte Einstellung dazu, dass ein zusätzlicher Klick ausgelöst werden muss, bevor das Passwort automatisch eingetragen wird. Wie im Screenshot oben zu sehen, können Nutzer diese Sicherheitsmaßnahme in den Browser-Erweiterungseinstellungen aktivieren.

## Empfehlungen für Unternehmen

Für Unternehmen ist diese Sicherheitslücke ein weiteres Argument für eine ganzheitliche Sicherheitsstrategie:

- **Regelmäßige Security-Audits** der eingesetzten Passwort-Manager
- **Mitarbeiterschulungen** zu aktuellen Bedrohungen
- **[Multi-Faktor-Authentifizierung](https://de.wikipedia.org/wiki/Zwei-Faktor-Authentisierung)** als zusätzliche Sicherheitsebene
- **Monitoring** von Browser-Erweiterungen und deren Berechtigungen

## Kontaktieren Sie uns

Haben Sie Fragen zu Passwort-Management oder brauchen Sie Hilfe bei der Absicherung Ihrer Unternehmens-IT? Kontaktieren Sie unser Team für eine individuelle Beratung zu Cybersecurity-Lösungen.

[Kontakt aufnehmen](mailto:info@stylite.ch)

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

### Tools & Testing
- [OWASP ZAP (Zed Attack Proxy)](https://www.zaproxy.org/)
- [Burp Suite Community Edition](https://portswigger.net/burp/communitydownload)
