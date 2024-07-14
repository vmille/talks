---
paginate: true
marp: true
---

<!-- _class: title -->
<!-- _footer: '' -->

# What is ownership

---
## Summary

* Definitions
* Ownership and resources
* Transfer
* Developer intention and performance

---
# Disclaimer



---
# Definitions

---
## Definitions: resource

A resource is an object where construction or destruction are important, ie we need to know how it is constructed or destructed as it is one important part of the object
RAII

---
## Definitions: RAII

Resource Acquisition Is Initialisation:
-> temporal deterministic behavior for destruction (ie we know exactly what operation happen when)

!!! bad example
A file or socket handle is "just" a pointer, ie a integer. So what if we directly initialise the handle to the number ?
--> not valid !

---
## Definitions: class invariants

Something that is always true wherever we are in the object lifetime
!!! example
in std::vector :
- size <= capacity
- address of begin < address of end

!!! tests
testing class invariant is call Property Based Testing (using random stuff and checks if always correct)

[//]: # (TODO valider les définitions)

---
## Definitions: value

A value is not a resource, ie we how we get this stuff is not important as it is always the same. A value is not born or destructed, a value is.

!!! examples
- 5
- "hello world"
- 3.141569....

[//]: # (TODO valider les définitions)

---
## Definitions : Ownership

Ownership
[//]: # (TODO find definition)
- parents of an object
- who can use an object
- When you have ownership, an object is always in a valid state

!!! other defs
- scope

---
# Types of ownership

---
## Types of ownership

If we reuse the sandbox example:
- One child per square: exclusive
- Multiple children per square: shared
 
!!! reminder
children === process / workers / ...

---
## Types of ownership


