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

FILES	= ft_strlen.s \
		  ft_strcpy.s \
		  ft_strcmp.s \
		  ft_strdup.s

MANDATORY_SRCS += $(FILES:%.s=$(dir $(lastword $(MAKEFILE_LIST)))%.s)
