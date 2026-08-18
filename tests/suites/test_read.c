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

	/* Feed binary data through stdin, then consume it in two reads. */
	int stdin_backup = dup(STDIN_FILENO);
	int stdin_pipe[2];
	int stdin_pipe_status = pipe(stdin_pipe);
	const unsigned char stdin_payload[] = {'p', 'i', 'p', 'e', '\0', 'r', 'd'};
	const size_t stdin_first_read = 5;
	ASSERT_TRUE(stdin_backup >= 0);
	ASSERT_EQ_INT(stdin_pipe_status, 0);
	if (stdin_backup < 0 || stdin_pipe_status != 0)
	{
		if (stdin_backup >= 0)
			close(stdin_backup);
		return;
	}
	ASSERT_EQ_INT(write(stdin_pipe[1], stdin_payload, sizeof(stdin_payload)),
		(ssize_t)sizeof(stdin_payload));
	close(stdin_pipe[1]);
	if (dup2(stdin_pipe[0], STDIN_FILENO) != STDIN_FILENO)
	{
		close(stdin_pipe[0]);
		close(stdin_backup);
		return;
	}
	close(stdin_pipe[0]);
	memset(buf, 0, sizeof(buf));
	ASSERT_EQ_INT(ft_read(STDIN_FILENO, buf, stdin_first_read),
		(ssize_t)stdin_first_read);
	ASSERT_TRUE(memcmp(buf, stdin_payload, stdin_first_read) == 0);
	memset(buf, 0, sizeof(buf));
	ASSERT_EQ_INT(ft_read(STDIN_FILENO, buf,
			sizeof(stdin_payload) - stdin_first_read),
		(ssize_t)(sizeof(stdin_payload) - stdin_first_read));
	ASSERT_TRUE(memcmp(buf, stdin_payload + stdin_first_read,
			sizeof(stdin_payload) - stdin_first_read) == 0);
	ASSERT_EQ_INT(ft_read(STDIN_FILENO, buf, sizeof(buf)), 0);
	ASSERT_EQ_INT(dup2(stdin_backup, STDIN_FILENO), STDIN_FILENO);
	close(stdin_backup);
}
