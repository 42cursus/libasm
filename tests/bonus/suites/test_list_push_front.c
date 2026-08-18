/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   test_list_push_front.c                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: abelov <abelov@student.42london.com>       +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/08/18 16:50:00 by abelov            #+#    #+#             */
/*   Updated: 2026/08/18 16:50:00 by abelov           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../../test.h"
#include "suites.h"

void	test_list_push_front(void)
{
	t_list	*list;

	list = NULL;
	ft_list_push_front(&list, (void *)1);
	ASSERT_TRUE(list != NULL);
	ASSERT_TRUE(list->data == (void *)1);
	ASSERT_TRUE(list->next == NULL);
	ft_list_push_front(&list, (void *)2);
	ASSERT_TRUE(list->data == (void *)2);
	ASSERT_TRUE(list->next->data == (void *)1);
	ASSERT_TRUE(list->next->next == NULL);
	list_test_free_nodes(list);
	ft_list_push_front(NULL, (void *)1);
}
