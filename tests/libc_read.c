/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   libc_read.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: abelov <abelov@student.42london.com>       +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/04/07 23:47:14 by abelov            #+#    #+#             */
/*   Updated: 2026/04/07 23:47:14 by abelov           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <sys/types.h>
#include <asm/unistd.h>
#include <errno.h>
#include <bits/syscall.h>

/**
 * https://android.googlesource.com/platform/bionic/+/ics-mr0/libc/bionic/__set_errno.c
 * @param n
 * @return
 */
__inline __attribute__((__always_inline__))
int	__set_errno(int n)
{
	errno = n;
	return (-1);
}

/**
 * https://fschoenberger.dev/syscalls-by-hand/
 *
 * extra local variables to address __fastcall vs __cdecl vs __stdcall
 * @param fd
 * @param buf
 * @param nbytes
 * @return
 */
ssize_t __libc_read (int fd, void *buf, size_t nbytes)
{
	unsigned long int resultvar;

	size_t __arg3 = nbytes;
	void* __arg2 = buf;
	int __arg1 = fd;

	register size_t _a3 asm ("rdx") = __arg3;
	register void* _a2 asm ("rsi") = __arg2;
	register int _a1 asm ("rdi") = __arg1;

	asm volatile (
			"syscall\n\t"
			: "=a" (resultvar)
			: "0" (SYS_read), "r" (_a1), "r" (_a2), "r" (_a3)
			: "memory", "cc", "r11", "cx"
			);

	if ((unsigned long int)(resultvar) >= (unsigned long int)-4095L) {
		__set_errno(-(resultvar));
		resultvar = (unsigned long int) - 1;
	}

	return resultvar;
}
