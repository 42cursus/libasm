# ft_libasm

Reimplementation of selected libc functions in x86_64 assembly (NASM, Intel
syntax) — 42 curriculum.

> Subject: [`docs/subject.md`](docs/subject.md).

## Table of Contents

1. [Overview](#overview)
2. [Build](#build)
3. [Usage](#usage)
4. [API](#api)
5. [Project Layout](#project-layout)
6. [Conventions](#conventions)
7. [Further Reading](#further-reading)

## Overview

`libasm.a` is a static archive of hand-written x86_64 NASM implementations of:

- string helpers (`ft_strlen`, `ft_strcpy`, `ft_strcmp`, `ft_strdup`)
- syscall wrappers (`ft_read`, `ft_write`)

A bonus archive adds `ft_atoi_base` and a small singly-linked-list API
(`ft_list_*`).

Target platform: **Linux x86_64, System V AMD64 ABI, NASM ≥ 2.14**.

## Build

```bash
make            # libasm.a + libasm_test (mandatory only)
make bonus      # libasm.a now also contains the bonus symbols
make re         # fclean + all
make clean      # remove build/objs
make fclean     # also remove libasm.a, libasm_test
```

The repository also ships a `CMakeLists.txt` for IDE integration:

```bash
cmake -S . -B build && cmake --build build
```

The two build systems share the same source layout; the Makefile is the
canonical/graded build.

### Requirements

- `nasm` (assembler)
- `gcc` (links the test driver; the asm objects themselves are toolchain-agnostic)
- `libbsd-dev` (test driver only, for `strlcpy`-style helpers)

## Usage

```c
#include <libasm.h>

size_t n = ft_strlen("hello");
char  *copy = ft_strdup("hello");
ssize_t w = ft_write(1, "hi\n", 3);   /* sets errno on error */
```

Link with `-L. -lasm`. The bonus header is `<libasm_bonus.h>`.

## API

### Mandatory (`include/libasm.h`)

| Function     | Signature                                              | Notes |
|--------------|--------------------------------------------------------|-------|
| `ft_strlen`  | `size_t  ft_strlen(const char *src)`                   | `repne scasb`. |
| `ft_strcpy`  | `char   *ft_strcpy(char *dst, const char *src)`        | Returns `dst`. |
| `ft_strcmp`  | `int     ft_strcmp(const char *s1, const char *s2)`    | Unsigned byte compare. |
| `ft_strdup`  | `char   *ft_strdup(const char *src)`                   | Calls `malloc`; sets `errno = ENOMEM` on failure. |
| `ft_write`   | `ssize_t ft_write(int fd, const char *buf, size_t n)`  | Sets `errno`, returns `-1` on syscall failure. |
| `ft_read`    | `ssize_t ft_read(int fd, void *buf, size_t n)`         | Sets `errno`, returns `-1` on syscall failure. |

### Bonus (`include/libasm_bonus.h`)

| Function              | Signature |
|-----------------------|-----------|
| `ft_atoi_base`        | `int  ft_atoi_base(char *str, char *base)` |
| `ft_list_push_front`  | `void ft_list_push_front(t_list **lst, void *data)` |
| `ft_list_size`        | `int  ft_list_size(t_list *lst)` |
| `ft_list_sort`        | `void ft_list_sort(t_list **lst, int (*cmp)())` |
| `ft_list_remove_if`   | `void ft_list_remove_if(t_list **lst, void *ref, int (*cmp)(), void (*free_fct)(void *))` |

## Project Layout

```
.
├── include/
│   ├── libasm.h            # mandatory API
│   └── libasm_bonus.h      # bonus API + t_list struct
├── src/
│   ├── string/             # ft_strlen, ft_strcpy, ft_strcmp, ft_strdup
│   ├── io/                 # ft_read, ft_write (syscall wrappers)
│   ├── bonus/              # *_bonus.s — only linked by `make bonus`
│   └── extra/              # non-graded helpers (ft_memcpy); never in libasm.a
├── tests/                  # hand-written C driver (main.c + helpers)
├── docs/                   # x86_64, ABI and NASM notes
├── resources/              # subject PDF
├── Makefile                # canonical build
└── CMakeLists.txt          # IDE/CLion build
```

## Conventions

- **Assembly**: NASM, Intel syntax, `bits 64`, `default rel`. Each function
  exposes a `.end:` label and is declared with `global name:function (.end - name)`
  so symbol sizes are correct in `readelf`.
- **Calling convention**: SysV AMD64 — see [`docs/abi.md`](docs/abi.md).
- **Errno**: syscall wrappers use `extern __errno_location` and store `-rax`
  on syscall failure (`rax ∈ [-4096, 0)`).
- **Bonus files** end in `_bonus.s` per the 42 subject and live under
  `src/bonus/`. They are only included when invoking `make bonus`.
- **`src/extra/`** holds non-graded helpers (e.g. `ft_memcpy`) and is
  deliberately **excluded** from `libasm.a`.
- 42 header block at the top of every source file.
- Tabs for indentation in both `.s` and `.c`.

## Further Reading

In-repo references (moved out of this README to keep things short):

- [`docs/x86_64.md`](docs/x86_64.md) — register file, sub-register names, ELF startup.
- [`docs/abi.md`](docs/abi.md) — SysV AMD64 calling convention, stack alignment, errno.
- [`docs/nasm-notes.md`](docs/nasm-notes.md) — NASM syntax, per-file skeleton, inspection commands.
- [`docs/references.md`](docs/references.md) — curated external links.
- [`TODO.md`](TODO.md) — milestone-grouped task list.
