/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: abelov <abelov@student.42london.com>       +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/04/07 15:21:47 by abelov            #+#    #+#             */
/*   Updated: 2026/05/25 20:53:50 by abelov           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */


#define _GNU_SOURCE         /* See feature_test_macros(7) */
#undef _FORTIFY_SOURCE
#define _FORTIFY_SOURCE 0

#include <stdlib.h>
#include <unistd.h>
#include "libasm.h"
#include <errno.h>
#include <string.h>


#define STR1(x) #x
#define STR(x) STR1(x)
#define ASM_DBG_LABEL(name) \
    asm volatile( \
        ".loc 1 " STR(__LINE__) " 0\n\t" \
        ".globl " #name "\n"	\
        /*                    	\
    	".hidden " #name "\n"	\
         ".globl " #name "\n"	\
    	*/                     	\
        #name ":\n\t" \
        : : : "memory")
#define ASM_L(name) ASM_DBG_LABEL(name)

/* Force x to be materialized in a register here. Not a memory barrier. */
#define MATERIALIZE_IN_REG(x) __asm__ volatile ("" : "+r"(x))

__attribute__((noinline,optimize("-O0")))
void escape(void *p) {
	asm volatile("" : : "g"(p) : "memory");
}

void *ft_memcpy(void *dest, const void *src, size_t n);

inline __attribute__((__always_inline__))
char	*ft_strcpy2(char *dest, const char *src) {
	size_t len;

	len = ft_strlen(src) + 1;  /* include null terminator */
	ft_memcpy(dest, src, len);

	return dest;
}

__attribute__((noinline,target("avx2"),optimize("O2", "no-omit-frame-pointer", "no-stack-protector")))
char	*ft_strdup(const char *const src)
{
	char	*new;

	new = (char *)malloc(sizeof(char) * ft_strlen(src) + 1);
	if (!new)
	{
		errno = ENOMEM;
		return (NULL);
	}
	*new = '\0';
	return (ft_strcpy(new, src));
}

char *ft_strncpy(char *dest, const char *src, size_t n)
{
	escape(&dest);
	escape(&src);
	escape(&n);
	return __builtin_strncpy(dest, src, n);
}

/**
 * Disable AVX-optimized functions in glibc (LD_HWCAP_MASK, /etc/ld.so.nohwcap)
 *
 * GLIBC_TUNABLES=glibc.cpu.hwcaps=-AVX2_Usable
 * https://codebrowser.dev/gcc/gcc/builtins.cc.html
 * https://codebrowser.dev/glibc/glibc/sysdeps/x86_64/multiarch/ifunc-impl-list.c.html
 * https://sourceware.org/git/?p=glibc.git;a=blob;f=sysdeps/x86_64/multiarch/ifunc-impl-list.c
 * https://stackoverflow.com/questions/42451492/
 * @param argc
 * @param argv
 * @return
 */
int main(int argc, char *argv[]) {

	char		buf[1024] = "Program name is: ";
	char		*dest = (buf + ft_strlen(buf));
	const char	*src = argv[0];
	int			ret = EXIT_SUCCESS;

	ft_strncpy(dest, src, strlen(src));
	ft_strcpy2(dest, src);

	if (ft_write(STDOUT_FILENO, buf, ft_strlen(buf)) < 0)
		ret = EXIT_FAILURE;
	return ret;
	(void)argv;
	(void)argc;
}
