/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strlen2.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: abelov <abelov@student.42london.com>       +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/04/07 18:58:56 by abelov            #+#    #+#             */
/*   Updated: 2026/04/07 18:58:56 by abelov           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdint.h>
#include <stddef.h>

/**
 * @file ft_strlen2.c
 * @brief Fast strlen-like routine using 32-bit word scanning (GNU C).
 *
 * This implementation computes the length of a NUL-terminated C string by:
 *   1) advancing byte-by-byte until the pointer is 4-byte aligned, then
 *   2) reading 32-bit words and using a "has zero byte" bit trick to detect
 *      whether any of the 4 bytes are zero, then
 *   3) determining which byte is the first NUL within that word.
 *
 * The zero-byte detection uses:
 *   m = (x - 0x01010101) & ~x & 0x80808080
 *
 * If any byte of x is 0x00, the corresponding high bit in m becomes 1.
 *
 * @warning Portability/UB notes:
 * - This function assumes it is acceptable to read the string as 32-bit words
 *   once the pointer is 4-byte aligned. It may still read past the terminating
 *   NUL within the last loaded word, which is common in optimized strlen
 *   implementations but can be undefined behavior if it crosses into unmapped
 *   memory (e.g., NUL byte is at the end of a mapped page and the next page is
 *   unmapped).
 * - It relies on GNU C behavior for type-punning through a casted pointer.
 * - It does not require a specific endianness, the "has zero byte" test works
 *   byte-wise regardless of byte order. The follow-up logic interprets m by
 *   byte position within the loaded word, not by integer value semantics.
 *
 * @param s Pointer to a NULL-terminated string.
 * @return The number of bytes preceding the first NUL terminator.
 */
size_t ft_strlen_fast(const char *s)
{
	const char *p = s;

	/*
	 * Peel bytes until p is 4-byte aligned.
	 *
	 * We can only safely perform 32-bit loads on architectures that require
	 * alignment once p is 4-byte aligned. The loop performs up to 3 byte loads.
	 * If we encounter NUL during peeling, we return immediately.
	 */
	while (((uintptr_t)p & 3u) != 0u) {
		if (*p == '\0')
			return (size_t)(p - s);
		p++;
	}

	/*
	 * Main loop: scan 4 bytes at a time.
	 *
	 * For each aligned word x, compute m such that each byte position that
	 * contained 0x00 sets the corresponding high bit in m.
	 */
	for (;;) {
		uint32_t x = *(const uint32_t *)p;
		p += 4;

		/*
		 * Detect zero byte in x (classic bit trick):
		 * - For a byte b:
		 *     (b - 1) will underflow and set the high bit if b == 0.
		 * - ~b has the high bit set if b had the high bit clear.
		 * Combining across bytes with masks yields:
		 *     m != 0  <=> at least one byte of x is 0x00
		 */
		uint32_t m = (x - 0x01010101u) & ~x & 0x80808080u;
		if (m == 0u)
			continue;

		/*
		 * At least one of the previous 4 bytes (in [p-4, p)) is NUL.
		 * base starts at the beginning of that word, then we bump it to the
		 * first NUL byte position.
		 */
		const char *base = p - 4;

		/*
		 * m has one high bit set per zero byte location. We want the first NUL
		 * in address order.
		 *
		 * The grouping below checks whether either of the first two bytes in
		 * the word were zero; if not, we skip them and consider the upper half.
		 *
		 * Note: braces are intentionally used because only the base adjustment
		 * must be conditional, the shift must be conditional too, and keeping
		 * them on one line without braces would be a bug magnet.
		 */
		if ((m & 0x00008080u) == 0u) {
			base += 2;
			m >>= 16;
		}

		/* If the first byte of the remaining 2-byte window is not zero, skip it. */
		if ((m & 0x00000080u) == 0u)
			base += 1;

		return (size_t)(base - s);
	}
}

__attribute__((used))
size_t ft_strlen_dummy(const char *s) {
	size_t len;

	int i = 0;
	while (s[i++] != 0)
		;
	len = i;
	return (len);
}
