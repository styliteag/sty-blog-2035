---
title: "IP is Dead: The Rise of Content-Addressed Networking and its Impact on ZFS"
date: 2031-10-08T09:45:00+02:00
draft: false
description: "We are in the midst of the biggest shift in network architecture since the 1970s. Location-based addressing (IP) is being replaced by content-based addressing (CAN). For those of us in the ZFS world, this isn't just a change, it's a validation of everything we've been building."
tags: ["Networking", "CAN", "IPFS", "ZFS", "Decentralization", "CDN"]
authors: ["Andre Keller"]
---

For half a century, the internet has been built on a simple, powerful idea: every device has a unique address, an IP address. We send data *to* a location. This paradigm has served us well, but its time is over. The internet is undergoing a profound re-architecting, moving from a location-addressed model to a **Content-Addressed Network (CAN)** model. And ZFS is at the very heart of this revolution.

To put it bluntly: the concept of an IP address is becoming a legacy protocol.

### The "Aha" Moment: Stop Asking *Where*, Start Asking *What*

The core idea behind Content-Addressed Networking, which grew out of early projects like IPFS, is to change the fundamental question the network asks.

*   **The Old Way (IP):** "How do I get to server `198.51.100.10` to retrieve `logo.png`?" The network's job is to find the geographic or logical location of that server. The data is secondary.
*   **The New Way (CAN):** "I need the data object with the cryptographic hash `zb2rh...`. Where can I get it?" The network's job is to find the nearest peer that has this unique, verifiable piece of data. The location is irrelevant.

This is a tectonic shift. It decouples data from its location. The "aha" moment for us was realizing that this is exactly what ZFS has been doing internally for decades. ZFS doesn't care which physical disk a block lives on; it cares about the block's checksum, its hash. It ensures you get the right content. With CAN, the entire internet is starting to think like a distributed ZFS pool.

Our "Fluid Computing" model, which we introduced back in 2026, was a precursor to this. It used a ZFS-native protocol to achieve content-addressing within our own infrastructure. Now, the public internet is catching up. The latest network stacks in major operating systems and the firmware on new network hardware are CAN-native.

### ZFS: The Perfect Filesystem for a CAN World

The synergy between ZFS and CAN is almost poetic. When a user on a CAN-based internet requests a file stored on our TrueNAS arrays, the following happens:

1.  The user's browser doesn't ask for `https://stylite.ag/file.zip`. It asks for `can://<hash_of_file.zip>`.
2.  The global CAN routing system, a decentralized network of nodes, locates the nearest peers holding that data. One of those peers is our TrueNAS system.
3.  Our TrueNAS doesn't serve a file from a path. It receives the request for the hash. ZFS, by its very nature, already knows the location of this data block via its checksum. It serves the block directly.

The elegance is stunning. There are no DNS lookups. There are no complex file path traversals. The request from the global network speaks the native language of the filesystem. This results in lower latency, higher security (since the hash guarantees authenticity), and incredible efficiency.

### The Surprising Casualty: The CDN Industry

For 25 years, Content Delivery Networks (CDNs) were a cornerstone of the internet. They were a multi-billion dollar industry built to solve a problem inherent in the IP-based internet: geographic latency. They did this by building a massive, expensive global network of caches.

Content-Addressed Networking just made them obsolete overnight.

With CAN, *the entire internet is the CDN*. When a user in Japan requests one of our files, the request is automatically routed to the nearest peer that has it. This could be our primary server, but it could also be another user in Japan who downloaded it an hour ago and is now acting as a peer. The network itself becomes the cache. It's a distributed, self-organizing CDN that is more resilient and efficient than any centralized service could ever be.

We recently decommissioned our last CDN contract. The performance for our global clients *improved*, and our costs dropped to zero. The surprise isn't that this happened, but how quickly it did. The internet doesn't evolve; it leaps. And it just leaped past an entire industry, landing squarely in a world that ZFS was uniquely built to inhabit.
