---
title: "TrueNAS Goldeye 25.10 – Einfachere Deployments und Terabit-Performance"
date: 2025-09-15T00:00:00+00:00
slug: "truenas-goldeye-25-10"
authors: ["Wim Bonis"]
tags: ["Storage", "TrueNAS", "ZFS", "Performance", "Enterprise", "AI", "KI", "Virtualisierung"]
keywords: ["TrueNAS Goldeye 25.10", "Terabit Ethernet", "TrueNAS Deployment", "ZFS Performance", "Enterprise Storage", "OpenZFS Acceleration", "RDMA Storage", "NVMe over Fabric", "TrueNAS Virtualization", "Data Hypervisor", "400GbE Support", "GPU Storage", "Storage Performance", "AI Workloads Storage"]
showHero: true
heroAlt: "TrueNAS Goldeye 25.10 – Moderne Enterprise-Storage-Lösung mit Terabit-Ethernet, vereinfachter Installation und AI-Optimierung"
description: "TrueNAS Goldeye 25.10 revolutioniert Enterprise-Storage: Webbasierte Installation, Terabit-Ethernet-Performance für KI-Workloads, erweiterte Virtualisierung und über 1.000 Verbesserungen für moderne Infrastrukturen."
---

{{<image src="feature.png" class="image-medium">}}


Nach der erfolgreichen Vereinigung von TrueNAS CORE und SCALE in der TrueNAS Community Edition mit Version 25.04 "Fangtooth" geht Goldeye den nächsten Schritt: Performance und Einfachheit stehen im Fokus. Mit über 120.000 bereits laufenden 25.04-Systemen liefert Goldeye über 1.000 gezielte Fixes und Verbesserungen – von der ersten Installation bis hin zu Terabit-Workloads.

**Hinweis zum Namen Goldeye:** Goldeye ist kein Goldfisch, sondern eine Art von Raubfisch aus der Familie der Karpfenfische. Der Name bezieht sich auf die goldenen Augen dieser Fischart. Weitere Informationen finden Sie auf [Wikipedia](https://de.wikipedia.org/wiki/Goldauge).

Nightly Builds von TrueNAS 25.10 sind bereits für Development und Testing verfügbar. Beta-Releases Ende August sammeln Community-Feedback vor dem Oktober-Launch. Enterprise-Empfehlungen folgen Anfang 2026.

## Einfache Installation und Updates

Die bisherige TrueNAS-Installation erforderte einen angepassten USB-Stick, Tastatur und Monitor oder ein serielles Konsolen-Kabel. Angesichts der rasanten Hardware-Entwicklung und dem Wunsch nach schnelleren Deployments wurde eine einfachere, webbasierte Installation in TrueNAS Goldeye integriert.

### Webbasierte Installation
Der neue Installationsprozess startet mit webbasierter Anleitung für USB-Erstellung und System-Boot. Der Installer startet einen sicheren, API-gesteuerten Installationsprozess in Verbindung mit einem kostenlosen Cloud-Service. Dadurch lassen sich TrueNAS installieren, SSL-Zertifikate konfigurieren, E-Mail-Alerts einrichten und grundlegende System-Reports erstellen – alles ohne lokale Konsole.

### Intelligente Software-Updates
TrueNAS Goldeye optimiert Software-Updates durch Integration mit den TrueNAS Software-Status-Empfehlungen. Das System-Profil lässt sich konfigurieren und Alerts werden nur für passende Updates gesendet – mit vollständiger Kontrolle über Zeitpunkt und Anwendung.

**Verfügbare Profile:**
- **General**: Stabile, getestete Updates für Produktionsumgebungen
- **Early Adopter**: Neueste Features mit höherem Risiko
- **Developer**: Nightly Builds für Entwickler und Tester

Jedes Update enthält eine kurze Release Notes-Zusammenfassung für einfachere Entscheidungen, mit Link zu den vollständigen Release Notes.

## Terabit-Ethernet-Performance für die KI-Welt

Während die meisten aktuellen Nutzer noch keinen GPU-Cluster für KI- und ML-Workloads haben, tun dies viele Business-Kunden bereits – noch mehr sind dabei, einen aufzubauen. Für diese Anwendungen ist 100GbE nicht zukunftssicher genug für die wachsenden Bandbreiten-Anforderungen. Goldeye liefert hier mit Terabit-Ethernet-Unterstützung in TrueNAS. Multi-Port 400GbE-Netzwerk-Interfaces ermöglichen GPU-Storage und andere High-Performance-Workloads ohne Budget-Sprengung.

### Technische Architektur für Terabit-Performance

Die Bereitstellung von Terabit-Ethernet-Performance erfordert sowohl eine vollständige Suite neuer Capabilities in der TrueNAS-Software als auch signifikante Änderungen in der TrueNAS-Appliance-Hardware:

### OpenZFS-Beschleunigung
ARC- und ZIL-Verbesserungen, einschließlich DirectIO für optimale Performance bei hohen IOPS

### RDMA
RDMA für Enterprise eliminiert TCP-Overhead und reduziert Latenz auf unter 1μs für kritische Workloads

### NVMe over Fabric
NVMe/TCP in der Community Edition enthalten, NVMe/RDMA auf Enterprise-Hardware für maximale Storage-Performance

### 400GbE-Support
Aktualisierte Treiber für neue NICs mit Multi-Port-Konfigurationen

### Next-Generation-Plattformen
DDR5 und PCIe Gen5 mit neuen CPUs und NICs für zukunftssichere Infrastrukturen

TrueNAS ist bereit, bestehende 100GbE-Kunden beim Übergang zu Terabit-Ethernet zu unterstützen und dabei ihre Storage-Investitionen zu bewahren. Bei Interesse an einem Übergang über 100GbE hinaus in 2026 steht TrueNAS gerne für Unterstützung zur Verfügung.

## Virtualisierungs-Verbesserungen

TrueNAS Goldeye bringt verschiedene Virtualisierungs-Verbesserungen, die es einer breiteren Zielgruppe ermöglichen, von Compute-Workloads nahe am Storage zu profitieren. Wie schon Fangtooth behält Goldeye den Electric Eel Virtualization Stack bei und fügt neue Backup- und VM-Migration-Capabilities hinzu.

### Enterprise High Availability
Für TrueNAS Enterprise Appliances wird HA-Failover für VMs aktiviert, damit Kunden ihre datenzentrierten Anwendungen mit TrueNAS Storage integrieren können. Sowohl Kunden als auch Anwendungs-Anbieter können die TrueNAS API nutzen, um spezifische Appliances für ihren Use Case zu erstellen – als Docker Container oder als VM für Datenzugriff.

### Der Data Hypervisor
Diese Capabilities werden als „Data Hypervisor" bezeichnet. Ob direkter ZFS-Datenzugriff durch Container-Mount oder der vollständige VM-Stack genutzt wird – ZFS liefert enorme Vorteile für Storage-Management mit eingebauter Datenreduzierung, Snapshots, RAID-Z und Copy-on-Write-Capabilities. Dies reduziert Latenz und eliminiert die Notwendigkeit für weitere redundante Netzwerk- und Compute-Hardware-Layer.

**ZFS-Vorteile für Virtualisierung:**
- **Native Datenreduktion**: Kompression und Deduplizierung ohne Performance-Verlust
- **Instant Snapshots**: Point-in-Time Backups ohne I/O-Impact
- **Copy-on-Write**: Effiziente Storage-Nutzung und schnelle Clones
- **RAID-Z**: Ausfallsichere Konfigurationen mit optimaler Performance

Der TrueNAS Data Hypervisor integriert KVM, ZFS und HA für datenzentrierte Anwendungen wie Backup und IoT-Management. Es bietet eine schlüsselfertige, einfach zu deployende Plattform, die von Gigabytes bis Petabytes skaliert. High Availability kann für kritische Business-Workloads mit TrueNAS Enterprise Appliances genutzt werden, aber dieselbe Virtualisierungs-Technologie ist in der Community Edition für alle Use Cases verfügbar.

### Integration mit Virtualisierungs-Plattformen
TrueNAS eignet sich hervorragend als Storage für traditionelle Virtualisierungs-Cluster, ob sie VMware, Hyper-V, Proxmox, Incus oder XCP-NG nutzen. Mit Support für verschiedene Protokolle – NFS, iSCSI, FC und die neuen NVMe-oF-Capabilities in Goldeye – können traditionelle Cluster Compute-Ressourcen skalieren, während TrueNAS konsistente, niedrig-latente, zuverlässige Storage-Optionen in Hybrid- oder All-Flash-Konfigurationen liefert.

## Wann sollte migriert werden?

Für neue TrueNAS-System-Deployments wird aktuell TrueNAS 25.04.2 empfohlen – wegen der Reife, Docker-Integration und robusten Validierung. Für Entwickler und Integratoren, die das Neueste von TrueNAS sehen möchten: Goldeye hat eine interne ALPHA abgeschlossen und ist als Nightly Image für Development und Testing verfügbar.

**Migrations-Timeline:**
- **August 2025**: TrueNAS 25.10 BETA-Testing startet
- **Oktober 2025**: RELEASE-Version für signifikante Upgrades
- **Januar 2026**: Goldeye wird für Enterprise-Nutzer empfohlen
- **Early Adopter**: Kontaktieren Sie das TrueNAS-Team für spezifische Feature-Verfügbarkeit

## Storage-Evolution

Die Entwicklung von TrueNAS zeigt deutlich: Storage ist nicht mehr nur passiver Datenspeicher, sondern wird zur aktiven Plattform für datenzentrierte Anwendungen. Mit Goldeye positioniert sich TrueNAS als zentrale Infrastruktur-Komponente für die KI-Ära – von Edge-Computing bis zu großen GPU-Clustern.

### Warum Goldeye die Zukunft des Enterprise-Storage ist

TrueNAS Goldeye 25.10 revolutioniert Enterprise-Storage mit über 1.000 gezielten Verbesserungen:

- **Webbasierte Installation**: Keine Hardware-Konsole mehr nötig
- **Terabit-Performance**: Zukunftssichere Infrastruktur für KI-Workloads
- **Erweiterte Virtualisierung**: Data Hypervisor für moderne Anwendungen
- **Intelligente Updates**: Profilbasierte, kontrollierte Software-Updates

Die Kombination aus ZFS-Power, Enterprise-Features und Community-Innovation macht TrueNAS zu einer zukunftssicheren Wahl für Organisationen, die ihre Storage-Infrastruktur für die nächste Dekade planen.

## Fazit und nächste Schritte

Als Storage-Spezialisten bei Stylite AG beobachten wir diese Entwicklungen mit großem Interesse. TrueNAS Goldeye 25.10 markiert einen bedeutenden Fortschritt in der Enterprise-Storage-Entwicklung mit Fokus auf Vereinfachung und Performance.

**Bereit für die Zukunft Ihres Storage?**

Bei Interesse an der Implementierung, Evaluierung oder Migration zu TrueNAS Goldeye 25.10 steht das Team von Stylite AG gerne für eine persönliche Beratung zur Verfügung. Kontaktieren Sie uns für eine individuelle Assessment Ihrer Storage-Anforderungen.

---

*Wim Bonis ist CTO bei Stylite AG und beschäftigt sich schwerpunktmäßig mit Enterprise-Storage-Lösungen und Open-Source-Technologien.*
