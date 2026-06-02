# System V AMD64 Calling Convention

On x86_64 Linux, the first six integer/pointer arguments are passed in
registers, in order:

| arg # | register |
|:-----:|:---------|
| 1 | rdi |
| 2 | rsi |
| 3 | rdx |
| 4 | rcx |
| 5 | r8  |
| 6 | r9  |

Additional arguments are passed on the stack (right-to-left). Return value
goes in `rax`.

## Register save responsibility

- **Caller-saved**: `rax, rcx, rdx, rsi, rdi, r8–r11`. The caller assumes
  these may be clobbered across a call.
- **Callee-saved**: `rbx, rbp, r12–r15`. If the function uses them, it must
  save/restore them (usually `push`/`pop`).

## Stack discipline

- Stack must be 16-byte aligned **at the call site** (i.e. just before the
  `call` instruction; the `call` itself pushes 8 bytes of return address, so
  on function entry `rsp` is 16-byte aligned − 8).
- The 128-byte red zone below `rsp` is available to leaf functions only.
  This project builds with `-mno-red-zone`; do not rely on it.

## errno from assembly

Syscall wrappers call `__errno_location` (extern) to get the address of
thread-local `errno`, then store `-rax` there when the syscall returned in
`[-4096, 0)`. See `src/io/ft_write.s` and `src/io/ft_read.s`.

## References

- <https://wiki.osdev.org/System_V_ABI>
- <https://reverseengineering.stackexchange.com/a/33664/34392>
