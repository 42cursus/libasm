; ************************************************************************** ;
;                                                                            ;
;                                                        :::      ::::::::   ;
;   ft_atoi_base_bonus.s                               :+:      :+:    :+:   ;
;                                                    +:+ +:+         +:+     ;
;   By: abelov <abelov@student.42london.com>       +#+  +:+       +#+        ;
;                                                +#+#+#+#+#+   +#+           ;
;   Created: 2026/08/18 17:00:00 by abelov            #+#    #+#             ;
;   Updated: 2026/08/18 17:00:00 by abelov           ###   ########.fr       ;
;                                                                            ;
; ************************************************************************** ;

bits 64
default rel

SECTION .rodata
SECTION .bss
section .text.pad exec nowrite align=1
	nop

global	ft_atoi_base:function (ft_atoi_base.end - ft_atoi_base)
global	ft_atoi_base.validate_base:function (ft_atoi_base.validate_base_end - ft_atoi_base.validate_base)
global	ft_atoi_base.skip_whitespace:function (ft_atoi_base.skip_whitespace_end - ft_atoi_base.skip_whitespace)
global	ft_atoi_base.parse_digits:function (ft_atoi_base.parse_digits_end - ft_atoi_base.parse_digits)
global	ft_atoi_base.invalid:function (ft_atoi_base.invalid_end - ft_atoi_base.invalid)
global	ft_atoi_base.done:function (ft_atoi_base.end - ft_atoi_base.done)

BASE_MIN_LENGTH	equ 2
ASCII_TAB		equ 9
ASCII_CARRIAGE_RETURN	equ 13
ASCII_SPACE		equ 32

; ft_atoi_base register roles
%define reg_string_cursor	rdi
%define reg_base_arg		rsi
%define reg_result		eax
%define reg_character		dl
%define reg_base_length		rcx
%define reg_base_length_dword	ecx
%define reg_sign		r8d
%define reg_base_start		r9
%define reg_base_index		r10
%define reg_base_index_dword	r10d

SECTION .text

; int ft_atoi_base(char *str, char *base);
ft_atoi_base:
	test	reg_string_cursor, reg_string_cursor
	je	.invalid
	test	reg_base_arg, reg_base_arg
	je	.invalid
	mov	reg_base_start, reg_base_arg
	xor	reg_base_length, reg_base_length

.validate_base:
	mov	reg_character, [reg_base_start + reg_base_length]
	test	reg_character, reg_character
	je	.validate_base_end
	cmp	reg_character, '+'
	je	.invalid
	cmp	reg_character, '-'
	je	.invalid
	cmp	reg_character, ASCII_SPACE
	je	.invalid
	cmp	reg_character, ASCII_TAB
	jb	.duplicate_scan_start
	cmp	reg_character, ASCII_CARRIAGE_RETURN
	jbe	.invalid

.duplicate_scan_start:
	lea	reg_base_index, [reg_base_length + 1]
.duplicate_scan:
	cmp	byte [reg_base_start + reg_base_index], 0
	je	.duplicate_scan_end
	cmp	reg_character, [reg_base_start + reg_base_index]
	je	.invalid
	inc	reg_base_index
	jmp	.duplicate_scan
.duplicate_scan_end:
	inc	reg_base_length
	jmp	.validate_base
.validate_base_end:
	cmp	reg_base_length, BASE_MIN_LENGTH
	jb	.invalid
	mov	reg_sign, 1

.skip_whitespace:
	mov	reg_character, [reg_string_cursor]
	cmp	reg_character, ASCII_SPACE
	je	.advance_whitespace
	cmp	reg_character, ASCII_TAB
	jb	.skip_whitespace_end
	cmp	reg_character, ASCII_CARRIAGE_RETURN
	ja	.skip_whitespace_end
.advance_whitespace:
	inc	reg_string_cursor
	jmp	.skip_whitespace
.skip_whitespace_end:

.consume_signs:
	cmp	reg_character, '+'
	je	.advance_sign
	cmp	reg_character, '-'
	jne	.parse_digits
	neg	reg_sign
.advance_sign:
	inc	reg_string_cursor
	mov	reg_character, [reg_string_cursor]
	jmp	.consume_signs

.parse_digits:
	xor	reg_result, reg_result
.next_digit:
	mov	reg_character, [reg_string_cursor]
	test	reg_character, reg_character
	je	.apply_sign
	xor	reg_base_index, reg_base_index
.find_digit:
	cmp	reg_character, [reg_base_start + reg_base_index]
	je	.digit_found
	cmp	byte [reg_base_start + reg_base_index], 0
	je	.apply_sign
	inc	reg_base_index
	jmp	.find_digit
.digit_found:
	imul	reg_result, reg_base_length_dword
	add	reg_result, reg_base_index_dword
	inc	reg_string_cursor
	jmp	.next_digit
.parse_digits_end:

.apply_sign:
	cmp	reg_sign, 1
	je	.done
	neg	reg_result
	jmp	.done

.invalid:
	xor	reg_result, reg_result
.invalid_end:

.done:
	ret
.end:
