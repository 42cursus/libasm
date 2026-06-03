/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_memcpy.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: abelov <abelov@student.42london.com>       +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/06/02 11:23:08 by abelov            #+#    #+#             */
/*   Updated: 2026/06/02 11:23:08 by abelov           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#define _GNU_SOURCE         /* See feature_test_macros(7) */
#undef _FORTIFY_SOURCE
#define _FORTIFY_SOURCE 0

#include <string.h>


#define DBG_STR1_(x) #x
#define DBG_STR_(x)  DBG_STR1_(x)

#define ASM_DBG_LABEL(name) \
	asm volatile( \
		".loc 1 " DBG_STR_(__LINE__) " 0\n\t" \
		".globl " #name "\n" \
		#name ":\n\t" \
		: : : "memory")

#define ASM_L(name) ASM_DBG_LABEL(name)

__attribute__((noinline))
void	*ft_memcpy(void *dest, const void *src, size_t n)
{
	char				*save_pointer = dest;
	unsigned char		*d = dest;
	const unsigned char	*s = src;

	asm volatile("" : : "g"(&save_pointer) : "memory");

	if (!src || !dest)
		save_pointer = NULL;
	else {
		ASM_L(loop_start);
		if (n > 0) {
			do {
				ASM_L(loop_body);
				*d++ = *s++;
				ASM_L(loop_iter);
			} while (--n > 0);
			ASM_L(loop_end);
		}
	}
	return (save_pointer);
}

/*
int main(int argc, char **argv) {
	char buf[42];
	const char *str = "Wello Horld!";

	ft_memcpy(buf, str, sizeof("Wello Horld!"));
	(void)argv;
	(void)argc;
}
*/
