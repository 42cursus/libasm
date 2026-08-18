/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   test_list_size.c                                   :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: abelov <abelov@student.42london.com>       +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/08/18 16:50:00 by abelov            #+#    #+#             */
/*   Updated: 2026/08/18 16:50:00 by abelov           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../../test.h"
#include "suites.h"

void	test_list_size(void)
{
	t_list	*list;

	list = NULL;
	ASSERT_EQ_SIZE(ft_list_size(list), 0);
	ft_list_push_front(&list, (void *)1);
	ASSERT_EQ_SIZE(ft_list_size(list), 1);
	ft_list_push_front(&list, (void *)2);
	ASSERT_EQ_SIZE(ft_list_size(list), 2);
	list_test_free_nodes(list);
}
