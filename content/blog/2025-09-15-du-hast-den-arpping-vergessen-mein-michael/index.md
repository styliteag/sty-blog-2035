---
title: "🎹 Du hast den ARP-Ping vergessen, mein Michael!"
date: 2025-09-15T10:00:00+00:00
slug: "du-hast-den-arping-vergessen"
authors: ["Wim Bonis"]
tags: ["Securepoint", "Firewall", "Failover", "ARP", "Network", "Troubleshooting"]
keywords: ["Securepoint", "Firewall", "Failover", "arping", "ARP", "Network", "Troubleshooting"]
showHero: true
description: "Wie ein vergessener ARP-Ping nach einem Failover die Erreichbarkeit von Extra-IPs verhindert - betrifft Switches und Provider-Gateways"
aliases: ["/blog/2025-09-15-du-hast-den-arping-vergessen-mein-michael/", "/blog/du-hast-den-arpping-vergessen/"]
---

> 🎸 "Du hast den ARP-Ping vergessen - mein Michael!" 🎶

![Header-Bild](feature.png)

## 🚨 Das Problem: Nach Failover sind Extra-IPs nicht erreichbar

Bei Securepoint UTM-Systemen kann es nach einem 🔄 Failover vom Master- zum Backup-System passieren, dass die konfigurierten Extra-IPs auf der externen Schnittstelle nicht mehr erreichbar sind. Dieses Problem tritt auf, weil die ARP-Tabelle der Switches im Netzwerk **oder das Gateway des Internetproviders** die MAC-Adresse noch mit der alten 🖥️ Firewall assoziiert hat.

> 🏖️ "Hoch stand der Sanddorn am Strand von Hiddensee, Micha, mein Micha, und alles tat so weh" 🌊

Ganz so, als hätte jemand nicht nur den entscheidenden Schritt vergessen, sondern auch den **Farbfilm für die Erinnerung** - und nun erscheint alles nur noch in **schwarzweiß** statt in der vollen, lebendigen Pracht.

## 📅 Wann passiert das?

Dieses Problem tritt typischerweise auf, wenn die Firewall mehrere (öffentliche) IP-Adressen auf der externen Schnittstelle konfiguriert hat.

Die Adressen 10.100.22.x sind Beispiele für eine solche Konfiguration:

```bash
ip -4 a
32: A1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    inet 10.100.22.2/28 scope global A1
       valid_lft forever preferred_lft forever
    inet 10.100.22.3/28 scope global secondary A1
       valid_lft forever preferred_lft forever
    inet 10.100.22.4/28 scope global secondary A1
       valid_lft forever preferred_lft forever
    inet 10.100.22.5/28 scope global secondary A1
       valid_lft forever preferred_lft forever
```
## 🤔 Warum passiert das?

> 💭 "So böse stampfte mein nackter Fuß den Sand, und schlug ich von meiner Schulter deine Hand" 🏖️

Nach einem Failover übernimmt die Backup-Firewall die IP-Adressen der Master-Firewall. Allerdings "weiß" der Switch im Netzwerk **oder das Gateway des Internetproviders** noch nicht, dass sich die MAC-Adresse für diese IP-Adressen geändert hat. Die ARP-Tabelle des Switches **oder des Provider-Gateways** enthält noch den alten Eintrag, wodurch Pakete an die falsche MAC-Adresse (die der alten Master-Firewall) gesendet werden.

Besonders bei Provider-Gateways kann dieses Problem häufiger auftreten, da diese oft eine längere ARP-Cache-Zeit haben und nicht so dynamisch auf Änderungen reagieren wie lokale Switches. Hier zeigt sich besonders deutlich, wie ein scheinbar kleiner "Denkfehler" in der Netzwerkarchitektur zu großen Problemen führen kann.

## 💡 Die Lösung: ARP-Ping senden

Um dieses Problem zu beheben, müssen wir die ARP-Tabelle der Switches und des Provider-Gateways aktualisieren. Dies geschieht durch das Senden von ARP-Pings von der neuen aktiven Firewall an das Gateway (in diesem Beispiel 10.100.22.1).

Der Befehl dafür lautet:

```bash
arping -I A1 10.100.22.1 -s 10.100.22.2
arping -I A1 10.100.22.1 -s 10.100.22.3
arping -I A1 10.100.22.1 -s 10.100.22.4
arping -I A1 10.100.22.1 -s 10.100.22.5
```

### Parameter-Erklärung:

- `-I A1`: Gibt die Netzwerkschnittstelle an (hier A1 - die externe Schnittstelle)
- `10.100.22.1`: Die Ziel-IP-Adresse (das Gateway des Internetproviders)
- `-s 10.100.22.x`: Die Quell-IP-Adresse (die jeweilige Extra-IP der Firewall)

## ⚙️ Wie das funktioniert

Durch den ARP-Ping wird ein ARP-Request-Paket von der Firewall an das Gateway des Internetproviders gesendet. Dieses Paket:

1. **🔄 Aktualisiert die ARP-Tabelle des Provider-Gateways**: Das Gateway lernt die neue MAC-Adresse für jede Extra-IP
2. **📢 Wird im lokalen Netzwerk gebroadcastet**: Lokale Switches hören das Paket ebenfalls mit und aktualisieren ihre eigenen ARP-Tabellen
3. **✅ Stellt die Erreichbarkeit wieder her**: Pakete werden nun korrekt an die aktive Firewall weitergeleitet

Da das ARP-Paket im gesamten Netzwerksegment als Broadcast versendet wird, erreicht es sowohl die lokalen Switches als auch das Gateway des Internetproviders - vorausgesetzt, diese befinden sich im gleichen Broadcast-Domain.

### Hinweis: Gratuitous ARP (GARP) vs. gezielter ARP-Request

In klassischen HA-Szenarien wird oft ein „Gratuitous ARP (GARP)“ gesendet – ein ARP-Announcement für die eigene IP per Broadcast –, damit Nachbarn ihre ARP-Caches auf die neue MAC aktualisieren. Manche Provider-Gateways ignorieren oder limitieren solche Broadcast-Announcements jedoch. Deshalb empfehlen wir hier gezielte ARP-Requests mit `arping` an das Gateway und `-s` je Extra-IP, weil diese in der Praxis zuverlässiger die Zuordnung beim Gateway aktualisieren.

## 🔧 Praktische Anwendung

Nach jedem 🔄 Failover sollte dieser Befehl für jede betroffene Extra-IP ausgeführt werden:

```bash
# Für jede Extra-IP wiederholen:
arping -I [interface] [extra-ip] -s [firewall-ip]
```

### ⏱️ Alternative: Einfach warten

> 🕐 "Nun sitz ich wieder bei dir und mir zu Haus, und such die Fotos für's Fotoalbum aus" 🏠

Router und Provider-Gateways haben typischerweise einen ARP-Cache zwischen **5-20 Minuten**. Wenn das Problem nicht kritisch ist, kann man auch einfach abwarten, bis der Cache automatisch verfällt und sich die ARP-Tabelle selbst aktualisiert.

Bei den meisten Provider-Gateways liegt die Cache-Zeit bei etwa **10-15 Minuten** - danach sollte die Erreichbarkeit automatisch wiederhergestellt sein. Diese "Warte-Strategie" ist besonders nützlich, wenn man keinen direkten Zugriff auf die Firewall hat oder der ARP-Ping-Befehl nicht verfügbar ist.

> 😢 "Aber, wie schrecklich, die Tränen kullern heiß, Landschaft und Nina und alles nur schwarzweiß" 💔

**ℹ️ Weitere Informationen zu typischen ARP-Cache-Werten:** [Reddit Discussion](https://www.reddit.com/r/networking/comments/3hcpfq/what_values_do_you_use_for_macaddress_and_arp/?show=original)


## 🎯 Fazit

> 🎥 "Du hast den Farbfilm vergessen, mein Michael! Nun glaubt uns kein Mensch, wie schön's hier war haha, haha" 🌈

Dieses Problem zeigt einmal mehr, wie wichtig es ist, die 🔌 Grundlagen des Netzwerkings zu verstehen. Ein einfacher ARP-Ping kann in kritischen Situationen den Unterschied zwischen einem funktionierenden und einem nicht-funktionierenden System ausmachen.

> 📷 "Du hast den Farbfilm vergessen bei meiner Seel', alles blau und weiß und grün und später nicht mehr wahr" 💭

Es geht hier um das fatale Vergessen wichtiger Details. Während andere einen **Farbfilm** vermissen und ihre Erinnerungen nur noch in **blau und weiß und grün** statt in voller Pracht sehen können, vergessen hier Firewalls und Netzwerkkomponenten die Aktualisierung ihrer ARP-Tabellen. Und genau wie beim vergessenen Farbfilm kann ein vergessenes ARP-Ping nach einem 🔄 Failover zu erheblichem 😱 Frust und ⏰ Ausfallzeiten führen - die schönen Farben der vollen Netzwerkverfügbarkeit verblassen zu einem tristen Schwarzweiß.

Besonders bei Provider-Gateways ist dieses Problem relevant, da diese oft außerhalb der eigenen Kontrolle liegen und längere Cache-Zeiten haben. Hier kann der ARP-Ping manchmal die einzige Möglichkeit sein, die Erreichbarkeit schnell wiederherzustellen.

**💡 Tipp:** In automatisierten 🔧 Failover-Scripts sollte dieser Befehl standardmäßig nach einem Failover ausgeführt werden, um solche Probleme von vornherein zu vermeiden. Bei Provider-Gateways kann es auch sinnvoll sein, die ARP-Cache-Zeit des Providers zu erfragen oder alternative Lösungsansätze zu prüfen.

> 🎵 "Tu das noch einmal Micha, und ich geh" 🚶‍♀️

Denn genau wie im Song: Einmal vergessen reicht schon, um alles zu ruinieren. Also besser gleich richtig machen!

---

*Bei Fragen zu Securepoint-Firewalls oder Netzwerkkonfigurationen steht Ihnen unser Team gerne zur Verfügung.*
