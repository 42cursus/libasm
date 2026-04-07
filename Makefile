# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: abelov <abelov@student.42london.com>       +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/04/07 03:17:12 by abelov            #+#    #+#              #
#    Updated: 2026/04/07 03:17:12 by abelov           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME			= libasm.a
TEST_TARGET		= libasm_test

BUILD_DIR		= build
INC_DIR			= ./include

CC				:= cc
CC				:= gcc

AR				= ar
RANLIB			= ranlib
ASM_NASM		= nasm

OBJCOPY			= objcopy
OBJDUMP			= objdump
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

TEST_FILES		= main.c
SRC_FILES		= ft_strlen.s

SRC_DIR			= src
TEST_DIR		= tests
OBJ_DIR			= $(BUILD_DIR)/objs

SRCS			= $(SRC_FILES:%.s=$(SRC_DIR)/%.s)
OBJS			= $(SRCS:$(SRC_DIR)/%.s=$(OBJ_DIR)/%.o)

TEST_SRCS		= $(TEST_FILES:%.c=$(TEST_DIR)/%.c)
TEST_OBJS		= $(TEST_SRCS:$(TEST_DIR)/%.c=$(OBJ_DIR)/test/%.o)
TEST_LDLIBS 	= -lasm
TEST_LDFLAGS	= -L.

all: $(NAME) $(TEST_TARGET)

$(NAME): $(OBJS)
		$(info ********** BUILDING $(@) ************)
		@echo
		@$(AR) rcsP $(NAME) $(OBJS)
		@$(RANLIB) $(NAME)
		@$(READELF) -sW $(@)
		@echo

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.s
		@if [ ! -d $(@D) ]; then mkdir -p $(@D); fi
		@$(ASM_NASM) $(ASM_FLAGS) $< -o $@

$(OBJ_DIR)/test/%.o: $(TEST_DIR)/%.c
		@if [ ! -d $(@D) ]; then mkdir -p $(@D); fi
		@$(CC) $(CFLAGS) $(INCLUDE_FLAGS) -c $< -o $@

$(TEST_TARGET) : $(TEST_OBJS) $(LIB_NAME)
		@$(CC) $(CFLAGS) $(TEST_LDFLAGS) -o $(TEST_TARGET) $(TEST_OBJS) $(TEST_LDLIBS)

bonus:

## clean
clean:
		@echo Target: $@
		@$(RM) -rfv $(OBJ_DIR)
		@echo

## fclean
fclean: clean
		@echo Target: $@
		@$(RM) -vf $(NAME) $(TEST_TARGET)
		@echo

## re
re: fclean
		+@$(MAKE) all --no-print-directory

.SECONDARY: $(OBJS)
.PHONY: all clean fclean re
