/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_list_size.c                                     :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: abelov <abelov@student.42london.com>       +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/03/21 20:08:46 by abelov            #+#    #+#             */
/*   Updated: 2024/05/16 00:22:13 by abelov           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */


/*
#include <stddef.h>
#include "libasm_bonus.h"

__attribute__((noinline,used,optimize("-O0")))
static void escape(void *p) {
	__asm__ volatile("" : : "g"(p) : "memory");
}
*/

typedef __SIZE_TYPE__ size_t;

typedef struct s_list
{
	void			*data;
	struct s_list	*next;
}	t_list;

size_t	ft_list_size_c(t_list *list)
{
	size_t	size = 1;
//	escape(&size);
	if (!list)
		return (0);
	size = 1;
	while (list->next)
	{
		list = list->next;
		size++;
	}
	return (size);
}


int	ft_list_size_c2(t_list *list)
{
	int	size = 0;

	while (list)
	{
		__asm__ volatile ("" : "+D" (list)); // At this point, lst must live in rdi.
		list = list->next;
		size++;
		__asm__ volatile ("" ::: "memory");
	}
	return (size);
}

int	ft_list_size_c3(t_list *list)
{
	int	size = 0;

	for (;;)
	{
		if (!list)
			break;
		list = list->next;
		size++;
	}
	return (size);
}

