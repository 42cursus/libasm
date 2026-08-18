/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   bonus_tests.h                                      :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: abelov <abelov@student.42london.com>       +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/08/18 16:50:00 by abelov            #+#    #+#             */
/*   Updated: 2026/08/18 16:50:00 by abelov           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef LIBASM_BONUS_TEST_SUITES_H
# define LIBASM_BONUS_TEST_SUITES_H

# include "libasm_bonus.h"

void	test_list_push_front(void);
void	test_list_size(void);
void	test_list_sort(void);
void	test_list_remove_if(void);
int		*list_test_new_int(int value);
int		list_test_compare_ints(void *first, void *second);
void	list_test_free_nodes(t_list *list);
void	list_test_free_list(t_list *list);

#endif
