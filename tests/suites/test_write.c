/* ************************************************************************** */
/*                                                                            */
/*   test_write.c — exercises ft_write against man write(2) semantics.        */
/*                                                                            */
/* ************************************************************************** */

#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

#include "../test.h"
#include "libasm.h"
#include "suites.h"

void	test_write(void)
{
	/* Successful write into a tmpfile; read it back and verify content. */
	FILE *tmp = tmpfile();
	ASSERT_TRUE(tmp != NULL);
	if (!tmp)
		return;
	int fd = fileno(tmp);

	const char *msg = "hello, libasm\n";
	size_t      len = strlen(msg);

	errno = 0;
	ssize_t n = ft_write(fd, msg, len);
	ASSERT_EQ_INT(n, (ssize_t)len);
	ASSERT_EQ_INT(errno, 0);

	/* Read it back. */
	lseek(fd, 0, SEEK_SET);
	char buf[64] = {0};
	ssize_t r = read(fd, buf, sizeof(buf) - 1);
	ASSERT_EQ_INT(r, (ssize_t)len);
	ASSERT_STR_EQ(buf, msg);
	fclose(tmp);

	/* Invalid fd: -1 and errno set to EBADF. */
	errno = 0;
	ASSERT_EQ_INT(ft_write(-1, "x", 1), -1);
	ASSERT_EQ_INT(errno, EBADF);
}
