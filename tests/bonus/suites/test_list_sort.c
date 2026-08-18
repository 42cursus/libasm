/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   test_list_sort.c                                   :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: abelov <abelov@student.42london.com>       +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/08/18 16:50:00 by abelov            #+#    #+#             */
/*   Updated: 2026/08/18 16:50:00 by abelov           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../../test.h"
#include "suites.h"

void	test_list_sort(void)
{
	t_list	*list;

	list = NULL;
	ft_list_sort(&list, list_test_compare_ints);
	ft_list_push_front(&list, list_test_new_int(3));
	ft_list_push_front(&list, list_test_new_int(1));
	ft_list_push_front(&list, list_test_new_int(2));
	ft_list_push_front(&list, list_test_new_int(2));
	ft_list_sort(&list, list_test_compare_ints);
	ASSERT_EQ_INT(*(int *)list->data, 1);
	ASSERT_EQ_INT(*(int *)list->next->data, 2);
	ASSERT_EQ_INT(*(int *)list->next->next->data, 2);
	ASSERT_EQ_INT(*(int *)list->next->next->next->data, 3);
	list_test_free_list(list);
}
