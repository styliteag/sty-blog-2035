---
title: "RISC-X and Open Hardware: Building Your Own Petabyte TrueNAS Server from a Blueprint"
date: 2030-03-25T10:30:00+01:00
draft: false
description: "Vendor lock-in is officially dead. The maturation of the RISC-X architecture and the Open Hardware movement means we no longer buy servers, we fabricate them. We just built our first petabyte TrueNAS array from a public blueprint. Here's how."
tags: ["Open Hardware", "RISC-X", "TrueNAS", "ZFS", "Right to Repair", "Customization"]
authors: ["Wim Bonis"]
---

For decades, we've treated server hardware as a given, a black box delivered by a handful of giant vendors. We'd argue about the specs, the price, the support contract, but the fundamental design was out of our hands. That era is over. Today, Stylite AG's new petabyte TrueNAS array wasn't delivered on a truck; it was assembled in our own lab, from components fabricated to our exact specifications, all based on open-source blueprints.

This is the promise of the Open Hardware movement, finally realized. Powered by the now-mature RISC-X instruction set architecture (the successor to RISC-V), we have entered a new age of IT where "vendor" is a dirty word.

### The "Aha" Moment: Servers as Whitepapers, Not Products

The shift began subtly. The RISC-V standard proved that an open ISA could compete with proprietary designs. But RISC-X took it a step further. It wasn't just an instruction set; it was a complete, modular blueprint for a System-on-a-Chip (SoC), from the CPU cores to the memory controllers and PCIe lanes. This blueprint, maintained by a non-profit foundation, is free for anyone to use and modify.

The "aha" moment for the industry was when we stopped seeing servers as physical products and started seeing them as reference implementations of a whitepaper. A company like iXsystems, the champions of TrueNAS, no longer primarily sells you a box. Instead, they are now a key contributor to the "ZFS Storage Accelerator" module for the RISC-X blueprint. Their business is providing the certified, optimized design.

Our process for building our new array looked like this:

1.  **Download the Blueprint:** We downloaded the latest stable RISC-X server blueprint, including the iXsystems-certified ZFS module.
2.  **Customize:** We needed more 100GbE network ports than the reference design offered. We hired a certified RISC-X consultant who modified the network controller portion of the blueprint for a small fee. We also added a custom hardware module for the AI ethics co-processor we developed last year.
3.  **Fabricate:** We sent the finalized blueprints to a local silicon fabrication plant ('fab'). Several of these have popped up in Europe, offering competitive pricing for short-run manufacturing. Three weeks later, our custom SoCs arrived.
4.  **Assemble:** The rest of the components—chassis, backplane, power supplies—are also based on open standards. Assembling the server was like building a PC from parts, but on a datacenter scale.
5.  **Deploy:** We installed the latest version of TrueNAS SCALE, which now has a specific build target for the RISC-X architecture. The system booted up, recognized our custom hardware, and imported our ZFS pools without a hitch.

### The Surprising New Metric: The Repairability Index

For years, the only question was "how fast is it?" Now, the questions are different. How easy is it to repair? How modular is the design? Can I replace a single component, or do I need to scrap the whole motherboard?

This has led to a surprising new benchmark: the **Repairability Index (RI)**. It's a score from 1 to 10 indicating how easily a device can be repaired and modified. Our custom-built TrueNAS server has an RI of 9.8. We can replace every single component, from the CPU cores (which are now socketed) to the individual capacitors on the motherboard, using commodity parts and standard tools.

This is a radical departure from the "glue-and-seal" philosophy that dominated the 2020s. We are no longer at the mercy of a vendor's supply chain or their decision to end-of-life a product. We have full control over the lifecycle of our hardware.

This isn't just about cost savings. It's about resilience. When a component fails, we don't open a support ticket and wait for a replacement. We print a new one. Or we buy it from one of a dozen competing suppliers. The power has shifted from the seller to the owner.

The datacenter of 2030 is a place of tinkering, of customization, of empowerment. The hum of the servers is now the hum of our own creation. We've thrown off the shackles of vendor lock-in, and the freedom is exhilarating.
