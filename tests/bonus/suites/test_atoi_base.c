/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   test_atoi_base.c                                   :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: abelov <abelov@student.42london.com>       +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2026/08/18 17:10:00 by abelov            #+#    #+#             */
/*   Updated: 2026/08/18 17:10:00 by abelov           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <limits.h>

#include "../../test.h"
#include "suites.h"

void	test_atoi_base(void)
{
	ASSERT_EQ_INT(ft_atoi_base("2a", "0123456789abcdef"), 42);
	ASSERT_EQ_INT(ft_atoi_base("   --------+-2a", "0123456789abcdef"), -42);
	ASSERT_EQ_INT(ft_atoi_base("   -+-2a", "0123456789abcdef"), 42);
	ASSERT_EQ_INT(ft_atoi_base("1012", "01"), 5);
	ASSERT_EQ_INT(ft_atoi_base(" \v7fffffff", "0123456789abcdef"), INT_MAX);
	ASSERT_EQ_INT(ft_atoi_base("-2147483648", "0123456789"), INT_MIN);
	ASSERT_EQ_INT(ft_atoi_base("123", ""), 0);
	ASSERT_EQ_INT(ft_atoi_base("123", "0"), 0);
	ASSERT_EQ_INT(ft_atoi_base("123", "+-0"), 0);
	ASSERT_EQ_INT(ft_atoi_base("123", "\t01"), 0);
	ASSERT_EQ_INT(ft_atoi_base("123", "001"), 0);
	ASSERT_EQ_INT(ft_atoi_base("   --------+-g", "0123456789abcdef"), 0);
}
