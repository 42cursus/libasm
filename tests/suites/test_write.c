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

	/* Redirect stdout to a pipe and preserve embedded NUL bytes. */
	int stdout_backup = dup(STDOUT_FILENO);
	int stdout_pipe[2];
	int stdout_pipe_status = pipe(stdout_pipe);
	const char stdout_payload[] = {'p', 'i', 'p', 'e', '\0', 'w', 'r'};
	ASSERT_TRUE(stdout_backup >= 0);
	ASSERT_EQ_INT(stdout_pipe_status, 0);
	if (stdout_backup < 0 || stdout_pipe_status != 0)
	{
		if (stdout_backup >= 0)
			close(stdout_backup);
		return;
	}
	if (dup2(stdout_pipe[1], STDOUT_FILENO) != STDOUT_FILENO)
	{
		close(stdout_pipe[0]);
		close(stdout_pipe[1]);
		close(stdout_backup);
		return;
	}
	close(stdout_pipe[1]);
	ASSERT_EQ_INT(ft_write(STDOUT_FILENO, stdout_payload, sizeof(stdout_payload)),
		(ssize_t)sizeof(stdout_payload));
	ASSERT_EQ_INT(ft_write(STDOUT_FILENO, "", 0), 0);
	ASSERT_EQ_INT(dup2(stdout_backup, STDOUT_FILENO), STDOUT_FILENO);
	close(stdout_backup);
	memset(buf, 0, sizeof(buf));
	ASSERT_EQ_INT(read(stdout_pipe[0], buf, sizeof(buf)), (ssize_t)sizeof(stdout_payload));
	ASSERT_TRUE(memcmp(buf, stdout_payload, sizeof(stdout_payload)) == 0);
	ASSERT_EQ_INT(read(stdout_pipe[0], buf, sizeof(buf)), 0);
	close(stdout_pipe[0]);
}
