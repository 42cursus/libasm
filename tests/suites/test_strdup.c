/* ************************************************************************** */
/*                                                                            */
/*   test_strdup.c — exercises ft_strdup against man strdup(3) semantics.     */
/*                                                                            */
/* ************************************************************************** */

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "../test.h"
#include "libasm.h"
#include "suites.h"

void	test_strdup(void)
{
	const char *samples[] = { "", "a", "hello", "The quick brown fox.", NULL };
	for (size_t i = 0; samples[i] != NULL; i++)
	{
		errno = 0;
		char *dup = ft_strdup(samples[i]);
		ASSERT_TRUE(dup != NULL);
		ASSERT_TRUE(dup != samples[i]);          /* fresh allocation */
		ASSERT_STR_EQ(dup, samples[i]);
		ASSERT_EQ_INT(errno, 0);                 /* unchanged on success */
		free(dup);
	}
}
