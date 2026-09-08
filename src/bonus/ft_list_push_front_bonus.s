; ************************************************************************** ;
;                                                                            ;
;                                                        :::      ::::::::   ;
;   ft_list_push_front_bonus.s                         :+:      :+:    :+:   ;
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
SECTION .text exec nowrite align=16 ; Section containing code

extern	malloc

global	ft_list_push_front:function (ft_list_push_front.end - ft_list_push_front)
global	ft_list_push_front.restore:object hidden (ft_list_push_front.done - ft_list_push_front.restore)
global	ft_list_push_front.done:object hidden (ft_list_push_front.end - ft_list_push_front.done)

LIST_DATA_OFFSET	equ 0
LIST_NEXT_OFFSET	equ 8
LIST_NODE_SIZE		equ 16

; ft_list_push_front register roles
%define reg_begin_list_ptr	rbx
%define reg_data_ptr		r12
%define reg_new_node_ptr	rax

; void ft_list_push_front(t_list **begin_list, void *data);
ft_list_push_front:
	test	rdi, rdi
	je      .done
	push	rbx
	push	r12
	sub     rsp, 8
	mov     reg_begin_list_ptr, rdi
	mov     reg_data_ptr, rsi

.allocate:
	mov     rdi, LIST_NODE_SIZE
	call	malloc wrt ..plt

.check_alloc:
	test	reg_new_node_ptr, reg_new_node_ptr
	je      .restore
	mov     [reg_new_node_ptr + LIST_DATA_OFFSET], reg_data_ptr
	mov     rdx, [reg_begin_list_ptr]
	mov     [reg_new_node_ptr + LIST_NEXT_OFFSET], rdx
	mov     [reg_begin_list_ptr], reg_new_node_ptr

.restore:
	add     rsp, 8
	pop     r12
	pop     rbx

.done:
	ret

.end:
    nop
