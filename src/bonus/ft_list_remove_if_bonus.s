; ************************************************************************** ;
;                                                                            ;
;                                                        :::      ::::::::   ;
;   ft_list_remove_if_bonus.s                          :+:      :+:    :+:   ;
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

extern	free

global	ft_list_remove_if:function (ft_list_remove_if.end - ft_list_remove_if)
global	ft_list_remove_if.loop:object hidden (ft_list_remove_if.remove - ft_list_remove_if.loop)
global	ft_list_remove_if.remove:object hidden (ft_list_remove_if.restore - ft_list_remove_if.remove)
global	ft_list_remove_if.done:object hidden (ft_list_remove_if.end - ft_list_remove_if.done)

LIST_DATA_OFFSET	equ 0
LIST_NEXT_OFFSET	equ 8

; ft_list_remove_if register roles
%define reg_link_ptr		r12
%define reg_data_ref		r13
%define reg_cmp_fn		r14
%define reg_free_fn		r15
%define reg_node_ptr		rbx

; void ft_list_remove_if(t_list **begin_list, void *data_ref,
;                         int (*cmp)(), void (*free_fct)(void *));
ft_list_remove_if:
	test	rdi, rdi
	je	.done
	test	rdx, rdx
	je	.done
	test	rcx, rcx
	je	.done
	push	rbx
	push	r12
	push	r13
	push	r14
	push	r15
	mov	reg_link_ptr, rdi
	mov	reg_data_ref, rsi
	mov	reg_cmp_fn, rdx
	mov	reg_free_fn, rcx

.loop:
	mov	reg_node_ptr, [reg_link_ptr]
	test	reg_node_ptr, reg_node_ptr
	je	.restore
	mov	rdi, [reg_node_ptr + LIST_DATA_OFFSET]
	mov	rsi, reg_data_ref
	call	reg_cmp_fn
	test	eax, eax
	je	.remove
	lea	reg_link_ptr, [reg_node_ptr + LIST_NEXT_OFFSET]
	jmp	.loop

.remove:
	mov	rdi, [reg_node_ptr + LIST_DATA_OFFSET]
	call	reg_free_fn
	mov	rax, [reg_node_ptr + LIST_NEXT_OFFSET]
	mov	[reg_link_ptr], rax
	mov	rdi, reg_node_ptr
	call	free wrt ..plt
	jmp	.loop

.restore:
	pop	r15
	pop	r14
	pop	r13
	pop	r12
	pop	rbx

.done:
	ret

.end:
    nop
