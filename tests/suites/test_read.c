/* ************************************************************************** */
/*                                                                            */
/*   test_read.c — exercises ft_read against man read(2) semantics.           */
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

void	test_read(void)
{
	/* Prepare a tmpfile with known content and read it back. */
	FILE *tmp = tmpfile();
	ASSERT_TRUE(tmp != NULL);
	if (!tmp)
		return;
	int fd = fileno(tmp);

	const char *payload = "hello, libasm";
	const size_t len = strlen(payload);
	ASSERT_EQ_INT(write(fd, payload, len), (ssize_t)len);
	lseek(fd, 0, SEEK_SET);

	char buf[64] = {0};
	errno = 0;
	ssize_t n = ft_read(fd, buf, sizeof(buf) - 1);
	ASSERT_EQ_INT(n, (ssize_t)len);
	ASSERT_EQ_INT(errno, 0);
	ASSERT_STR_EQ(buf, payload);

	/* End of file returns 0. */
	errno = 0;
	n = ft_read(fd, buf, sizeof(buf) - 1);
	ASSERT_EQ_INT(n, 0);
	ASSERT_EQ_INT(errno, 0);
	fclose(tmp);

	/* Invalid fd: -1 and errno = EBADF. */
	errno = 0;
	char dummy[4];
	ASSERT_EQ_INT(ft_read(-1, dummy, sizeof(dummy)), -1);
	ASSERT_EQ_INT(errno, EBADF);
}
