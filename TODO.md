# TODO

Grouped by milestone. Tick items as they land.

## Mandatory

- [x] `ft_strlen`
- [x] `ft_strcpy` — covered by `tests/suites/test_strcpy.c`.
- [ ] `ft_strcmp` — implementation in `src/string/ft_strcmp.s`, covered by `tests/suites/test_strcmp.c`. Audit against `man 3 strcmp` (unsigned byte compare, return sign only).
- [x] `ft_write` — syscall + errno wiring; covered by `tests/suites/test_write.c`.
- [x] `ft_read` — syscall + errno wiring; covered by `tests/suites/test_read.c`.
- [ ] `ft_strdup` — `src/string/ft_strdup.s` is currently empty; implement using `ft_strlen` + `malloc` + `ft_strcpy`, set `errno = ENOMEM` on alloc failure. Flip `FT_STRDUP_IMPLEMENTED` to `1` in `tests/suites/test_strdup.c` once done.
- [ ] Verify every mandatory function against `man` semantics, including edge cases (empty strings, `NULL` where allowed/forbidden, max-length inputs).
- [ ] Ensure `errno` is left **unchanged** on success for `ft_read`/`ft_write` (asserted in the suites).
- [ ] Norminette / 42 header check on every `.s` and `.c` file.

## Bonus

All files must live in `src/bonus/` and end in `_bonus.s` (subject §II). The
bonus archive must be produced by `make bonus` and contain mandatory + bonus
symbols.

- [ ] `ft_atoi_base` — Annex V.1. Reject empty / 1-char base, duplicates, any of `+`, `-`, whitespace; handle optional leading sign and skip leading whitespace like `atoi`.
- [ ] `ft_list_push_front` — Annex V.2.
- [ ] `ft_list_size` — Annex V.3.
- [ ] `ft_list_sort` — Annex V.4. Bubble sort against `cmp(data, data)` is fine; mutate in place.
- [ ] `ft_list_remove_if` — Annex V.5. Free each removed node's data with `free_fct`, then `free` the node itself.
- [ ] Bonus header `include/libasm_bonus.h` exposes `t_list` and prototypes (done).
- [ ] Test driver section (or separate `tests/main_bonus.c`) exercising each bonus function.

## Quality

- [x] Per-function test cases in `tests/suites/` (one `.c` per function) using the assert-based runner in `tests/test.h`.
- [x] `make test` target that runs `./libasm_test` and exits non-zero on failure.
- [ ] CI: GitHub Actions workflow running `make re && make test` on Ubuntu.
- [ ] Run `valgrind ./libasm_test` clean (no leaks, no invalid reads).
- [ ] Verify 16-byte stack alignment at every `call` site in our asm.
- [ ] Confirm `-no-pie` is **not** used anywhere (subject forbids it).
- [ ] Reconcile Makefile and CMakeLists.txt flag lists (single source of truth, e.g. a `mk/flags.mk` include).
- [ ] Strip `src/extra/ft_memcpy.s` from the default build path or rewrite it with the project's header style.

## Docs

- [x] Split deep x86_64/ABI references out of README into `docs/`.
- [x] README API reference table.
- [ ] Per-function design notes (one short `.md` per `.s` under `docs/funcs/`), including chosen algorithm and clobbered registers.
- [ ] Document the `tests/main.c` debugging macros (`ASM_DBG_LABEL`, `ASM_L`, `escape`, `MATERIALIZE_IN_REG`).
- [ ] Add a short "how to debug with gdb + `.gdbinit`" guide to `docs/`.
