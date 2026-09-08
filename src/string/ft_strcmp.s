; ************************************************************************** ;
;                                                                            ;
;                                                        :::      ::::::::   ;
;   ft_strcmp.s                                        :+:      :+:    :+:   ;
;                                                    +:+ +:+         +:+     ;
;   By: abelov <abelov@student.42london.com>       +#+  +:+       +#+        ;
;                                                +#+#+#+#+#+   +#+           ;
;   Created: 2026/06/02 11:50:00 by abelov            #+#    #+#             ;
;   Updated: 2026/06/02 11:50:00 by abelov           ###   ########.fr       ;
;                                                                            ;
; ************************************************************************** ;

bits 64
default rel

SECTION .rodata
SECTION .bss

global  ft_strcmp:function (ft_strcmp.end - ft_strcmp)

global	ft_strcmp.loop:object hidden (ft_strcmp.diff - ft_strcmp.loop)
global	ft_strcmp.diff:object hidden (ft_strcmp.equal - ft_strcmp.diff)
global	ft_strcmp.equal:object hidden (ft_strcmp.end - ft_strcmp.equal)

SECTION .text exec nowrite align=16 ; Section containing code

; ft_strcmp register roles
%define reg_first_ptr	rdi
%define reg_second_ptr	rsi
%define reg_first_byte	al
%define reg_second_byte	dl
%define reg_result		eax

; int ft_strcmp(const char *s1, const char *s2);
;
; Compare two NUL-terminated strings byte-by-byte (unsigned).
; Returns: <0 if s1<s2, 0 if equal, >0 if s1>s2.
ft_strcmp:

.loop:
    mov     reg_first_byte, byte [reg_first_ptr]
    mov     reg_second_byte, byte [reg_second_ptr]
    cmp     reg_first_byte, reg_second_byte
    jne     .diff
    test    reg_first_byte, reg_first_byte
    je      .equal
    inc     reg_first_ptr
    inc     reg_second_ptr
    jmp     .loop

.diff:
    movzx   reg_result, reg_first_byte
    movzx   edx, reg_second_byte
    sub     reg_result, edx
    ret

.equal:
    xor     reg_result, reg_result
    ret

.end:
    nop
