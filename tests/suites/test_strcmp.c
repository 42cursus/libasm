/* ************************************************************************** */
/*                                                                            */
/*   test_strcmp.c — exercises ft_strcmp against man strcmp(3) semantics.     */
/*                                                                            */
/* ************************************************************************** */

#include <string.h>

#include "../test.h"
#include "libasm.h"
#include "suites.h"

void	test_strcmp(void)
{
	/* Equality. */
	ASSERT_EQ_INT(ft_strcmp("", ""), 0);
	ASSERT_EQ_INT(ft_strcmp("hello", "hello"), 0);

	/* Sign agreement with libc strcmp (magnitude is unspecified). */
	ASSERT_SAME_SIGN(ft_strcmp("abc", "abd"), strcmp("abc", "abd"));
	ASSERT_SAME_SIGN(ft_strcmp("abd", "abc"), strcmp("abd", "abc"));
	ASSERT_SAME_SIGN(ft_strcmp("abc", "abcd"), strcmp("abc", "abcd"));
	ASSERT_SAME_SIGN(ft_strcmp("abcd", "abc"), strcmp("abcd", "abc"));
	ASSERT_SAME_SIGN(ft_strcmp("", "x"), strcmp("", "x"));
	ASSERT_SAME_SIGN(ft_strcmp("x", ""), strcmp("x", ""));

	/* Unsigned byte comparison: 0x80 must compare greater than 0x7f. */
	const char hi[] = { (char)0x80, '\0' };
	const char lo[] = { 0x7f,        '\0' };
	ASSERT_SAME_SIGN(ft_strcmp(hi, lo), strcmp(hi, lo));
	ASSERT_TRUE(ft_strcmp(hi, lo) > 0);
}
