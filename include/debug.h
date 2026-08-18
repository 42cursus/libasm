/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   debug.h                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: abelov <abelov@student.42london.com>       +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/06/02 21:13:49 by abelov            #+#    #+#             */
/*   Updated: 2026/06/02 21:13:49 by abelov           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

/*
 * Debug helpers used by the test suites to make stepping through generated
 * code easier under GDB. None of these are required for correctness.
 *
 *   escape(p)                — a function-call optimization barrier; the
 *                              compiler must assume the pointee may be read
 *                              or written by an unknown function.
 *   MATERIALIZE_IN_REG(x)    — force `x` into a register at this point
 *                              without any memory clobber.
 *   ASM_DBG_LABEL(name) / ASM_L(name)
 *                            — emit a global label inline in the surrounding
 *                              C so it shows up in objdump / GDB and can be
 *                              used as a breakpoint anchor.
 */

#ifndef LIBASM_TEST_DEBUG_H
#define LIBASM_TEST_DEBUG_H

#define DBG_STR1_(x) #x
#define DBG_STR_(x)  DBG_STR1_(x)

#define ASM_DBG_LABEL(name) \
	asm volatile( \
		".loc 1 " DBG_STR_(__LINE__) " 0\n\t" \
		".globl " #name "\n" \
		#name ":\n\t" \
		: : : "memory")

#define ASM_L(name) ASM_DBG_LABEL(name)

#define MATERIALIZE_IN_REG(x) __asm__ volatile ("" : "+r"(x))

__attribute__((always_inline))
static inline void escape(void *p)
{
	asm volatile("" : : "g"(p) : "memory");
}

#endif /* LIBASM_TEST_DEBUG_H */
