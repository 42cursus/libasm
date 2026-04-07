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

### Registers

Registers are the processor's fastest memory, used for syscalls, arithmetic, and general control flow.
* [CPU registers](https://datacadamia.com/computer/cpu/register/general)

x64 assembly code uses sixteen 64-bit registers.
Additionally, the lower bytes of some of these registers may be accessed independently as 32-, 16- or 8-bit registers.
The register names are as follows:

| 8-byte<br/>Register | 32-bit  | 16-bit  | 8-bit  |
|:--------------------|:--------|:--------|:-------|
| %rax                | %eax    | %ax     | %al    |
| %rcx                | %ecx    | %cx     | %cl    |
| %rdx                | %edx    | %dx     | %dl    |
| %rbx                | %ebx    | %bx     | %bl    |
| %rsi                | %esi    | %si     | %sil   |
| %rdi                | %edi    | %di     | %dil   |
| %rsp                | %esp    | %sp     | %spl   |
| %rbp                | %ebp    | %bp     | %bpl   |
| %r8                 | %r8d    | %r8w    | %r8b   |
| %r9                 | %r9d    | %r9w    | %r9b   |
| %r10                | %r10d   | %r10w   | %r10b  |
| %r11                | %r11d   | %r11w   | %r11b  |
| %r12                | %r12d   | %r12w   | %r12b  |
| %r13                | %r13d   | %r13w   | %r13b  |
| %r14                | %r14d   | %r14w   | %r14b  |
| %r15                | %r15d   | %r15w   | %r15b  |

<br/>
There are sixteen 64-bit registers in x86-64:<br/>
%rax, %rbx, %rcx, %rdx, %rdi, %rsi, %rbp, %rsp, and %r8-r15.<br/>
<br/>
Of these, %rax, %rcx, %rdx, %rdi, %rsi, %rsp, and %r8-r11 are considered caller-save registers,<br/>
meaning that they are not necessarily saved across function calls.<br/>
<br/>
By convention, %rax is used to store a function’s return value, if it exists and is no more than 64 bits long.<br/>
(Larger return types like structs are returned using the stack.)<br/>
Registers %rbx, %rbp, and %r12-r15 are callee-save registers, meaning that they are saved across function calls.<br/>
<br/>
Register %rsp is used as the stack pointer, a pointer to the topmost element in the stack.<br/>

| Name | Notes | Type | 64-bit (long) | 32-bit (int) | 16-bit (short) | 8-bit (char) |
|------|-------|------|---------------|--------------|----------------|--------------|
| rax | Values are returned from functions in this register. | scratch | rax | eax | ax | ah and al |
| rcx | Typical scratch register. Some instructions also use it as a counter. | scratch | rcx | ecx | cx | ch and cl |
| rdx | Scratch register. | scratch | rdx | edx | dx | dh and dl |
| *rbx* | *Preserved register: don't use it without saving it!* | *preserved* | *rbx* | *ebx* | *bx* | *bh and bl* |
| *rsp* | *The stack pointer. Points to the top of the stack (details coming soon!)* | *preserved* | *rsp* | *esp* | *sp* | *spl* |
| *rbp* | *Preserved register. Sometimes used to store the old value of the stack pointer, or the "base".* | *preserved* | *rbp* | *ebp* | *bp* | *bpl* |
| rsi | Scratch register. Also used to pass function argument #2 in 64-bit Linux | scratch | rsi | esi | si | sil |
| rdi | Scratch register. Function argument #1 in 64-bit Linux | scratch | rdi | edi | di | dil |
| r8  | Scratch register. These were added in 64-bit mode, so they have numbers, not names. | scratch | r8 | r8d | r8w | r8b |
| r9  | Scratch register. | scratch | r9 | r9d | r9w | r9b |
| r10 | Scratch register. | scratch | r10 | r10d | r10w | r10b |
| r11 | Scratch register. | scratch | r11 | r11d | r11w | r11b |
| *r12* | *Preserved register. You can use it, but you need to save and restore it.* | *preserved* | *r12* | *r12d* | *r12w* | *r12b* |
| *r13* | *Preserved register.* | *preserved* | *r13* | *r13d* | *r13w* | *r13b* |
| *r14* | *Preserved register.* | *preserved* | *r14* | *r14d* | *r14w* | *r14b* |
| *r15* | *Preserved register.* | *preserved* | *r15* | *r15d* | *r15w* | *r15b* |

- [Registers in x86 Assembly](https://www.cs.uaf.edu/2017/fall/cs301/lecture/09_11_registers.html)

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