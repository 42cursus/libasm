# NASM Notes (Intel syntax, x86_64)

## Compilation

```bash
nasm -f elf64 -g -F dwarf -Wall my_program.asm -o my_program.o
ld  -o my_program my_program.o            # bare metal link
gcc my_program.o -o my_program            # link against glibc
```

This project uses `nasm -f elf64 -g -F dwarf -w+all -w-reloc-rel-dword`.

## Per-file boilerplate

Every `.s` file in `src/` follows the same skeleton:

```nasm
bits 64
default rel                  ; RIP-relative addressing by default

SECTION .rodata
SECTION .bss

section .text.pad exec nowrite align=1
    nop                      ; 1-byte pad to keep symbols distinct

global  ft_func:function (ft_func.end - ft_func)

SECTION .text

ft_func:
    ; ...
    ret
.end:
```

The `(.end - name)` size expression is what makes `readelf -sW` report a
real size for each function — keep the `.end:` label.

## Useful inspection commands

```bash
readelf -sW libasm.a            # symbol table per object
objdump -d -M intel libasm.a    # disassembly, Intel syntax
nasm -f elf64 -l listing.lst src/string/ft_strlen.s   # listing file
```
