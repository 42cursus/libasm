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

section .text.pad exec nowrite align=1
    nop

global  ft_strcmp:function (ft_strcmp.end - ft_strcmp)

SECTION .text

; int ft_strcmp(const char *s1, const char *s2);
;
; Compare two NUL-terminated strings byte-by-byte (unsigned).
; Returns: <0 if s1<s2, 0 if equal, >0 if s1>s2.
ft_strcmp:
    xor     rcx, rcx                ; index = 0

.loop:
    movzx   eax, byte [rdi + rcx]
    movzx   edx, byte [rsi + rcx]
    cmp     al, dl
    jne     .diff
    test    al, al                  ; both bytes equal; end of string?
    je      .equal
    inc     rcx
    jmp     .loop

.diff:
    sub     eax, edx
    ret

.equal:
    xor     eax, eax
    ret

.end:
