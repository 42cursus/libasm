; ************************************************************************** ;
;                                                                            ;
;                                                        :::      ::::::::   ;
;   ft_memcpy.s                                        :+:      :+:    :+:   ;
;                                                    +:+ +:+         +:+     ;
;   By: abelov <abelov@student.42london.com>       +#+  +:+       +#+        ;
;                                                +#+#+#+#+#+   +#+           ;
;   Created: 2026/06/02 11:50:00 by abelov            #+#    #+#             ;
;   Updated: 2026/06/02 11:50:00 by abelov           ###   ########.fr       ;
;                                                                            ;
; ************************************************************************** ;

bits 64
default rel

%define save_pointer    qword[rbp - 8] ; QWORD PTR -8[rbp]

SECTION .rodata
SECTION .bss
SECTION .text exec nowrite align=16 ; Section containing code

global  ft_memcpy:function (ft_memcpy.end - ft_memcpy)

; void	*ft_memcpy(void *dest, const void *src, size_t n)
ft_memcpy:
	push	rbp
	mov     rbp, rsp
	sub     rsp, 16
	mov     save_pointer, rdi

	test	rsi, rsi
	sete	al
	test	rdi, rdi
	sete	cl
	or      al, cl
	je      .loop_start
	mov     save_pointer, 0
	jmp     .done

.loop_start:
	test	rdx, rdx
	je      .done

.loop_body:
	mov     rcx, rsi
	add     rsi, 1
	mov     rax, rdi
	add     rdi, 1
	movzx	ecx, byte [rcx]
	mov     byte [rax], cl

.loop_iter:
	sub     rdx, 1
	jne     .loop_body

.done:
	mov     rax, save_pointer
	leave
	ret

.end:
    nop
