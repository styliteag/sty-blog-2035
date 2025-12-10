---
title: "Toxic Frame auf Netgate SG-2100: 49% und kein Byte weiter"
date: 2025-11-01T00:00:00+00:00
slug: "toxicframe-netgate-sg-2100"
authors: ["Wim Bonis"]
tags: ["toxicframe", "pfSense", "Netgate", "Firewall", "Switch",  "Network"]
keywords: [ "toxicframe", "Netgate SG-2100 toxic frame", "pfSense Switch mvneta", "IPsec SMB Hangs", "Marvell mvneta Treiber", "Marvell 6000 Switch", "Packet drop exact offset"]
showHero: true
description: "Ein Paketmuster (\"Toxic Frame\") stoppt SMB/HTTP exakt bei 49% auf Netgate SG‑2100 – Analyse, Reproduktion und Hinweise."
aliases: ["/blog/2025-11-01-toxicframe-netgate-sg-2100/"]
draft: false
unlisted: true
---

![Header-Bild](feature.png)

## TL;DR

Ein **Toxic Frame** auf der Netgate SG-2100 stoppt Dateiübertragungen über SMB/HTTP. Das Problem liegt in der Hardware des integrierten Marvell 6000 Switch und tritt auf, wenn der LAN-Port der SG-2100 am Switch beteiligt ist – unabhängig von VLAN-Konfiguration, Routing oder Firewall-Regeln. Das spezifische Datenmuster aus `toxic.bin` triggert den Bug deterministisch (z.B. bei einer bestimmten Datei exakt bei 49%). Wann genau der Bug getriggert wird und welche anderen Datenmuster ebenfalls problematisch sind, ist derzeit unklar. Reproduzierbar mit `toxic.bin`. Die Datei `nontoxic.bin` überträgt problemlos. Problem seit mindestens vier Jahren bekannt, keine Lösung gefunden. **Workaround:** **kein** Workaround bekannt.

---

## 🌙 Die nächtliche Reise beginnt

> "Wer reitet so spät durch Nacht und Wind?<br>
> Es ist der Vater mit seinem Kind<br>
> Er hat den Knaben wohl in dem Arm,<br>
> Er fasst ihn sicher, er hält ihn warm."

## Das Symptom – exakt 49%, dann Stillstand

> "Wer reitet so spät durch Netz und Port?<br>
> Es ist der Admin mit seinem Support.<br>
> Er hält die Datei wohl fest im Arm,<br>
> Bei neunundvierzig Prozent wird's warm."

Die Datei `stdww2.cab` (≈195 MB) bricht beim Übertragen über SMB stets an derselben Stelle ab: **exakt bei 49 %**. Nicht zufällig, nicht lastabhängig – millimetergenau. Das Verhalten ist ebenso über **HTTP** reproduzierbar (einfacher Test: `toxic.bin` über HTTP herunterladen). Der Befund: ein sogenannter **Toxic Frame** – ein spezifisches Datenmuster, das auf der Netgate **SG‑2100** (pfSense) nicht über die Switch‑Pfadlogik transportiert wird. Wann genau der Bug getriggert wird und welche anderen Datenmuster ebenfalls problematisch sind, ist derzeit unklar.

> "Mein Vater, mein Vater, jetzt fasst er mich an!<br>
> Erlkönig hat mir ein Leids getan!"

## Rahmenbedingungen und Ausschlussliste

- **Protokolle**: SMB, HTTP – gleicher Effekt
- **Topologien**: IPsec‑Tunnel und lokal über VLAN‑zu‑VLAN auf dem internen Switch – gleicher Effekt
- **VLAN-Konfiguration**: **Das Problem tritt auch ohne VLAN auf** – VLAN-Setup ist nicht die Ursache
- **Hardware-Anforderung**: Das Problem tritt auf, wenn der **LAN-Port der Netgate SG-2100 am integrierten Marvell 6000 Switch beteiligt ist** – unabhängig von VLAN-Konfiguration, Routing oder Firewall-Regeln
- **Clients/Dateien**: andere Dateien gleicher Größe oder Struktur – unauffällig
- **Zeit/Last**: unabhängig

Die Präzision des Abbruchs spricht gegen klassische MTU‑/Fragmentierungs‑ oder Bandbreitenthemen. Logs bleiben still. Es wirkt nicht wie Rate‑Limit oder DPI‑Block – eher wie ein deterministischer Drop auf einer spezifischen Bitfolge.

> "Mein Kunde, was birgst du so bang dein Gesicht?<br>
> Siehst, Admin, du den Fehler nicht?<br>
> Den Fehler-Frame mit Kron' und Schweif?"<br>
> "Mein Kunde, es ist ein Netzwerk-Greif."

## Reproduktion und Artefakte

- **Binärdaten**: `toxic.bin` vs. `nontoxic.bin`
  - `toxic.bin`: enthält das spezifische toxische Byte-Muster (extrahiert aus `stdww2.cab` bei 49%) – triggert den Bug deterministisch
  - `nontoxic.bin`: enthält zufällige Bytes ohne das problematische Muster – diese Datei wird problemlos übertragen, als Vergleichsbasis.
  
  **Testdateien zum Download** (HTTP-Links, um den Bug zu triggern):
  - [toxic.bin](http://toxicframe.stylite-live.net/toxic.bin)
  - [nontoxic.bin](http://toxicframe.stylite-live.net/nontoxic.bin)

- **Checksummen** (zum Verifizieren der Testdateien):

```txt
# sha256sum toxic.bin
c53442b8ebc2631d4326fb70cdcc62a5c452674ed306d31120235fc180cfd499  toxic.bin
# shasum toxic.bin
528a21bf89c2529122b8bcab429a983263aa5a62  toxic.bin
# md5sum toxic.bin
b5c1a508e7cd741b94d5645d81375fbc  toxic.bin
```

- **Videos**: Reproduktionen über SMB und HTTP (siehe Screenshots-Sektion)

## Technischer Verdacht

Die Tests deuten auf einen Drop im **Switch/SoC‑Pfad** der SG‑2100 hin (Marvell‑Plattform). Unabhängig vom Protokoll bricht der Fluss ab, sobald das „toxische" Sektor‑/Paketmuster ansteht. PCAP‑Dateien (`packetcapture-mvneta0.pcap`, `packetcapture-mvneta1.pcap`) unterstützen die These, dass ein sehr spezifischer Frame nicht übergeben wird. Das Verhalten reproduziert sich VLAN‑intern ohne IPsec – die IPsec‑Kette ist damit als Ursache ausgeschlossen.

**Wichtig:** Das Problem tritt **auch ohne VLAN-Konfiguration auf**. Entscheidend ist, dass der **LAN-Port der Netgate SG-2100 am integrierten Marvell 6000 Switch beteiligt ist** – unabhängig davon, ob VLANs konfiguriert sind oder nicht. Das VLAN-Setup ist nicht die Ursache des Problems.

**Hardware-Spezifikationen:**
- **CPU**: Dual-core ARM Cortex-A53
- **NIC**: Marvell 88E6141 (mvneta-Treiber)
- **Affected Interface**: mvneta1
- **pfSense-Version**: 25.07.x
- **Switch**: Marvell 6000-Switch

Die Extraktion des toxischen Sektors erfolgte mit:
```bash
dd if=stdww2.cab bs=1024 skip=99989 count=1 of=toxic.bin
```

PCAP‑Analysen zeigen: Die Übertragung stoppt abrupt ohne FIN/RST, das letzte ACK‑Paket wird nie beantwortet, der Frame enthält das toxische Byte‑Muster in der Payload. Die PCAP‑Dateien (`packetcapture-mvneta0.pcap`, `packetcapture-mvneta1.pcap`) sind in der Screenshots‑Sektion verlinkt.

> "Den Vater grauset's; er reitet geschwind,<br>
> Er hält in Armen das ächzende Kind;"

## Was wurde ausgeschlossen?

- **VLAN-Konfiguration**: Das Problem tritt mit und ohne VLAN auf – VLAN-Setup ist nicht die Ursache
- MTU/PMTUD‑Probleme: fragmentationsrelevante Tests ohne Befund
- Timeout/Rate‑Limit/DPI: keine korrespondierenden Log‑Events
- Datei/Client‑Spezifika: nur die „toxische" Sequenz triggert den Effekt
- Routing/Firewall-Regeln: unabhängig von der Konfiguration

**Kritische Erkenntnis:** Das Problem liegt in der **Hardware des Marvell 6000 Switch**, speziell wenn der **LAN-Port der Netgate SG-2100 am Switch beteiligt ist**. Es ist ein Hardware-bezogener Fehler auf Switch-Ebene, nicht konfigurationsbedingt.

## Systematisches Debugging

> "Ich liebe dich, mich reizt deine schöne Gestalt;<br>
> Und bist du nicht willig, so brauch' ich Gewalt."<br>
> "Mein Admin, mein Admin, jetzt fasst er mich an!<br>
> Der Toxic Frame hat mir ein Leids getan!"

Die Identifikation des Problems erforderte eine systematische Isolierung jeder Variable. Über mehrere Tage wurden Tests durchgeführt:

- Verschiedene Dateien gleicher Größe → **Kein Problem**
- Andere Dateien ähnlicher Struktur → **Kein Problem**
- Dieselbe Datei von verschiedenen Clients → **Problem tritt immer auf**
- Übertragung über andere Protokolle (HTTP) → **Problem tritt immer auf**
- Verschiedene Zeiten, verschiedene Lasten → **Problem bleibt konstant**
- Andere Internetlinks → **Problem tritt immer auf**
- Andere Firewallhersteller → **Kein Problem**
- Andere pfSense-Versionen → **Problem tritt immer auf**
- Parameterisierung der Firewall → **Problem tritt immer auf**

Die Erkenntnis: Es war nicht das Protokoll, nicht die Netzwerkverbindung im klassischen Sinne, sondern das spezifische Byte-Muster innerhalb der Datei. Mit binären Dumps wurde die Übertragung Byte für Byte analysiert – extrem zeitaufwändig und erfordert tiefes Verständnis der Netzwerk- und Dateisystem-Protokolle.

**Ein einzelner Sektor wurde nie übertragen.** Nicht verzögert, nicht korrupt, sondern einfach nicht übertragen. Die Verbindung brach exakt an dieser Stelle ab, jedes Mal, ohne Ausnahme.

## Warum war das so schwierig zu finden?

> "Dem Admin grauset's, er reitet geschwind,<br>
> Er hält in Armen das klagende Kind,<br>
> Erreicht das Datacenter mit Mühe und Not;<br>
> In seinen Armen das Paket war tot."


Dieses Problem zu debuggen war extrem schwierig, weil:

1. **Die Symptome täuschten**: Es sah zunächst wie ein typisches Netzwerkproblem aus
2. **Die Präzision war ungewöhnlich**: Dass ein Problem immer an exakt derselben Byte-Position auftritt, ist in der Netzwerktechnik extrem selten
3. **Die Isolierung war komplex**: Jede Variable musste systematisch isoliert werden – Protokoll, Route, Zeit, Last, Dateiinhalt
4. **Die Reproduzierbarkeit war schwierig**: Nicht jeder Sektor verursachte das Problem, sondern nur ein sehr spezifischer
5. **Die Transparenz war gering**: Standard-Netzwerk-Tools zeigen dieses Detail-Level nicht – binäre Dumps und sektorbasierte Analysen waren erforderlich

## Eine entmutigende Entdeckung

Bei der Recherche nach ähnlichen Fällen stießen wir auf eine [Reddit-Diskussion im r/PFSENSE Subreddit](https://www.reddit.com/r/PFSENSE/comments/twswig/weirdest_issue_ever_experts_needed_smb_hangs_over/) von **vor vier Jahren**, in der jemand genau dasselbe Problem beschrieben hatte.

> "Du feines Paket, so wohlgestalt,<br>
> Ich liebe dein Muster – so wohlerhalt';<br>
> Und bist du nicht willig, so brauch' ich Gewalt."

Die Beschreibung war praktisch identisch: SMB-Hangs über IPsec, eine Datei, die immer an derselben Stelle abbricht, Tests über verschiedene Protokolle – alles deckte sich mit unseren Beobachtungen. **Was jedoch besonders beunruhigend war:** Damals wurde keine Lösung gefunden. Die Diskussion endete ohne abschließende Antwort, ohne Fix, ohne Erklärung.

Das bedeutet, dass dieses Problem bereits seit mindestens **vier Jahren bekannt** sein sollte, aber offenbar nie richtig analysiert oder behoben wurde.

> "Mein Vater, mein Vater, jetzt fasst er mich an!<br>
> Der Erlkönig – Toxic Frame – hat mir ein Leids getan!"

## Die Herausforderung: Kommunikation mit Hersteller/Reseller

Wie erklärt man einem Support-Team, das normalerweise mit Standardproblemen zu tun hat, dass ein einzelner, spezifischer Sektor auf Hardware-Ebene nicht übertragen werden kann? Die meisten Support-Mitarbeiter haben noch nie von einem "Toxic Frame" gehört und werden zunächst an Konfigurationsfehler oder Anwenderfehler denken.

Die Dokumentation muss daher umfassen: Binäre Dumps der toxischen Sektoren, Testprotokolle über mehrere Tage, Screenshots, Schritt-für-Schritt-Analyse, PCAP-Dateien und Video-Beweise der reproduzierbaren Fehler. Die Herausforderung liegt nicht nur darin, das Problem zu dokumentieren, sondern auch darin, die Dringlichkeit und technische Komplexität so zu kommunizieren, dass der Hersteller es ernst nimmt.

**Für Hersteller/Reseller:** Ein detaillierter Bug-Report steht als [Bug Report](/blog/bugreport-toxicframe-netgate-sg-2100/) zur Verfügung und kann direkt an den Support weitergeleitet werden.

## Für Hersteller/Reseller: reproduzierbare Vorlage

- Testdatei: `stdww2.cab` (195 MB) – Abbruch bei 49 % (Beispiel für das Problem)
- Minimalbeispiel: `toxic.bin` (Hash s. oben) löst den Drop deterministisch aus; `nontoxic.bin` funktioniert einwandfrei
- Reproduktion: **LAN-Port der Netgate SG-2100 am integrierten Marvell 6000 Switch beteiligt** – tritt mit und ohne VLAN-Konfiguration auf, ebenso über IPsec. Einfacher Test: `toxic.bin` über HTTP herunterladen
- Erwartung: Übertragung ohne Abbruch; Ist‑Zustand: deterministischer Stillstand
- **Unklarheiten**: Wann genau der Bug getriggert wird und welche anderen Datenmuster ebenfalls problematisch sind, ist derzeit unklar

**Wichtig:** Das Problem ist **nicht VLAN-bezogen**. Es tritt auf, sobald der LAN-Port der SG-2100 am integrierten Marvell 6000 Switch beteiligt ist – unabhängig von VLAN-Konfiguration, Routing oder Firewall-Regeln. Die Screenshots zeigen zwar VLAN-Konfigurationen, dies diente jedoch nur zur Isolierung des Problems und ist nicht die Ursache.

Zur Eingrenzung wird empfohlen, den Paketpfad auf der SoC‑Ebene bzw. im Treiber‑Handling des **Marvell 6000 Switch-Interfaces** nach dieser spezifischen Bit‑/Frame‑Signatur zu prüfen.

> "In seinen Armen das Kind war tot."<br>
> <br>
> Der Admin schaudert, er reitet geschwind,<br>
> Trägt PCAPs und Checksums gegen den Wind.<br>
> Erreicht das Rack mit Müh’ und Not;<br>
> Bei neunundvierzig erstarrt der Knot.

## Fazit

Ein **Toxic‑Frame‑Bug** ist selten – hier jedoch klar reproduzierbar: **ein spezifisches Datenmuster** (wie in `toxic.bin` enthalten) stoppt den Transfer auf der SG‑2100 deterministisch (z.B. bei der Testdatei `stdww2.cab` exakt bei 49 %). Die Belege (Checksummen, Dumps, reproduzierbare Videos) sind konsistent. Wann genau der Bug getriggert wird und welche anderen Datenmuster ebenfalls problematisch sind, ist derzeit unklar. Bis zur Analyse seitens Hersteller/Reseller empfehlen wir, kritische Transfers über alternative Pfade/Hardware zu routen.

Um das Problem weiter zu verbreiten und betroffene Nutzer zu erreichen, verwenden wir den Hashtag **#toxicframe** für die Publikation und Kommunikation dieses Hardware-Bugs.

> "Und bist du nicht willig, mein Paket allein,<br>
> So wechsle die Hardware - dann wird's wieder fein!"

## Screenshots und weitere Ressourcen

**Screenshots:**
- [screenshot_1174.png](screenshot_1174.png) – Die Testumgebung, eine Netgate SG-2100 mit pfSense 25.07.x
- [screenshot_1175.png](screenshot_1175.png) – Die Netzwerkarten sowie VLAN der Hardware
- [screenshot_1176.png](screenshot_1176.png) – Das VLAN-Setup der Hardware
- [screenshot_1177.png](screenshot_1177.png) – Der integrierte Switch der Hardware
- [screenshot_1178.png](screenshot_1178.png) – Die Ports des integrierten Switches
- [screenshot_1179.png](screenshot_1179.png) – VLAN-Setup des Switches
- [screenshot_1180.png](screenshot_1180.png) – Fehlermeldung nach Abbruch der SMB-Verbindung
- [screenshot_1181.png](screenshot_1181.png) – Fehler beim Übertragen des problematischen Sektors via HTTP

**PCAP‑Dateien:**
- [packetcapture-mvneta0.pcap](packetcapture-mvneta0.pcap) – Packet‑Capture von mvneta0
- [packetcapture-mvneta1.pcap](packetcapture-mvneta1.pcap) – Packet‑Capture von mvneta1

**Videos:**
- [SMB‑Reproduktion](toxicframe_oversmb.mp4) – Video-Demonstration des Problems über SMB
- [HTTP‑Reproduktion](toxicframe_overhttp.mp4) – Video-Demonstration des Problems über HTTP

## Das Erlkönig-Gedicht, neue Nachdichtung

> Wer reitet so spät durch Nacht und Wind?<br>
> Es ist der Vater – Admin – mit Kind;<br>
> Er hält die Datei wohl fest im Arm,<br>
> Bei neunundvierzig wird’s plötzlich warm.<br>
> <br>
> „Mein Vater, mein Vater, siehst du den Schein?<br>
> Den Frame mit Krone im Byte-Geflecht?"<br>
> „Mein Sohn, mein Sohn, es ist ein Nebelstreif;<br>
> Ein Switch im Geäst, nur Netzwerk-Greif."<br>
> <br>
> „Du feines Paket, so wohlgestalt,<br>
> Ich liebe dein Muster – so wohlerhalt’;<br>
> Und bist du nicht willig, so brauch’ ich Gewalt."<br>
> <br>
> Es plätschert das TCP, der ACK bleibt aus,<br>
> Kein FIN, kein RST – nur stummer Graus;<br>
> VLAN hin, VLAN her – der LAN-Port bleibt dabei,<br>
> Marvell schweigt, mvneta gibt dich nicht frei.<br>
> <br>
> „Mein Vater, mein Vater, jetzt fasst er mich an!<br>
> Der Erlkönig – Toxic Frame – hat mir ein Leids getan!"<br>
> Der Vater schaudert, er reitet geschwind,<br>
> Trägt PCAPs und Checksums gegen den Wind.<br>
> <br>
> Erreicht das Rack mit Müh’ und Not;<br>
> Bei neunundvierzig erstarrt der Knot.<br>
> Er beugt sich nieder, der Atem stockt:<br>
> In seinen Armen das Kind war tot.<br>
> <br>
> Der Admin schaut, der Bugreport kommt,<br>
> Der Frame hat gesiegt, der Transfer versagt.<br>
> Vier Jahre schon, kein Fix, kein Licht, ich habe keine Macht –<br>
> Das Toxic Frame regiert die Nacht.

---

*Wim Bonis ist CTO der Stylite AG und beschäftigt sich schwerpunktmäßig mit Storage und Netzwerktechnik.*


