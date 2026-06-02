/* ************************************************************************** */
/*                                                                            */
/*   test_strlen.c — exercises ft_strlen against man strlen(3) semantics.     */
/*                                                                            */
/* ************************************************************************** */

#include <string.h>

#include "../debug.h"
#include "../test.h"
#include "libasm.h"
#include "suites.h"

void	test_strlen(void)
{
	ASM_L(test_strlen_enter);

	ASSERT_EQ_SIZE(ft_strlen(""), 0);
	ASSERT_EQ_SIZE(ft_strlen("a"), 1);
	ASSERT_EQ_SIZE(ft_strlen("hello"), 5);
	ASSERT_EQ_SIZE(ft_strlen("hello, world!"), 13);

	/* Embedded NUL stops the count. */
	ASSERT_EQ_SIZE(ft_strlen("abc\0def"), 3);

	/* Long, non-aligned input (covers any scasb / repne edge cases). */
	char buf[1024];
	memset(buf, 'x', sizeof(buf) - 1);
	buf[sizeof(buf) - 1] = '\0';
	ASSERT_EQ_SIZE(ft_strlen(buf), sizeof(buf) - 1);

	/* Parity with libc strlen on a handful of inputs. */
	const char *samples[] = {
		"", "a", "ab", "abc", "abcd", "abcde",
		"The quick brown fox jumps over the lazy dog.",
		NULL,
	};
	for (size_t i = 0; samples[i] != NULL; i++)
		ASSERT_EQ_SIZE(ft_strlen(samples[i]), strlen(samples[i]));
}
