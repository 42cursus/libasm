# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile.mk                                        :+:      :+:    :+:   #
#                                                     +:+ +:+         +:+      #
#    By: abelov <abelov@student.42london.com>       +#+  +:+       +#+        #
#                                                 +#+#+#+#+#+   +#+           #
#    Created: 2026/08/18 16:40:00 by abelov            #+#    #+#             #
#    Updated: 2026/08/18 16:40:00 by abelov           ###   ########.fr       #
#                                                                              #
# **************************************************************************** #

FILES	= main.c \
		  suites/test_atoi_base.c \
		  suites/test_list_push_front.c \
		  suites/test_list_size.c \
		  suites/test_list_sort.c \
		  suites/test_list_remove_if.c \
		  suites/list_test_utils.c \
		  study/ft_list_sort.c

BONUS_TEST_SRCS += $(FILES:%.c=$(dir $(lastword $(MAKEFILE_LIST)))%.c)
