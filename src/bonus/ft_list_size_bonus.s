; ************************************************************************** ;
;                                                                            ;
;                                                        :::      ::::::::   ;
;   ft_list_size_bonus.s                               :+:      :+:    :+:   ;
;                                                    +:+ +:+         +:+     ;
;   By: abelov <abelov@student.42london.com>       +#+  +:+       +#+        ;
;                                                +#+#+#+#+#+   +#+           ;
;   Created: 2026/08/18 16:35:00 by abelov            #+#    #+#             ;
;   Updated: 2026/08/18 16:35:00 by abelov           ###   ########.fr       ;
;                                                                            ;
; ************************************************************************** ;

bits 64
default rel

SECTION .rodata
SECTION .bss
section .text.pad exec nowrite align=1
	nop

global	ft_list_size:function (ft_list_size.end - ft_list_size)
global	ft_list_size.loop:function (ft_list_size.loop_end - ft_list_size.loop)
global	ft_list_size.done:function (ft_list_size.end - ft_list_size.done)

LIST_NEXT_OFFSET	equ 8

; ft_list_size register roles
%define reg_node_ptr		rdi
%define reg_count		eax

SECTION .text

; unsigned int ft_list_size(t_list *begin_list);
ft_list_size:
	xor	reg_count, reg_count

.loop:
	test	reg_node_ptr, reg_node_ptr
	je	.done
	inc	reg_count
	mov	reg_node_ptr, [reg_node_ptr + LIST_NEXT_OFFSET]
	jmp	.loop
.loop_end:

.done:
	ret
.end:
