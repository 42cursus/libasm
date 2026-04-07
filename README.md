# ft_libasm

An implementation of some of the standard C library functions in x86_64 Assembly (NASM), as part of the 42network curriculum.

---

## Table of Contents

- [Overview](#overview)
- [Compilation](#compilation)
- [Registers](#registers)
- [Calling Convention](#calling-convention)
  - [X86_64 SysV ABI](#X86_64-SysV-ABI)

---

## Overview

ft_libasm is an introduction to low-level programming through the reimplementation of several libc functions directly in Assembly. The project covers the full compilation pipeline, memory management, register usage, and the SysV x86_64 calling convention.

## Compilation

```bash
# Linux 64-bit
nasm -f elf64 my_program.asm -o my_program.o
# or
nasm -f elf64 -g -F dwarf -Wall my_program.asm -o my_program.o
# then link with 
ld -o my_program my_program.o
# or 
gcc my_program.o -o my_program  # link with glibc
```

## x86 Architecture

### Registers

Registers are the processor's fastest memory, used for syscalls, arithmetic, and general control flow.

### How programs get run: ELF binaries
* https://lwn.net/Articles/631631/
* [main_function](https://en.cppreference.com/w/c/language/main_function)
* [startup](https://www.gnu.org/software/hurd/glibc/startup.html)
* [__libc_start_main](https://refspecs.linuxbase.org/LSB_3.1.1/LSB-Core-generic/LSB-Core-generic/baselib---libc-start-main-.html)

### Understanding Frame Pointers:

* https://hackmd.io/@paolieri/x86_64
* https://wiki.osdev.org/System_V_ABI#x86-64
* https://people.cs.rutgers.edu/~pxk/419/notes/frames.html
* https://eli.thegreenplace.net/2011/09/06/stack-frame-layout-on-x86-64/
* https://insecure.org/stf/smashstack.html

## Calling Convention

On x86_64 Linux (System V AMD64 ABI), arguments are passed through registers

### X86_64 SysV ABI

The first six integer and pointer arguments are passed like this:
* arg1: rdi
* arg2: rsi
* arg3: rdx
* arg4: rcx
* arg5: r8
* arg6: r9

>All content in this document applies exclusively to **x86_64 NASM on Linux**.

### Links
- [System_V_ABI](https://wiki.osdev.org/System_V_ABI)
- https://reverseengineering.stackexchange.com/a/33664/34392