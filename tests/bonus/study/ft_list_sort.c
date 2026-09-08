/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_list_sort.c                                     :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: abelov <abelov@student.42london.com>       +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/08/24 03:58:38 by abelov            #+#    #+#             */
/*   Updated: 2026/08/24 03:58:38 by abelov           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */


#include <stdbool.h>
#include <stddef.h>
#include "libasm_bonus.h"

typedef int (cmp_fun)(void *, void *);

void ft_list_sort_c(t_list **begin_list, cmp_fun *cmp)

{
	t_list	*curr;
	void	*tmp;
	bool	swapped;

	if (!begin_list || !*begin_list || !cmp)
		return;
	do {
		swapped = false;
		for (curr = *begin_list; curr->next != NULL; curr = (t_list *)curr->next) {
			if (cmp(curr->data, curr->next->data) > 0) {
				tmp = curr->data;
				curr->data = curr->next->data;
				curr->next->data = tmp;
				swapped = true;
			}
		}
	} while (swapped);
}
