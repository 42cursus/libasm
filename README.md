# ft_libasm

42 Libasm reimplements selected libc functions in hand-rolled x86-64 NASM
assembly for Linux (System V AMD64 ABI).

## Build

Requirements: `nasm`, `gcc`, and `libbsd-dev` for the C test driver.

```bash
make                # mandatory libasm.a and libasm_test
make bonus          # rebuild libasm.a with bonus symbols
make re             # clean rebuild
make fclean         # remove generated files
```

`make` is the canonical 42 build. CMake is available for IDEs:

```bash
cmake -S . -B build && cmake --build build
```

## Validate

```bash
make test           # mandatory functions and read/write error paths
make test_bonus     # ft_atoi_base and linked-list bonuses
valgrind --leak-check=full --error-exitcode=1 ./libasm_test
valgrind --leak-check=full --error-exitcode=1 ./libasm_bonus_test
```

`make test_bonus` leaves `libasm.a` with bonus symbols. Return to the
mandatory archive with:

```bash
make fclean && make
```

## Manual checks

Build the interactive driver, which exercises all mandatory functions:

```bash
make manual
./libasm_manual
printf 'hello from stdin\n' | ./libasm_manual
```

Inspect the archive and function symbols:

```bash
ar t libasm.a
readelf -sW libasm.a | grep ' ft_'
```

Trace the test driver's real `read(2)` and `write(2)` calls, or debug an
assembly function:

```bash
strace -e trace=read,write ./libasm_test
gdb ./libasm_test
# (gdb) break ft_strlen
# (gdb) run
```

## API

Headers: [`include/libasm.h`](include/libasm.h) and
[`include/libasm_bonus.h`](include/libasm_bonus.h). Link client code with
`-Iinclude -L. -lasm`.

## Notes

- Source: NASM Intel syntax, 64-bit only.
- `ft_read` and `ft_write` return `-1` and set `errno` on syscall failure.
- Bonus sources are `_bonus.s` files under `src/bonus/`.
- [`docs/`](docs/) contains ABI, x86-64, NASM, and reference notes.
