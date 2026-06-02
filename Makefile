# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: abelov <abelov@student.42london.com>       +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/04/07 03:17:12 by abelov            #+#    #+#              #
#    Updated: 2026/06/02 11:50:00 by abelov           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME			= libasm.a
TEST_TARGET		= libasm_test

BUILD_DIR		= build
INC_DIR			= ./include
SRC_DIR			= src
TEST_DIR		= tests
OBJ_DIR			= $(BUILD_DIR)/objs

CC				:= gcc
AR				= ar
RANLIB			= ranlib
ASM_NASM		= nasm
READELF			= readelf

ASM_FLAGS		= -f elf64 -g -F dwarf

MANDATORY_FLAGS	:= -Wall -Wextra -Werror
OPTIMIZE_FLAGS	:= -Og \
					-Wa,-L \
					-mmanual-endbr \
					-minline-all-stringops \
					-fno-asynchronous-unwind-tables \
					-fno-stack-clash-protection \
					-fcf-protection=none \
					-fno-stack-protector \
					-fno-omit-frame-pointer \
					-mno-red-zone
DEBUG_FLAGS		:= -g3 -gdwarf-3
CFLAGS			= $(MANDATORY_FLAGS) $(DEBUG_FLAGS) $(OPTIMIZE_FLAGS)

INCLUDE_FLAGS	:= -I. -I$(INC_DIR) \
					-I/usr/include \
					-I/usr/include/x86_64-linux-gnu

# ---------------------------------------------------------------------------- #
# Source discovery                                                             #
#                                                                              #
#   Mandatory sources live under src/string and src/io.                        #
#   Bonus sources end in `_bonus.s` and live under src/bonus.                  #
#   Extra (non-graded) helpers live under src/extra and are NEVER linked into  #
#   libasm.a (would fail the moulinette).                                      #
# ---------------------------------------------------------------------------- #

SRCS			:= $(wildcard $(SRC_DIR)/string/*.s) \
				   $(wildcard $(SRC_DIR)/io/*.s)
BONUS_SRCS		:= $(wildcard $(SRC_DIR)/bonus/*_bonus.s)

OBJS			:= $(SRCS:$(SRC_DIR)/%.s=$(OBJ_DIR)/%.o)
BONUS_OBJS		:= $(BONUS_SRCS:$(SRC_DIR)/%.s=$(OBJ_DIR)/%.o)

TEST_SRCS		:= $(wildcard $(TEST_DIR)/*.c)
TEST_OBJS		:= $(TEST_SRCS:$(TEST_DIR)/%.c=$(OBJ_DIR)/test/%.o)
TEST_LDLIBS		= -lasm -lbsd
TEST_LDFLAGS	= -L.

# ---------------------------------------------------------------------------- #
# Targets                                                                      #
# ---------------------------------------------------------------------------- #

all: $(NAME) $(TEST_TARGET)

$(NAME): $(OBJS)
		$(info ********** BUILDING $(@) ************)
		@$(AR) rcsP $(NAME) $(OBJS)
		@$(RANLIB) $(NAME)
		@$(READELF) -sW $(@) | sed -n '1,3p;/FUNC/p'

# `make bonus` (re)builds libasm.a containing mandatory + bonus objects, as
# required by the subject.
bonus: $(OBJS) $(BONUS_OBJS)
		$(info ********** BUILDING $(NAME) (with bonus) ************)
		@$(AR) rcsP $(NAME) $(OBJS) $(BONUS_OBJS)
		@$(RANLIB) $(NAME)
		@$(READELF) -sW $(NAME) | sed -n '1,3p;/FUNC/p'

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.s
		@mkdir -p $(@D)
		@$(ASM_NASM) $(ASM_FLAGS) $< -o $@

$(OBJ_DIR)/test/%.o: $(TEST_DIR)/%.c
		@mkdir -p $(@D)
		@$(CC) $(CFLAGS) $(INCLUDE_FLAGS) -c $< -o $@

$(TEST_TARGET): $(TEST_OBJS) $(NAME)
		@$(CC) $(CFLAGS) $(TEST_LDFLAGS) -o $(TEST_TARGET) $(TEST_OBJS) $(TEST_LDLIBS)

clean:
		@$(RM) -rfv $(OBJ_DIR)

fclean: clean
		@$(RM) -vf $(NAME) $(TEST_TARGET)

re: fclean
		+@$(MAKE) all --no-print-directory

.SECONDARY: $(OBJS) $(BONUS_OBJS)
.PHONY: all bonus clean fclean re
