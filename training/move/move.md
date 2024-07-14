---
paginate: true
marp: true
---

<!-- _class: title -->
<!-- _footer: '' -->

# What is move

---
## Summary

* Memory and object
* Ownership and resources
* Developer intention and performance
* Transfer

---
# Disclaimer

---
## Disclaimer

- not talk about allocators or strategy to allocate memory (CoW, virtual memory table, ...)
- not talk about silicium
- mainly focus on C++, but part maybe valid for other languages
- memory representation and alignment
- only little about kernel (no user & kernel space)

---
## what is the link between move and all of this ?

you move ownership, so we need to answer 
- what is an ownership of an object ?
- what is an object ?


[//]: # (TODO splitter le contenu en plusieurs:
- what is an object
- what is owership
- what is move)