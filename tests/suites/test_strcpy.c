/* ************************************************************************** */
/*                                                                            */
/*   test_strcpy.c — exercises ft_strcpy against man strcpy(3) semantics.     */
/*                                                                            */
/* ************************************************************************** */

#include <string.h>

#include "../debug.h"
#include "../test.h"
#include "libasm.h"
#include "suites.h"

void	test_strcpy(void)
{
	char dst[64];

	/* Empty source still writes the NUL. */
	memset(dst, 'Z', sizeof(dst));
	char *ret = ft_strcpy(dst, "");
	ASSERT_TRUE(ret == dst);
	ASSERT_EQ_INT(dst[0], '\0');
	ASSERT_EQ_INT((unsigned char)dst[1], 'Z'); /* unchanged past terminator */

	/* Normal copy. */
	memset(dst, 'Z', sizeof(dst));
	ret = ft_strcpy(dst, "hello");
	ASSERT_TRUE(ret == dst);
	ASSERT_STR_EQ(dst, "hello");
	ASSERT_EQ_INT((unsigned char)dst[6], 'Z');

	/* Longer string. */
	const char *src = "The quick brown fox jumps over the lazy dog.";
	memset(dst, 0, sizeof(dst));
	ret = ft_strcpy(dst, src);
	ASSERT_TRUE(ret == dst);
	ASSERT_STR_EQ(dst, src);

	/* Overlap (dst > src, copying forward is safe per the man page —
	 * undefined behaviour otherwise; we exercise the safe case). */
	char buf[16] = "abcdef";
	ret = ft_strcpy(buf + 8, buf);
	ASSERT_STR_EQ(buf + 8, "abcdef");
	ASSERT_TRUE(ret == buf + 8);
}
