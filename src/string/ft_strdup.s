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

section .text.pad exec nowrite align=1
    nop


SECTION .text			  ; Section containing code

extern	ft_strlen
extern	ft_strcpy
extern	malloc
extern	__errno_location

global   ft_strdup:function (ft_strdup.end - ft_strdup)
global   ft_strdup.check_alloc:function (ft_strdup.check_alloc_end - ft_strdup.check_alloc)
global   ft_strdup.check_alloc_body:function (ft_strdup.check_alloc_body_end - ft_strdup.check_alloc_body)
global   ft_strdup.malloc_ok:function (ft_strdup.malloc_ok_end - ft_strdup.malloc_ok)
global   ft_strdup.done:function (ft_strdup.end - ft_strdup.done)

ERRNO_ENOMEM	equ 12

; ft_strdup register roles
%define reg_source_ptr		r12
%define reg_duplicate_ptr	rbx
%define reg_errno_ptr		rax

ft_strdup:
	push	rbp
	mov	rbp, rsp
	push	r12
	push	rbx
	mov	reg_source_ptr, rdi

	call	ft_strlen wrt ..plt
	lea	rdi, 1[rax]

	call	malloc wrt ..plt
	mov	reg_duplicate_ptr, rax

.check_alloc:
	test	reg_duplicate_ptr, reg_duplicate_ptr
	jne	.malloc_ok
.check_alloc_end:

.check_alloc_body:
	call	__errno_location wrt ..plt
	mov	DWORD [reg_errno_ptr], ERRNO_ENOMEM
	jmp	.done
.check_alloc_body_end:

.malloc_ok:
	mov	rsi, reg_source_ptr
	mov	rdi, reg_duplicate_ptr
	call	ft_strcpy wrt ..plt
	mov	reg_duplicate_ptr, rax
.malloc_ok_end:

.done:
	mov	rax, reg_duplicate_ptr
	pop	rbx
	pop	r12
	pop	rbp
	ret
.end:
