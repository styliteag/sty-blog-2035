---
title: "Beyond Containers: The Era of 'Nano-VMs' and Unikernels"
date: 2033-04-12T15:00:00+02:00
draft: false
description: "For years, the choice was between heavyweight VMs and lightweight containers. That dichotomy is now obsolete. The latest versions of virtualization platforms like Proxmox have embraced unikernels, giving rise to 'Nano-VMs' that offer the security of VMs with better-than-container performance."
tags: ["Virtualization", "Unikernel", "Proxmox", "OpenStack", "Serverless", "On-Premise"]
authors: ["Andre Keller"]
---

The world of virtualization has always been defined by a trade-off: the strong, hardware-enforced security of virtual machines versus the lightweight, fast-booting efficiency of containers. We spent years debating the merits of each, trying to find the right balance. Today, that debate is over. The distinction itself has vanished.

Welcome to the era of the **Nano-VM**. Thanks to the mainstream adoption of unikernel technology in platforms like Proxmox and OpenStack, we now have workloads that boot in milliseconds, have a near-zero attack surface, and are fully isolated by the hypervisor.

### The "Aha" Moment: Compile Your App *into* the OS

A traditional VM runs a full-blown guest operating system (like Linux or Windows), which then runs your application. A container shares the kernel of the host OS but packages its own user-space libraries. The Nano-VM is a radical departure from both.

A unikernel is a specialized, single-address-space machine image constructed by using library operating systems. Here's the "aha" moment: you don't install your application *on* an OS; you compile your application *with* the specific OS libraries it needs to create a single, tiny, sealed executable. This executable *is* the entire virtual machine.

This results in some incredible properties:
*   **Minimal Size:** A typical Node.js application, packaged as a Nano-VM, can be under 10MB. There is no shell, no package manager, no utilities, no extra drivers—nothing that your specific application doesn't use.
*   **Minimal Attack Surface:** If there's no shell, there can be no shell injection attacks. If there's no other process, there can be no process-hijacking. The attack surface is reduced to the literal code of your application and the few OS libraries it's using.
*   **Incredible Speed:** We are seeing boot times of under 5 milliseconds. That's not a typo. The time it takes for the hypervisor to instantiate a Nano-VM and for it to be ready to accept network connections is faster than a container startup.

Platforms like Proxmox have been re-architected to handle these Nano-VMs at scale. The hypervisor can now manage tens of thousands of them on a single physical host, spinning them up and tearing them down in response to individual API requests.

### How it Changes Everything

The rise of the Nano-VM, managed by on-premise platforms like Proxmox, has led to a surprising reversal of a decade-long trend. For the first time, it is now significantly cheaper and more performant to run "serverless" workloads on your own hardware than in the public cloud.

The cloud providers' serverless offerings (like AWS Lambda) have always had a hidden cost: the "cold start" problem. If your function hasn't been used in a while, it takes time to provision the environment and start it up. With Nano-VMs, the cold start problem is effectively solved. A 5ms boot time is so fast that it's cheaper to instantiate a new Nano-VM for every single API call than to keep one warm and waiting.

This has led to a boom in "on-premise serverless" architectures. Our ZFS-based TrueNAS systems provide the fast, reliable storage backend, while our RISC-X compute cluster running Proxmox manages a fleet of Nano-VMs. When a request comes in, Proxmox instantly spins up a Nano-VM to handle it, the VM performs its task (reading or writing data to the ZFS pool), returns the result, and is then destroyed. The entire process takes a few dozen milliseconds.

### The Surprise: On-Premise is the New "Edge"

The surprise is not that this is possible, but that it's more efficient than the massive, purpose-built infrastructures of the cloud giants. The combination of open hardware (RISC-X), an open hypervisor (Proxmox), an open filesystem (ZFS), and open unikernel standards has created a stack that is more agile, secure, and cost-effective than the proprietary, black-box systems of the cloud.

We are seeing a new form of IT architecture emerge: a highly efficient, serverless core running on-premise, handling the bulk of the workload, complemented by the global reach of the Content-Addressed Network for distribution. The ultimate irony is that by bringing our computing back in-house, we've created a private cloud that is more "serverless" than the public cloud itself. On-premise is no longer the slow, legacy core; it's the new, hyper-efficient edge.
