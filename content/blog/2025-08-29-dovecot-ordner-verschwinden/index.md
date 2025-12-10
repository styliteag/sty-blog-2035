---
title: "Wenn E-Mail-Ordner plötzlich verschwinden - Ein Dovecot-Mysterium"
date: 2025-08-29T00:00:00+00:00
slug: "dovecot-ordner-verschwinden"
authors: ["Wim Bonis"]
tags: ["Bug", "Dovecot", "UCS"]
keywords: ["Dovecot Troubleshooting", "E-Mail-Server Problem", "UCS Mail-Server", "IMAP Ordner verschwinden", "Dovecot Cache Problem", "Mail-Server Debugging", "E-Mail-Administration"]
showHero: true
heroAlt: "Dovecot E-Mail Server Debugging und Troubleshooting Interface mit Logs und Cache-Konfiguration"
description: "Nach einem UCS-Update verschwinden plötzlich E-Mail-Ordner bei Nutzern. Die Lösung eines hartnäckigen Dovecot-Cache-Problems nach 7 Tagen Fehlersuche."
aliases: ["/blog/2025-08-29-dovecot-ordner-verschwinden/"]
---

Es begann mit einer harmlosen Support-Anfrage: "Die E-Mail-Ordner sind weg!" Was folgte, war eine siebentägige Fehlersuche durch die Tiefen von Dovecot, UCS und diversen Konfigurationsdateien.

## Das Problem zeigt sich

Nach einem routinemäßigen Update von UCS 5.0 auf 5.2 begannen die Beschwerden. Nutzer berichteten über ein merkwürdiges Phänomen: Ihre komplette Ordnerstruktur in den E-Mail-Clients verschwand plötzlich. Stattdessen sahen sie nur noch die Standard-Ordner - Posteingang, Gesendet, Spam - alle komplett leer.

Das besonders Frustrierende: Nach 3 bis 5 Minuten baute sich die Ordnerstruktur wie von Geisterhand wieder auf. Die E-Mails waren wieder da, als wäre nichts gewesen. Bis zum nächsten Mal.

## Die Symptome im Detail

Die Probleme traten nicht bei allen Nutzern gleichzeitig auf, sondern scheinbar willkürlich:
- Betroffene Clients: Thunderbird, EGroupware, mobile Mail-Apps
- Dauer des Ausfalls: 3-5 Minuten
- Häufigkeit: Bei manchen Nutzern alle 30 Minuten
- Besonders auffällig nach der Urlaubszeit (höhere Last)

## Die erfolglose Fehlersuche

Die ersten Verdächtigen waren die üblichen Kandidaten. Dovecot meldete Limit-Probleme? Also wurden erhöht:
```bash
mail/dovecot/limits/auth/client_limit
mail/dovecot/limits/anvil/client_limit
```

Index-Synchronisation könnte schuld sein? Der Parameter `mail/dovecot/process/mail_fsync` wurde von "optimized" auf "always" gesetzt. Dovecot neu gestartet. Ergebnis: Keine Besserung.

Die Logfiles? Zunächst fanden sich Einträge über neu erstellte Index-Dateien im debug-log - Dovecot rekonstruierte diese immer wieder, weil sie angeblich korrupt waren.

Eine erst mal falsche Spur, wie sich herausstellte. Aber wir kommen gleich dazu was wirklich passierte.


## Nicht allein mit dem Problem

Interessanterweise berichten auch andere Administratoren von ähnlichen Problemen bei Dovecot. In den Univention-Foren finden sich mehrere verwandte Problemberichte:

- [E-Mail-Probleme nach Mailserver-Update](https://help.univention.com/t/e-mail-probleme-nach-mailserver-update-auf-ucs/24123) - Ähnliche Symptome nach UCS-Updates
- [Random Empty Folder Display](https://help.univention.com/t/random-empty-folder-display-with-various-imap-clients/24198) - Leere Ordner bei verschiedenen IMAP-Clients
- [Inotify Limit Exceeded](https://help.univention.com/t/problem-dovecot-warns-about-inotify-instance-limit-for-user-120-uid-dovemail-exceeded/13572) - Möglicherweise verwandte Ressourcen-Limits

Die Probleme haben sich teilweise sogar noch verschärft mit Symptomen wie:
- Vervielfachung von E-Mails im Posteingang
- Wiederauftauchen längst gelöschter E-Mails
- Korrupte Mailbox-Indizes

## Der entscheidende Hinweis

Nach einer Woche intensiver Suche stieß die Recherche auf einen [Bug-Report im Univention-Forum](https://help.univention.com/t/dovecot-seltsame-userordern-im-hauptverzeichnis/9849/) aus dem Jahr 2018. Zunächst hatten wir diesen Thread ignoriert - er bezog sich auf alte UCS- und Dovecot-Versionen und der Bug wurde damals offensichtlich gelöst. Warum sollte ein alter, behobener Fehler wieder auftauchen?

Wir überprüften dennoch die dort beschriebenen Symptome - und tatsächlich: Wir fanden User-Ordner direkt in `/var/spool/dovecot/private/`, die nur die Standard-Ordnerstruktur enthielten, aber keine E-Mails. Normalerweise sollten die User-Daten unter `/var/spool/dovecot/private/<domainname>/` liegen. Hier wurden also die Index-Dateien angelegt. Und hier waren auch ein paar verschwundene Mails wieder auffindbar.

Das war der entscheidende Hinweis: Dovecot "verlor" offenbar die Domain nach dem "@" in den E-Mail-Adressen! Die Nutzer wurden temporär ohne ihre Domain authentifiziert, weshalb sie leere Mailboxen sahen. Der alte Bug war zurück. Die im Forum vorgeschlagene Lösung schien absurd einfach.

## Die (temporäre) Lösung

Ein einziger UCR-Befehl brachte die Erlösung:
```bash
ucr set mail/dovecot/auth/cache_size="0"
```

Dieser Befehl deaktiviert den Authentication-Cache von Dovecot komplett. Und tatsächlich: Die Ordner verschwanden nicht mehr.

## Was ist hier passiert?

Das UCS-Update von 5.0 auf 5.2 brachte einen Versionssprung mit sich:
- Debian 10 → Debian 12
- Dovecot 2.3.4 → 2.3.19

Das eigentliche Problem liegt im Authentication-Cache von Dovecot: Bei mehreren gleichzeitigen Anmeldungen (die genauen Bedingungen sind noch nicht vollständig geklärt) "vergisst" der Cache den Domain-Teil der E-Mail-Adresse. Der Bug tritt besonders dann auf, wenn sich ein User gleichzeitig von verschiedenen Geräten oder mit verschiedenen Verfahren (IMAP, ActiveSync, etc.) einloggt. Unter diesen Bedingungen führt der fehlerhafte Cache dazu, dass Dovecot auf den falschen Pfad der Mailboxen zugreift und sich dann auch die anderen Sessions desselben Users falsch verhalten.

Ein `doveadm who` Befehl bestätigte unseren Verdacht: Dort waren User tatsächlich mit und ohne Domain gleichzeitig eingeloggt! Zum Beispiel erschien derselbe Nutzer als "max.mustermann" und als "max.mustermann@domain.de" in der Session-Liste.

Kurz haben wir auch getestet, ob ein direkter IMAP-Login ohne Domain möglich wäre - hier verhält sich Dovecot korrekt und weist solche Login-Versuche ab. Das Problem entsteht also ausschließlich intern durch den fehlerhaften Cache.

Das erklärt auch, warum nicht alle UCS/Dovecot-Installationen betroffen sind: Kunden mit wenigen Nutzern oder solche, die hauptsächlich nur ein Gerät pro User verwenden, werden das Problem möglicherweise nie bemerken. Erst bei intensiver Nutzung mit mehreren parallelen Verbindungen zeigt sich der Fehler.


## Die Warnung

**Wichtig:** Das Deaktivieren des Authentication-Cache ist nur eine temporäre Lösung! Mögliche Nebenwirkungen:
- Erhöhte Last auf dem Authentication-Backend
- Langsamere Anmeldungen bei vielen gleichzeitigen Verbindungen
- Potentielle Performance-Probleme bei großen Installationen

Für produktive Umgebungen sollte diese Lösung nur als Notfall-Workaround betrachtet werden, bis ein echter Fix verfügbar ist.

**Update:** UCS/Univention führt das Problem mittlerweile als Bug und arbeitet an einer dauerhaften Lösung ([Bug 57976](https://forge.univention.org/bugzilla/show_bug.cgi?id=57976)). Der Support von Univention hat sich sehr kompetent um das Problem gekümmert, war aber zunächst genauso ratlos wie wir - ein Zeichen dafür, wie tückisch dieser Bug ist. Sobald es Neuigkeiten gibt, wird dieser Artikel aktualisiert.


## Fazit und Ausblick

Die Dovecot-Situation ist derzeit unbefriedigend. Version 2.3.x wird nicht mehr gepflegt, nur noch 2.4 wird weiterentwickelt. Allerdings wurden in 2.4 Features entfernt, die manche Installationen benötigen - ein Dilemma für Administratoren.

Einige Kollegen in der Community evaluieren bereits Alternativen wie Stalwart Mail Server als moderne Rust-basierte Lösung. Ob das die Zukunft ist? Die Zeit wird es zeigen.

Bis dahin bleibt: Bei mysteriösen E-Mail-Problemen nach UCS-Updates lohnt ein Blick auf den Dovecot Authentication-Cache. Manchmal liegt die Lösung in den Tiefen alter Forum-Threads verborgen.

## Hilfreiche Links

- [Dovecot Domain Lost Documentation](https://doc.dovecot.org/2.3/configuration_manual/authentication/domain_lost/)
- [Univention Forum: Dovecot seltsame Userordner](https://help.univention.com/t/dovecot-seltsame-userordern-im-hauptverzeichnis/9849/)
- [Univention Forum: Random Empty Folder Display](https://help.univention.com/t/random-empty-folder-display-with-various-imap-clients/24198)

---

*Wim Bonis ist CTO bei Stylite AG und beschäftigt sich schwerpunktmäßig mit Storage-Lösungen und IT-Infrastruktur.*
