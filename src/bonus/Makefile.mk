# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile.mk                                        :+:      :+:    :+:   #
#                                                     +:+ +:+         +:+      #
#    By: abelov <abelov@student.42london.com>       +#+  +:+       +#+        #
#                                                 +#+#+#+#+#+   +#+           #
#    Created: 2026/08/18 16:25:00 by abelov            #+#    #+#             #
#    Updated: 2026/08/18 16:25:00 by abelov           ###   ########.fr       #
#                                                                              #
# **************************************************************************** #

FILES	= ft_atoi_base_bonus.s \
		  ft_list_push_front_bonus.s \
		  ft_list_size_bonus.s \
		  ft_list_sort_bonus.s \
		  ft_list_remove_if_bonus.s

BONUS_SRCS += $(FILES:%.s=$(dir $(lastword $(MAKEFILE_LIST)))%.s)
