; ************************************************************************** ;
;                                                                            ;
;                                                        :::      ::::::::   ;
;   ft_list_sort_bonus.s                               :+:      :+:    :+:   ;
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

global	ft_list_sort:function (ft_list_sort.end - ft_list_sort)
global	ft_list_sort.pass:function (ft_list_sort.pass_end - ft_list_sort.pass)
global	ft_list_sort.compare:function (ft_list_sort.compare_end - ft_list_sort.compare)
global	ft_list_sort.done:function (ft_list_sort.end - ft_list_sort.done)

LIST_DATA_OFFSET	equ 0
LIST_NEXT_OFFSET	equ 8

; ft_list_sort register roles
%define reg_begin_list_ptr	rbx
%define reg_cmp_fn		r12
%define reg_current_node	r13
%define reg_swapped		r14d

SECTION .text

; void ft_list_sort(t_list **begin_list, int (*cmp)());
ft_list_sort:
	test	rdi, rdi
	je	.done
	test	rsi, rsi
	je	.done
	cmp	qword [rdi], 0
	je	.done
	push	rbx
	push	r12
	push	r13
	push	r14
	sub	rsp, 8
	mov	reg_begin_list_ptr, rdi
	mov	reg_cmp_fn, rsi

.pass:
	xor	reg_swapped, reg_swapped
	mov	reg_current_node, [reg_begin_list_ptr]

.compare:
	mov	rax, [reg_current_node + LIST_NEXT_OFFSET]
	test	rax, rax
	je	.pass_end
	mov	rdi, [reg_current_node + LIST_DATA_OFFSET]
	mov	rsi, [rax + LIST_DATA_OFFSET]
	call	reg_cmp_fn
	test	eax, eax
	jle	.no_swap
	mov	rax, [reg_current_node + LIST_NEXT_OFFSET]
	mov	rcx, [reg_current_node + LIST_DATA_OFFSET]
	mov	rdx, [rax + LIST_DATA_OFFSET]
	mov	[reg_current_node + LIST_DATA_OFFSET], rdx
	mov	[rax + LIST_DATA_OFFSET], rcx
	mov	reg_swapped, 1

.no_swap:
	mov	reg_current_node, [reg_current_node + LIST_NEXT_OFFSET]
	jmp	.compare
.compare_end:

.pass_end:
	test	reg_swapped, reg_swapped
	jnz	.pass
	add	rsp, 8
	pop	r14
	pop	r13
	pop	r12
	pop	rbx
.done:
	ret
.end:
