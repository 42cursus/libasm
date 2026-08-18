/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   test_list_remove_if.c                              :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: abelov <abelov@student.42london.com>       +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/08/18 16:50:00 by abelov            #+#    #+#             */
/*   Updated: 2026/08/18 16:50:00 by abelov           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdlib.h>

#include "../../test.h"
#include "suites.h"

static unsigned int	g_free_count;

static void	counted_free(void *data)
{
	++g_free_count;
	free(data);
}

void	test_list_remove_if(void)
{
	t_list	*list;
	int		reference;

	list = NULL;
	ft_list_push_front(&list, list_test_new_int(3));
	ft_list_push_front(&list, list_test_new_int(1));
	ft_list_push_front(&list, list_test_new_int(2));
	ft_list_push_front(&list, list_test_new_int(2));
	reference = 2;
	g_free_count = 0;
	ft_list_remove_if(&list, &reference, list_test_compare_ints, counted_free);
	ASSERT_EQ_SIZE(g_free_count, 2);
	ASSERT_EQ_SIZE(ft_list_size(list), 2);
	ASSERT_EQ_INT(*(int *)list->data, 1);
	ASSERT_EQ_INT(*(int *)list->next->data, 3);
	list_test_free_list(list);
}
