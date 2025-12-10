---
title: "Bug Report: Toxic Frame on Netgate SG-2100"
date: 2025-10-31T00:00:00+00:00
draft: false
slug: "bugreport-toxicframe-netgate-sg-2100"
unlisted: true
---

# Bug Report: Toxic Frame on Netgate SG-2100

**Hardware:** Netgate SG-2100  
**Software:** pfSense 25.07.x  
**Date:** 2025-10-31  
**Reporter:** Stylite AG  
**Severity:** Critical (Hardware-related packet drop)

## Summary

A reproducible hardware bug causes file transfers to abort deterministically when transferring specific byte patterns over SMB or HTTP through the Netgate SG-2100. The issue occurs in the integrated Marvell 6000 Switch hardware and is independent of VLAN configuration, routing, or firewall rules.

**For detailed analysis and debugging steps, see the full article:** [Toxic Frame on Netgate SG-2100: 49% and Not a Byte Further](/blog/toxicframe-netgate-sg-2100/)

## Affected Hardware

- **Model:** Netgate SG-2100
- **CPU:** Dual-core ARM Cortex-A53
- **NIC:** Marvell 88E6141 (mvneta driver)
- **Affected Interface:** mvneta1
- **Switch:** Marvell 6000 Switch
- **pfSense Version:** 25.07.x

## Symptom

File transfers abort deterministically with the extracted toxic byte pattern. The transfer stops without error messages, logs, or network protocol errors (no FIN/RST packets). The behavior is reproducible across multiple protocols (SMB, HTTP) and network topologies (IPsec tunnels, VLAN-to-VLAN on internal switch, direct Ethernet).

## Reproduction Steps

1. Set up Netgate SG-2100 with LAN port connected to integrated Marvell 6000 Switch
2. Download `toxic.bin` from http://toxicframe.stylite-live.net/toxic.bin
3. Transfer `toxic.bin` over HTTP or SMB through the SG-2100
4. Transfer aborts at exactly 49% (ca. 95 MB)

**Control test:** Transfer `nontoxic.bin` (http://toxicframe.stylite-live.net/nontoxic.bin) – transfers successfully without issues.

## Technical Details

### Byte Pattern

The problematic byte pattern is extraced from `stdww2.cab` (a windows update file)

**SHA256 hash of toxic.bin:**
```
c53442b8ebc2631d4326fb70cdcc62a5c452674ed306d31120235fc180cfd499
```

### Packet Capture Analysis

PCAP dumps show:
- Transfer stops abruptly without FIN/RST packets
- Last ACK packet is never answered
- Frame contains the toxic byte pattern in the payload
- No corresponding log events on the firewall

**PCAP files:**
- [packetcapture-mvneta0.pcap](packetcapture-mvneta0.pcap)
- [packetcapture-mvneta1.pcap](packetcapture-mvneta1.pcap)

### Isolation Results

**Problem occurs:**
- With and without VLAN configuration
- Over IPsec tunnels
- Over VLAN-to-VLAN on internal switch
- Over direct Ethernet connections
- With different clients
- Over different protocols (SMB, HTTP, FTP)
- At different times and loads
- Across different pfSense versions (25.07.x)

**Problem does NOT occur:**
- On other firewall manufacturers
- With other files of similar size/structure
- With `nontoxic.bin` (random bytes)

**Conclusion:** The issue is hardware-related and occurs specifically in the Marvell 6000 Switch when the LAN port of the SG-2100 is involved in the data path.

## Root Cause Analysis

The bug indicates a hardware-level packet drop in the Marvell 6000 Switch when processing a specific byte pattern. The deterministic behavior (always at 49%, always the same byte pattern) suggests a hardware defect or firmware bug in the switch's packet processing logic.

The issue is independent of:
- VLAN configuration
- Routing rules
- Firewall rules
- Protocol (SMB, HTTP, FTP)
- Network topology

## Impact

- Critical file transfers may fail silently
- No error messages or logs indicate the problem
- Difficult to diagnose (requires binary analysis)
- Affects any file containing the toxic byte pattern at the problematic offset

## Workaround

Route critical transfers over alternative hardware or network paths that do not involve the SG-2100's LAN port and integrated Marvell 6000 Switch.

## Requested Action

1. Investigate the Marvell 6000 Switch packet processing logic for this specific byte pattern
2. Review driver handling (mvneta) for the affected interface
3. Provide firmware fix or hardware replacement procedure
4. Confirm if other SG-2100 units are affected

## Related Issues

A similar issue was reported in the pfSense community four years ago without resolution:
- Reddit: https://www.reddit.com/r/PFSENSE/comments/twswig/weirdest_issue_ever_experts_needed_smb_hangs_over/

## Test Files

- **Toxic pattern:** http://toxicframe.stylite-live.net/toxic.bin
- **Control (non-toxic):** http://toxicframe.stylite-live.net/nontoxic.bin
- **PCAP files:**
  - [packetcapture-mvneta0.pcap](packetcapture-mvneta0.pcap)
  - [packetcapture-mvneta1.pcap](packetcapture-mvneta1.pcap)
- **Video reproductions:**
  - [toxicframe_overhttp.mp4](/blog/toxicframe-netgate-sg-2100/toxicframe_overhttp.mp4)

## Contact

Stylite AG  
CTO: Wim Bonis  
Email: office@stylite.de

---

**Note:** This bug report is based on extensive testing over several days, including binary analysis, packet captures, and systematic isolation of variables. The issue is 100% reproducible with the provided test files.

