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

FILES	= ft_memcpy.c \
		  ft_strcpy.c \
		  ft_strdup.c

TEST_SRCS += $(FILES:%.c=$(dir $(lastword $(MAKEFILE_LIST)))%.c)
