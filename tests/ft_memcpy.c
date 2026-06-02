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

void *ft_memcpy(void *dest, const void *src, size_t n) {
	asm volatile("" : : "g"(&dest) : "memory");
	asm volatile("" : : "g"(&src) : "memory");
	asm volatile("" : : "g"(&n) : "memory");
	return memcpy(dest, src, n);
}
