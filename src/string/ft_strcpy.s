; ************************************************************************** ;
;                                                                            ;
;                                                        :::      ::::::::   ;
;   ft_strcpy.s                                        :+:      :+:    :+:   ;
;                                                    +:+ +:+         +:+     ;
;   By: abelov <abelov@student.42london.com>       +#+  +:+       +#+        ;
;                                                +#+#+#+#+#+   +#+           ;
;   Created: 2026/06/02 11:50:00 by abelov            #+#    #+#             ;
;   Updated: 2026/06/02 11:50:00 by abelov           ###   ########.fr       ;
;                                                                            ;
; ************************************************************************** ;

bits 64
default rel

SECTION .rodata			  ; Section containing initialized read-only data
SECTION .bss              ; Section containing uninitialized data

section .text.pad exec nowrite align=1
    nop

global   ft_strcpy:function (ft_strcpy.end - ft_strcpy)
global   ft_strcpy.copy_loop:function (ft_strcpy.copy_loop_end - ft_strcpy.copy_loop)
global   ft_strcpy.done:function (ft_strcpy.end - ft_strcpy.done)

SECTION .text			  ; Section containing code

; ft_strcpy register roles
%define reg_return_ptr		rax
%define reg_dest_cursor     rdi
%define reg_source_cursor	rsi
%define reg_copied_byte     dl

ft_strcpy:
	mov	reg_return_ptr, reg_dest_cursor

.copy_loop:
	mov	reg_copied_byte, byte [reg_source_cursor]
	mov	byte [reg_dest_cursor], reg_copied_byte
	test	reg_copied_byte, reg_copied_byte
	je	.done
	inc	reg_source_cursor
	inc	reg_dest_cursor
	jmp	.copy_loop
.copy_loop_end:

.done:
	ret
.end:
