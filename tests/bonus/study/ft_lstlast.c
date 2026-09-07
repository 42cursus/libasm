/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_lstlast.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: yublee <yublee@student.42london.com>       +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2023/11/18 14:31:09 by yublee            #+#    #+#             */
/*   Updated: 2026/09/08 00:30:48 by abelov           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libasm_bonus.h"

t_list	*ft_lstlast_c(t_list *lst)
{
	if (!lst)
		return (NULL);
	while (lst->next)
		lst = lst->next;
	return (lst);
}

t_list	*ft_lstlast_c2(t_list *lst)
{
	while (lst)
	{
		if (!lst->next)
			break;
		lst = lst->next;
	}
	return (lst);
}

t_list	*ft_lstlast_c3(t_list *lst)
{
	for (;;)
	{
		if (!lst)
			break;
		if(!lst->next)
			break;
		__asm__ volatile ("" : "+D" (lst));
		lst = lst->next;
	}
	return (lst);
}
