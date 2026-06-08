---
paginate: true
footer: Vivien MILLE / CppFrUG / 09/06/2026 / All rights to their respective owners
---

# Distribute Visual Studio in your company
### From nightmare to ok(ish)

<br/>
<br/>
<br/>

<p style="text-align: center; position: relative; bottom: -10%"><span style="font-size: 60%">Vivien MILLE / CppFrUG / 09/06/2026</span></p>

<!-- _footer: "" -->

---
## Who ?

* staff engineer at BNP Paribas CIB
* interested in performance for tools & organisations
* C++ related stuff in the company

---
# ABI vs enterprise

---
## ABI vs enterprise

Personal projects don't really care (most of the time) about ABI/compiler version compatibility...
</br>
What about enterprise with dozens (possible more) developers & CI nodes ?

---
## ABI vs enterprise

It resumes to: 
* how do you distribute your compilers (and other tools) ?
* how do you enforce versions ?

---
# Linux vs Windows

---
## Linux

__not the subject of this talk__
(tips: use Nix or Guix)

![bg left h:300](https://upload.wikimedia.org/wikipedia/commons/8/81/Guix_logo.svg)

![bg right h:300](https://raw.githubusercontent.com/NixOS/nixos-artwork/refs/heads/master/logo/nix-snowflake-white.svg)

---
## Windows

---
## Windows

<p style="text-align: center; position: relative; top: 20%"><span style="font-size: 300%">Visual Studio !</span></p>

---
## Wording

Channel: URL/link/version of Visual Studio


---
## Wording

Channel

Lifecycle:
- 2022: Current (quarterly update) and LTSC (18 months, except last 17.14)
- 2026: Current (monthly update) then LTSC (1 year) + decouple VS & BT

---
## Wording

Channel

Lifecycle

Component: installable features (C++ compiler, .NET, ...)


---
## Wording

Channel

Lifecycle

Component

Layout: pack of components (installed or not)

---
# Visual Studio sources

---
## Visual Studio sources

Before VS2022 17.10 (May 2024):
- local layout
- download from MS server with SYSTEM account (like personal usage)

---
## Visual Studio sources

Starting VS2022 17.10 (May 2024):
- local layout
- download from MS server with SYSTEM account (like personal usage)
- download from mirror (internal to your company)

---
## Visual Studio sources

Starting VS2022 17.10 (May 2024):
- <span style="color: #7a7979">local layout</span>
- <span style="color: #7a7979">download from MS server with SYSTEM account (like personal usage)</span>
- **download from mirror (internal to your company)**

---
# Internal hosting

---
## Internal hosting

Simple: 
- IIS with https
- local copy of the components (create a layout same as local layout, 50-100GB)
- small changes in various json files
- multiple channels on same server (including VS installer)

---
## Internal hosting

<p style="text-align: center; position: relative; top: 0%"><span style="font-size: 200%">"""Relatively""" simple</span></p>

<style scoped>
img[alt~='center'] {
    display: block;
    margin-left: auto;
    margin-right: auto;
}
</style>

![center](assets/dr-evil-sarcasm.gif)


---
# Installation process

---
## Normal installation steps

* download the bootstrapper
* install the bootstrapper & VS installer
* install Visual Studio with specific components

---
## Normal installation steps

- download the bootstrapper
- install the bootstrapper & VS installer
- install Visual Studio with specific components

<p style="text-align: center; position: relative; top: 20%"><span style="font-size: 200%">Admin rights are needed</span></p>

---
##  Almost no admin installation steps

As admin:
* install the bootstrapper & VS installer
* add registries (for non admin & channels)

---
##  Almost no admin installation steps

As admin:
- install the bootstrapper & VS installer
- add registries (for non admin & channels)

As user:
* ...

---
## Installation: user point of view

* open VS Installer
* choose which version you want to install
* add components
* Install/Modify
* Wait......................
* Restart

---
## Installation: behind the scene

When Visual Studio Installer starts, it fetches latest metadata version from internet.

Then, Visual Studio Installer starts a background service as SYSTEM and passes instruction from the VS Installer frontend (as user) to it.

And if not up to date, the service as SYSTEM tries to download newer version from internet

---
## Installation: behind the scene

<span style="color: #7a7979">When Visual Studio Installer starts, it fetches latest metadata version from internet.</span>

<span style="color: #7a7979">Then, Visual Studio Installer starts a background service as SYSTEM and passes instruction from the VS Installer frontend (as user) to it.</span>

<span style="color: #7a7979">And if not up to date, the service <span style="color: red">**as SYSTEM**</span> tries to download newer version <span style="color: red">**from internet**</span></span>

---

![bg](assets/angry-on-fire.gif)

<!-- _footer: "" -->

---
## Installation: work in progress...

What I did (mainly reverse engineering):
- add noWeb & channelUri flags almost everywhere
- dummy metadata file (_latestInstaller.json in APPDATA)
- cachePath outside of AV scope
- dedicated channel for VS Installer

---
# It works pretty well !

---
# "Happy ending ?" 

---
## "Happy ending ?": NO

* documentation confusing/not up to date/wrong
* missing certificate in the installer
* SYSTEM may connect to internet even with noWeb
* channel URIs have different formats if you are pointing to MS (URI root) or internal (ChannelManifest.json)

---
## "Happy ending ?": NO

* VS Installer should ALWAYS be up to date
* installation of some DLLs blocked by security tools
* security tools corrupt state file of VS (late file handle release)
* ...

---
## "Happy ending ?": Good practices

* store .vsconfig (layout description) into your VCS
* always use specific version of the toolchain (no Latest)
* check the expected version of toolchain in your MSBuild or CMake files

---
## "Happy ending ?": MAYBE !

Visual Studio 2026 seems in a better shape: 
* IDE & build tools are split
* SYSTEM is not used to download, only to install
* new lifecycle
* better implementation for version jump/channel switch

---
# Conclusion

---
# Questions ?

---
## Annexe: Update layout

- by administrators across the whole company (notification in VS) that can be forced
- by users, proposing new channels and allowing to retarget existing installations
