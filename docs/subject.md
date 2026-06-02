# Subject — Libasm

Machine-readable extraction of the official subject. All wording below is
paraphrased from the source; the official PDF remains the canonical reference
in case of any divergence.

## Summary

The aim of the project is to become familiar with assembly language by
reimplementing a subset of standard C library functions in x86_64 NASM and
shipping them as the static library `libasm.a`.

## Common rules (apply to mandatory **and** bonus)

- Functions must not crash unexpectedly (segfault, bus error, double free,
  …) except on undefined behaviour. Crashing means the project scores 0.
- The `Makefile` must provide at least the targets: `$(NAME)`, `all`,
  `clean`, `fclean`, `re`. Incremental relink/recompile only.
- To submit bonuses, add a `bonus` rule to the `Makefile` that incorporates
  all extra headers / libraries / functions forbidden in the mandatory part.
  Bonus files must be named `*_bonus.{c,h}` (here: `*_bonus.s`). Mandatory
  and bonus are graded **independently**.
- Test programs are encouraged but not graded.
- Only the work present in the assigned Git repository is graded.
- 64-bit assembly only. Watch the calling convention.
- **No inline asm**; sources must be `.s` files.
- Assemble with **nasm**.
- **Intel syntax only** (not AT&T).
- The compilation flag `-no-pie` is **forbidden**.

## Mandatory part

- Library must be named `libasm.a`.
- Provide a `main` that tests every function and links against the library.
- Reimplement, in assembly:
  - `ft_strlen` — `man 3 strlen`
  - `ft_strcpy` — `man 3 strcpy`
  - `ft_strcmp` — `man 3 strcmp`
  - `ft_write` — `man 2 write`
  - `ft_read` — `man 2 read`
  - `ft_strdup` — `man 3 strdup` (may call `malloc`)
- Syscall errors must be checked and handled; `errno` must be set properly.
- Allowed externs for errno: `__error` / `__errno_location`.

## Bonus part

> Only graded if the mandatory part is **perfect** (fully done, no
> malfunction). Otherwise bonus is not evaluated at all.

Shared linked-list type:

```c
typedef struct s_list {
    void          *data;
    struct s_list *next;
} t_list;
```

### V.1  `ft_atoi_base`

```c
int ft_atoi_base(char *str, char *base);
```

- Converts the initial portion of `str` (in the given base) to an `int`.
- Behaves like `ft_atoi` apart from the base.
- Returns `0` on invalid arguments. Invalid bases include:
  - empty or 1-character base
  - duplicate characters
  - presence of `+`, `-`, or any whitespace character

### V.2  `ft_list_push_front`

```c
void ft_list_push_front(t_list **begin_list, void *data);
```

Adds a new `t_list` node at the head of the list, with `data` set to the
argument. Updates `*begin_list` when needed.

### V.3  `ft_list_size`

```c
int ft_list_size(t_list *begin_list);
```

Returns the number of elements in the list.

### V.4  `ft_list_sort`

```c
void ft_list_sort(t_list **begin_list, int (*cmp)());
```

Sorts the list in ascending order using `cmp(a->data, b->data)`. `cmp` may
be e.g. `ft_strcmp`.

### V.5  `ft_list_remove_if`

```c
void ft_list_remove_if(t_list **begin_list, void *data_ref,
                       int (*cmp)(), void (*free_fct)(void *));
```

Removes every node for which `cmp(node->data, data_ref) == 0`. The data of
each removed node must be freed with `free_fct` before the node itself is
freed.
