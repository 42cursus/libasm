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

MANDATORY_FLAGS	:= -Wall -Wextra -Werror # -fsanitize=address,undefined
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
# Source lists                                                                 #
#                                                                              #
# Each directory owns an explicit Makefile.mk list. This keeps the archive     #
# inputs auditable and prevents study/extra sources from being included.       #
# ---------------------------------------------------------------------------- #

MANDATORY_DIRS	:= $(SRC_DIR)/string $(SRC_DIR)/io
BONUS_DIR		:= $(SRC_DIR)/bonus
TEST_SOURCE_DIRS := $(TEST_DIR) $(TEST_DIR)/suites $(TEST_DIR)/study

MANDATORY_SRCS	:=
BONUS_SRCS		:=
TEST_SRCS		:=

include $(MANDATORY_DIRS:%=%/Makefile.mk)
include $(BONUS_DIR)/Makefile.mk
include $(TEST_SOURCE_DIRS:%=%/Makefile.mk)

SRCS			:= $(MANDATORY_SRCS)

OBJS			:= $(SRCS:$(SRC_DIR)/%.s=$(OBJ_DIR)/%.o)
BONUS_OBJS		:= $(BONUS_SRCS:$(SRC_DIR)/%.s=$(OBJ_DIR)/%.o)

TEST_OBJS		:= $(TEST_SRCS:$(TEST_DIR)/%.c=$(OBJ_DIR)/test/%.o)
DEPS			:= $(OBJS:.o=.d) \
				   $(BONUS_OBJS:.o=.d) \
				   $(TEST_OBJS:.o=.d)
TEST_LDLIBS		= -lasm -lbsd
TEST_LDFLAGS	= -L.

# ---------------------------------------------------------------------------- #
# Targets                                                                      #
# ---------------------------------------------------------------------------- #

all: $(NAME) $(TEST_TARGET)

$(NAME): $(OBJS) Makefile
		$(info ********** BUILDING $(@) ************)
		@$(RM) $@
		@$(AR) rcs $(NAME) $(OBJS)
		@$(RANLIB) $(NAME)
		@$(READELF) -sW $(@) | sed -n '1,3p;/FUNC/p'

# `make bonus` (re)builds libasm.a containing mandatory + bonus objects, as
# required by the subject.
bonus: $(OBJS) $(BONUS_OBJS)
		$(info ********** BUILDING $(NAME) (with bonus) ************)
		@$(RM) $(NAME)
		@$(AR) rcs $(NAME) $(OBJS) $(BONUS_OBJS)
		@$(RANLIB) $(NAME)
		@$(READELF) -sW $(NAME) | sed -n '1,3p;/FUNC/p'

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.s
		@mkdir -p $(@D)
		@$(ASM_NASM) $(ASM_FLAGS) -MD $(@:.o=.d) -MP -MT $@ $< -o $@

$(OBJ_DIR)/test/%.o: $(TEST_DIR)/%.c
		@mkdir -p $(@D)
		@$(CC) $(CFLAGS) $(INCLUDE_FLAGS) -MMD -MP -MF $(@:.o=.d) -MT $@ -c $< -o $@

$(TEST_TARGET): $(TEST_OBJS) $(NAME) Makefile
		@$(CC) $(CFLAGS) $(TEST_LDFLAGS) -o $(TEST_TARGET) $(TEST_OBJS) $(TEST_LDLIBS)

test: $(TEST_TARGET)
		@./$(TEST_TARGET)

clean:
		@$(RM) -rfv $(OBJ_DIR)

fclean: clean
		@$(RM) -vf $(NAME) $(TEST_TARGET)

re: fclean
		+@$(MAKE) all --no-print-directory

.SECONDARY: $(OBJS) $(BONUS_OBJS) $(TEST_OBJS)
-include $(DEPS)
.PHONY: all bonus clean fclean re test
