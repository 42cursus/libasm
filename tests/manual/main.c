/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: abelov <abelov@student.42london.com>       +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/08/18 17:01:36 by abelov            #+#    #+#             */
/*   Updated: 2026/08/18 17:01:36 by abelov           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include "libasm.h"

#define BUFFER_SIZE 256

int	main(void)
{
	static const char	prompt[] = "Enter a line: ";
	char				input[BUFFER_SIZE];
	char				copy[BUFFER_SIZE];
	char				*duplicate;
	ssize_t				read_count;

	if (ft_write(STDOUT_FILENO, prompt, ft_strlen(prompt)) == -1)
		return (perror("ft_write"), EXIT_FAILURE);
	read_count = ft_read(STDIN_FILENO, input, sizeof(input) - 1);
	if (read_count == -1)
		return (perror("ft_read"), EXIT_FAILURE);
	input[read_count] = '\0';
	ft_strcpy(copy, input);
	duplicate = ft_strdup(input);
	if (duplicate == NULL)
		return (perror("ft_strdup"), EXIT_FAILURE);
	printf("ft_strlen: %zu\n", ft_strlen(input));
	printf("ft_strcmp(input, copy): %d\n", ft_strcmp(input, copy));
	printf("ft_strcmp(input, strdup): %d\n", ft_strcmp(input, duplicate));
	printf("ft_strdup: %s", duplicate);
	free(duplicate);
	return (EXIT_SUCCESS);
}
