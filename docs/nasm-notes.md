# NASM Notes (Intel syntax, x86_64)

## Compilation

```bash
nasm -f elf64 -g -F dwarf -Wall my_program.asm -o my_program.o
ld  -o my_program my_program.o            # bare metal link
gcc my_program.o -o my_program            # link against glibc
```

This project uses `nasm -f elf64 -g -F dwarf -w+all -w-reloc-rel-dword`.

## Per-file boilerplate

Use this skeleton when adding or normalizing a `.s` file:

```nasm
bits 64
default rel                  ; RIP-relative addressing by default

SECTION .rodata
SECTION .bss

global  ft_func:function (ft_func.end - ft_func)

SECTION .text exec nowrite align=16

ft_func:
    ; ...
    ret
.end:
    nop                      ; outside STT_FUNC, inside the DWARF CU
```

The `(.end - name)` size expression is what makes `readelf -sW` report a
real size for each function — keep the `.end:` label. The trailing `nop` is
not part of that size because `.end` precedes it.

## NASM DWARF function boundaries

NASM's ELF `function` qualifier and its DWARF output describe different
things. This declaration:

```nasm
global ft_func:function (ft_func.end - ft_func)
```

creates a named `STT_FUNC` entry in the ELF symbol table. NASM does not emit
a corresponding named `DW_TAG_subprogram`. Its DWARF instead contains a
minimal anonymous subprogram anchored at the first executable address in the
source file:

```text
DW_TAG_compile_unit
    DW_AT_low_pc
    DW_AT_high_pc

    DW_TAG_subprogram
        DW_AT_low_pc
        DW_AT_frame_base
```

The line table is independent of that anonymous subprogram. Consequently,
commands that start with an ELF symbol address still work:

```gdb
break ft_func
disassemble ft_func
info line ft_func
```

`info functions`, however, primarily enumerates named DWARF subprograms.
NASM's anonymous subprogram cannot be displayed as `ft_func`, and GDB may
suppress the `STT_FUNC` minimal symbol because its address is already covered
by the compilation unit. This is why a NASM function can have valid symbols
and source lines without appearing in `info functions`.

### Why `.end` labels appear in `info functions`

Without a trailing byte, the ELF and DWARF boundaries are:

```text
STT_FUNC range: [ft_func, ft_func.end)
DWARF CU range: [ft_func, ft_func.end)
ft_func.end:     exactly at DW_AT_high_pc
```

DWARF address ranges are half-open, so `ft_func.end` is not covered by that
CU. NASM emits `.end` as a local ELF symbol, and GDB may therefore expose it
under `Non-debugging symbols`:

```text
0x...  ft_func[end]
```

The result depends on the next input section. If the next function starts at
the same address, its stronger global `STT_FUNC` symbol shadows the local
`.end` symbol. If linker alignment leaves a gap, `.end` has a unique address
and is displayed.

Place one byte after `.end` to make the result deterministic:

```nasm
global ft_func:function (ft_func.end - ft_func)

SECTION .text exec nowrite align=16

ft_func:
    ; ...
    ret
.end:
    nop
```

This produces:

```text
STT_FUNC range: [ft_func, ft_func.end)
DWARF CU range: [ft_func, ft_func.end + 1)
```

The function size and ABI are unchanged, but `.end` now lies inside the
compilation unit. GDB suppresses it instead of listing it as a separate
non-debugging symbol.

This trailing-byte workaround only cleans up the `.end` entries. It does not
make the real assembly functions appear in `info functions`, because that
requires named `DW_TAG_subprogram` entries that NASM does not generate.
Apply it consistently to each assembly object whose `.end` label should stay
out of GDB's function listing.

`src/bonus/ft_list_size_bonus.s` demonstrates how to add that missing
information manually. It emits a second, small DWARF 4 compilation unit with:

- a named `ft_list_size` subprogram and relocatable low/high addresses;
- `unsigned int` and incomplete `t_list *` type descriptions;
- a formal `begin_list` parameter without a location, because the function
  overwrites `rdi` while traversing the list;
- a `DW_AT_stmt_list` reference to NASM's existing line program.

The source creates an empty `.debug_line` contribution immediately before
NASM's generated contribution. GNU ld preserves that order, allowing both
compilation units to refer to the same detailed line table. This is a
GNU-ELF-specific technique and should be rechecked before changing linkers or
enabling input-section sorting.

Use the ELF and line-table views when inspecting NASM functions:

```gdb
info address ft_func
info line ft_func
disassemble ft_func
```

```bash
readelf -sW libasm.a
nm -n -S libasm_test
```

## Useful inspection commands

```bash
readelf -sW libasm.a            # symbol table per object
objdump -d -M intel libasm.a    # disassembly, Intel syntax
nasm -f elf64 -l listing.lst src/string/ft_strlen.s   # listing file
```
