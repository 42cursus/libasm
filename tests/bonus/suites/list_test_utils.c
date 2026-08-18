/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   list_test_utils.c                                  :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: abelov <abelov@student.42london.com>       +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/08/18 16:50:00 by abelov            #+#    #+#             */
/*   Updated: 2026/08/18 16:50:00 by abelov           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <assert.h>
#include <stdlib.h>

#include "suites.h"

int	*list_test_new_int(int value)
{
	int	*number;

	number = malloc(sizeof(*number));
	assert(number != NULL);
	*number = value;
	return (number);
}

int	list_test_compare_ints(void *first, void *second)
{
	const int	first_value = *(const int *)first;
	const int	second_value = *(const int *)second;

	return ((first_value > second_value) - (first_value < second_value));
}

void	list_test_free_nodes(t_list *list)
{
	t_list	*next;

	while (list != NULL)
	{
		next = list->next;
		free(list);
		list = next;
	}
}

void	list_test_free_list(t_list *list)
{
	t_list	*next;

	while (list != NULL)
	{
		next = list->next;
		free(list->data);
		free(list);
		list = next;
	}
}
