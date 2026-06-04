---
paginate: true
---

# How to Visual Studio in enterprise ?

<!-- _footer: "" -->

---
# ABI vs enterprise

---
## ABI vs enterprise

Personal projects don't really care (most of the time) about ABI/compiler version compatibility/...
What about enterprise with dozens (possible more) developers & CI nodes ?

---
## ABI vs enterprise

It resumes to: 
* how do you distribute your compilers (and other tools) ?
* how do you enforce versions ?

---
## ABI vs enterprise

It resumes to:
- **how do you distribute your compilers (and other tools) ?**
- how do you enforce versions ?

---
## Wording

Channel: URL/link/version of Visual Studio

Lifecycle:
- 2022: Current (quarterly update) and LTSC (18 months, except last 17.14)
- 2026: Current (monthly update) then LTSC (1 year) + decouple VS & BT

Component: installable features (C++ compiler, .NET, ...)
Layout: pack of components (installed or not)

---
# Linux vs Linux

---
## Linux

__not the subject of this talk__
(tips: use Nix)

---
## Windows (and particularly Visual Studio)

Before VS2022 17.10 (May 2024):
- local layout (ie components/installers)
- Downloads from MS server with SYSTEM account (like personal usage)

---
## Windows (and particularly Visual Studio)

Starting VS2022 17.10 (May 2024):
- use local layout (ie components/installers)
- download from MS server with SYSTEM account (like personal usage)
- download from mirror (internal to your company)

---
## Internal hosting

Simple: 
- IIS with https
- local copies of the components (create layout same as local layout)
- small changes in the various json
- multiple channels on same server (including VS installer)

---
## Installation steps

* install the bootstrapper & VS installer
* add registries (non admin & channels)
* installation by user among the channels
* customisation of the components

---
## Installation by user

- open VS installer as user
- choose which version you want to install
- add component
- Install/Modify

---
## Installation by user (behind the scene)

- VS installer fetch latest metadata versions from internet
- VS installer start a SYSTEM executable
- SYSTEM tries to download from internet newer version from VS Installer

---
## Update

- by administrators across the whole company (notification in VS) that can be forced
- by users, proposing new channels and allowing to retarget existing installations

---
## Good practices

- store .vsconfig (layout description) into your VCS
- always use specific version of the toolchain (no Latest)
- specify the expected version of toolchain in your code

---
## Issues

- missing certificate in the installer
- SYSTEM may connect to internet even with noWeb flag (need to specify channelUri)
- Channel URIs have different formats if you are pointing to MS (URI root) or internal (ChannelManifest.json)
- VS installer should ALWAYS be up to date
- installation of some DLLs blocked by AV & Citrix
- AV corrupts state file of VS (late file handle release)
