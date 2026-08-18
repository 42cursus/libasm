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

FILES	= test_strlen.c \
		  test_strcpy.c \
		  test_strcmp.c \
		  test_strdup.c \
		  test_write.c \
		  test_read.c

TEST_SRCS += $(FILES:%.c=$(dir $(lastword $(MAKEFILE_LIST)))%.c)
