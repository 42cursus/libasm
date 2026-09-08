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
SECTION .text exec nowrite align=16 ; Section containing code

global	ft_list_sort:function (ft_list_sort.end - ft_list_sort)
global	ft_list_sort.pass:object hidden (ft_list_sort.compare - ft_list_sort.pass)
global	ft_list_sort.compare:object hidden (ft_list_sort.no_swap - ft_list_sort.compare)
global	ft_list_sort.no_swap:object hidden (ft_list_sort.pass_iter - ft_list_sort.no_swap)
global	ft_list_sort.pass_iter:object hidden (ft_list_sort.epilogue - ft_list_sort.pass_iter)
global	ft_list_sort.epilogue:object hidden (ft_list_sort.done - ft_list_sort.epilogue)
global	ft_list_sort.done:object hidden (ft_list_sort.end - ft_list_sort.done)

LIST_DATA_OFFSET	equ 0
LIST_NEXT_OFFSET	equ 8

; ft_list_sort register roles
%define reg_begin_list_ptr	rbx
%define reg_cmp_fn		    r12
%define reg_current_node	r13
%define reg_swapped		    r14d

;void	ft_list_sort(t_list **begin_list, int (*cmp)(void *, void *))
ft_list_sort:
	test	rdi, rdi        ; begin_list_ptr
	je      .done
	test	rsi, rsi        ; cmp_fn
	je      .done
	cmp     qword [rdi], 0  ;
	je      .done

.prologue:
	push	rbx
	push	r12
	push	r13
	push	r14
	sub     rsp, 8
	mov     reg_begin_list_ptr, rdi
	mov     reg_cmp_fn, rsi

.pass:
	xor     reg_swapped, reg_swapped
	mov     reg_current_node, [reg_begin_list_ptr]

.compare:
	mov     rax, [reg_current_node + LIST_NEXT_OFFSET]
	test	rax, rax
	je      .pass_iter

	mov     rdi, [reg_current_node + LIST_DATA_OFFSET]
	mov     rsi, [rax + LIST_DATA_OFFSET]
	call	reg_cmp_fn
	test	eax, eax
	jle     .no_swap

	mov     rax, [reg_current_node + LIST_NEXT_OFFSET]
	mov     rcx, [reg_current_node + LIST_DATA_OFFSET]
	mov     rdx, [rax + LIST_DATA_OFFSET]
	mov     [reg_current_node + LIST_DATA_OFFSET], rdx
	mov     [rax + LIST_DATA_OFFSET], rcx
	mov     reg_swapped, 1

.no_swap:
	mov     reg_current_node, [reg_current_node + LIST_NEXT_OFFSET]
	jmp     .compare

.pass_iter:
	test	reg_swapped, reg_swapped
	jnz     .pass

.epilogue:
	add     rsp, 8
	pop     r14
	pop     r13
	pop     r12
	pop     rbx

.done:
	ret

.end:
    nop
