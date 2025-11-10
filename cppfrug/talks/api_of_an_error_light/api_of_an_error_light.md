---
paginate: true
marp: true
---

<!-- _class: title -->
<!-- _footer: '' -->

# API of an error


<p style="font-size: x-large">Vivien MILLE</p>

<p style="font-size: x-large">28/10/2025</p>

---
## Disclaimer

* Some constructions are not supported in your language, version of language, library, ...
* No silver bullet
* Opinions are my own
* Sorry for the C++ snippets

---
# Remainders

---
## Remainders

APIs 
* are contracts between providers & consumers
* should be easy to use & understand, hard to misuse
* should be strictly scoped (cf Hyrum's law)

---
# Thoughts around error

---
## Common thinking

An error can be:
* unexpected behavior
* fault in logic
* situation expected a specific treatment
* ~~happy path~~

---
## Where do responsibilities fall ?

Who decide if a special treatment is needed (ie who signal what and who manage what) ?

* API provider ?
* API consumer ?
* on everyone ?
* on no one ?

---
## Points of view of an error

An error can be:

* internal (data corruption, logical wrongness)
* external (pre- / post-conditions, wrong usage)
* recoverable (by the provider, by the consumer)
* unrecoverable (graceful exit)
* ignorable
* ...

---
# 4 signals of error

---
## 4 signals

1) Error code
2) Structure of error
3) Exception
4) Control flow

---
## Axes of evaluation

* Readable (ie self-hosted meaning)
* Extensible (ie add more details/types/...)
* Not-ignorable (ie hard to misuse)
* Performant (ie fast to raise & manage)

---
# Signal 1: error code

---
## Signal 1: error code

<p style="text-align: center"><span style="font-size: 300%">Glory to C !</span></p>

---
## Signal 1: error code


```cpp
int foo(auto* buffer, int* byte_read);
```

```cpp
int foo(auto* buffer, int* error_code);
```

<br/>

➖ external definition
➕ fast

---
# Signal 2: structure of error

---
## Signal 2: structure of error

```cpp
content_type foo(auto buffer, error_code* e)
```

```cpp
error_code foo(auto buffer, content_type* e)
```
<br/>

➖ almost mandatory to have in/out parameter
➕ self-hosted signification

---
# Signal 3: exception

---
## Signal 3: exception

<p style="text-align: center"><span style="font-size: 300%">Also called the nuclear option</span></p>

---
## Signal 3: exception

```cpp
void write(auto buffer);
```

```cpp
void write(auto buffer) throw;
```

```java
void write(auto buffer) throw OutOfMemory, ConversionException;
```

➖ goto in disguise
➕ catch or die

---
# Signal 4: control flow

---
## Signal 4: control flow

```cpp
result_type write(auto buffer);
```

```cpp
std::expected<file_handle_t, write_error_t> write(auto buffer);
```

---
## Signal 4: control flow

```cpp
result_t write(auto buffer);
// with
// type_of(result_t) = type_of(value_t) || type_of(error_t)
```

```cpp
auto res = write(b);
if (res.is_error()) {
    res.error(); // OK
    // retry, throws exception, default value, log, ...
}
res.value(); // OK
```

```cpp
auto res = write(b); // contains error
res.value(); // throws exception
```

---
## Signal 4: control flow

```cpp
result_type write(auto buffer);
```

```cpp
std::expected<file_handle_t, write_error_t> write(auto buffer);
```

➖ ?
➕ manage or die

---
# Comparisons

---
## Comparisons

| API                | Readable | Extensible | Not-ignorable | Performant | 
|--------------------|----------|------------|---------------|------------|
| Error code         | 🔴       | 🔴         | 🔴            | 🟢         |
| Structure of error | 🟢       | 🟠         | 🔴            | 🟠         |
| Exception          | 🔴       | 🟠         | 🟢            | 🟠         |
| Control flow       | 🟠       | 🟢         | 🟢            | 🟠         |

---
## Conclusion

As provider:
* Define what your error is & signal it without interpretation
* Be homogeneous

As consumer:
* Read the APIs & the documentations
* Follow the conventions of your APIs

Limitations:
* Technical (control flow may not be implemented)
* Good practices & conventions

---
# Questions