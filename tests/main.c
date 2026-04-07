/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: abelov <abelov@student.42london.com>       +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/04/07 15:21:47 by abelov            #+#    #+#             */
/*   Updated: 2026/04/07 15:21:47 by abelov           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdlib.h>
#include <unistd.h>
#include "libasm.h"

int main(int argc, char *argv[]) {

	char buf[1024] = "Program name is: ";

	if (ft_write(STDOUT_FILENO, buf, ft_strlen(buf)) < 0) {
		return (EXIT_FAILURE);
	}
	return (EXIT_SUCCESS);
	(void)argv;
	(void)argc;
}
