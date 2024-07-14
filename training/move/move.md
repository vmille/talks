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
# Memory and object

---
## Memory and object

- Memory is mapped to physical component (memory banks in DRAM or GDDR or CPU cache or ...)

- Object doesn't exist in the physical world, but use memory

!!! important
Objects are interpretation of binary stored in memory, thus exist only when interpreted. One binary blob could mean different objects

---
## Memory

You can visualise memory as a sandbox:
* Divide the surface into a grid
* Reserve some square to a specific child
* Child will build stuff with the sand

!!! important
Without child, there is only sandbox and sand, and no meaning

!!! flash forward
When the child leaves, the construction may stay

!!! info
A child can be a process, a context, a thread, a factory, an allocator, ...

---
## Objects

- ~exist outside of memory
- are interpretation of binary blob (ie have a type)
- have a lifetime => are created and destroyed, ie are born, do, then die

---
## Memory allocation

Who can request allocation ?
- developer
- library
- OS
- ...

How to request allocation ?
* malloc / HealAlloc -> libc / Win32
* mmap / CreateFileMapping -> syscall

!!! difference malloc & mmap
mmap request kernel to reserve memory and always have it 
malloc may implement algorithms to reuse and optimise usage of mmap (reuse bank of memory not returned to the kernel)

---
## Memory and object relation

* request memory
* construct object
* use object
* destroy object
* release memory

---
## malloc vs new

malloc signature:
```cpp
void* malloc(int size_);
```
--> return type is not typed ! so not an object

new signature:
```cpp
void* operator new(std::size_t size_);
```
--> return type is not typed ! so not an object...

[//]: # (TODO ajouter citation du standard + DR)
--> yes but no: C++ derogation (standard citation)

---
## malloc vs new

[//]: # (TODO valider avec godbolt)
My representation of new:
```cpp
template <typename type_t, typename... args_t>
T* operator new(args_t&&... args) {
    void* ptr = malloc(sizeof(std::remove_cvref_t<type_t>));
    if (ptr) {
        return new (ptr) type_t(std::forward<args_t>(args)...);
    }
    throw std::bad_alloc();
};
```
!!! placement new
A placement new (ie a new where you indicate at which address you allocate doesn't allocate) start the lifetime of an object and call the constructor

---
## Other important stuff

why sometimes when no initialisation an object is zeroed ?
--> kernel wipe memory to 0 before returning it to avoid leaking data for other processes

---
# Ownership

---
## Ownership

[//]: # (TODO find definition)

---
## Exclusive or shared ownership

If we reuse the sandbox example:
- One child per square: exclusive
- Multiple children per square: shared
 
!!! reminder
children === process / workers / ...


---
## what is the link between move and all of this ?

you move ownership, so we need to answer 
- what is an ownership of an object ?
- what is an object ?


[//]: # (TODO splitter le contenu en plusieurs:
- what is an object
- what is owership
- what is move)