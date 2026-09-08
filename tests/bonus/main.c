/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: abelov <abelov@student.42london.com>       +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/08/18 16:50:00 by abelov            #+#    #+#             */
/*   Updated: 2026/08/18 16:50:00 by abelov           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdio.h>

#include "../test.h"
#include "suites/suites.h"

unsigned long	g_test_count;
unsigned long	g_test_failed;

int	main(void)
{
	fputs("libasm bonus tests\n", stderr);
	RUN_SUITE(test_atoi_base);
	RUN_SUITE(test_list_push_front);
	RUN_SUITE(test_list_size);
	RUN_SUITE(test_list_sort);
	RUN_SUITE(test_list_remove_if);
	fprintf(stderr, "\n%lu assertions, %lu failed\n",
		g_test_count, g_test_failed);
	return (g_test_failed != 0);
}
