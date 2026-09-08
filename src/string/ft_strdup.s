; ************************************************************************** ;
;                                                                            ;
;                                                        :::      ::::::::   ;
;   ft_strdup.s                                        :+:      :+:    :+:   ;
;                                                    +:+ +:+         +:+     ;
;   By: abelov <abelov@student.42london.com>       +#+  +:+       +#+        ;
;                                                +#+#+#+#+#+   +#+           ;
;   Created: 2026/06/02 11:50:00 by abelov            #+#    #+#             ;
;   Updated: 2026/06/02 11:50:00 by abelov           ###   ########.fr       ;
;                                                                            ;
; ************************************************************************** ;

bits 64
default rel

SECTION .text exec nowrite align=16 ; Section containing code

extern	ft_strlen
extern	ft_strcpy
extern	malloc
extern	__errno_location

global   ft_strdup:function (ft_strdup.end - ft_strdup)
global   ft_strdup.check_alloc:object hidden (ft_strdup.check_alloc_body - ft_strdup.check_alloc)
global   ft_strdup.check_alloc_body:object hidden (ft_strdup.done - ft_strdup.check_alloc_body)
global   ft_strdup.done:object hidden (ft_strdup.end - ft_strdup.done)

ERRNO_ENOMEM	equ 12
NULL			equ 0

; ft_strdup register roles
%define reg_source_ptr		r12
%define reg_duplicate_ptr	rax
%define reg_errno_ptr		rax

ft_strdup:
	push	r12
	mov     reg_source_ptr, rdi
	call	ft_strlen wrt ..plt
	lea     rdi, 1[rax]
	call	malloc wrt ..plt

.check_alloc:
	test	reg_duplicate_ptr, reg_duplicate_ptr
	je	.check_alloc_body
	mov	rsi, reg_source_ptr
	mov	rdi, reg_duplicate_ptr
	call	ft_strcpy wrt ..plt
	jmp	.done

.check_alloc_body:
	call	__errno_location wrt ..plt
	mov	dword [reg_errno_ptr], ERRNO_ENOMEM
	mov	reg_duplicate_ptr, NULL

.done:
	pop	r12
	ret

.end:
    nop
