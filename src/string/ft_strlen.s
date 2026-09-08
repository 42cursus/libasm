; ************************************************************************** ;
;                                                                            ;
;                                                        :::      ::::::::   ;
;   ft_strlen.s                                        :+:      :+:    :+:   ;
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

global   ft_strlen_rep_byte:function (ft_strlen_rep_byte.end - ft_strlen_rep_byte)
global   ft_strlen.align:object hidden (ft_strlen.dword_loop - ft_strlen.align)
global   ft_strlen.dword_loop:object hidden (ft_strlen.locate_first_nul - ft_strlen.dword_loop)
global   ft_strlen.locate_first_nul:object hidden (ft_strlen.done - ft_strlen.locate_first_nul)
global   ft_strlen.done:object hidden (ft_strlen.end - ft_strlen.done)
global   ft_strlen:function (ft_strlen.end - ft_strlen)

DWORD_SIZE				equ 4
DWORD_ALIGNMENT_MASK	equ DWORD_SIZE - 1
ZERO_BYTE_UNDERFLOW_GEN	equ 0x01010101
ZERO_BYTE_HIGH_BIT_MASK	equ 0x80808080

; ft_strlen register roles
%define reg_start_ptr	    rdi
%define reg_cursor		    rax
%define reg_cursor_low_byte	al
%define reg_zero_mask_dword	edx
%define reg_zero_mask	    rdx
%define reg_marker_bit_idx	rcx
%define reg_byte_offset	    rcx
%define reg_scratch_dword	ecx

; Input: reg_zero_mask_dword = dword to inspect.
; Output: reg_zero_mask_dword = NUL-byte mask. Clobbers: reg_scratch_dword.
; Writing ecx zero-extends rcx, which is later reused for the NUL position.
%macro DETECT_NULL_DWORD 0
	lea	reg_scratch_dword, [reg_zero_mask_dword - ZERO_BYTE_UNDERFLOW_GEN]
	not	reg_zero_mask_dword
	and	reg_zero_mask_dword, reg_scratch_dword
	and	reg_zero_mask_dword, ZERO_BYTE_HIGH_BIT_MASK
%endmacro

; size_t ft_strlen(const char *src);
ft_strlen:
	mov	reg_cursor, reg_start_ptr

.align:
	test	reg_cursor_low_byte, DWORD_ALIGNMENT_MASK
	je	.dword_loop
	cmp	byte [reg_cursor], 0
	je	.done
	inc	reg_cursor
	jmp	.align

.dword_loop:
	mov	reg_zero_mask_dword, dword [reg_cursor]
	DETECT_NULL_DWORD
	test	reg_zero_mask_dword, reg_zero_mask_dword
	jnz	.locate_first_nul
	add	reg_cursor, DWORD_SIZE
	jmp	.dword_loop

.locate_first_nul:
	; The dword mask is zero-extended into rdx by DETECT_NULL_DWORD.
	; bsf maps its first marker bit (7, 15, 23, or 31) to a bit index.
	bsf	reg_marker_bit_idx, reg_zero_mask
	; Divide the bit index by eight to derive the NUL byte offset (0 through 3).
	mov	reg_byte_offset, reg_marker_bit_idx
	shr	reg_byte_offset, 3
	add	reg_cursor, reg_byte_offset

.done:
	sub	reg_cursor, reg_start_ptr
	ret
.end:
    nop

; size_t ft_strlen_rep_byte(const char *src);
ft_strlen_rep_byte:
	push  rbx				; save any registers that we will trash in here

	; save arguments
	mov   rbx, rdi			; rbx = rdi == const char *src

	; calculating the length
	xor   al, al			; the byte that the scan will compare to is zero
	cld						; left to right or auto-increment mode
	xor   ecx,ecx			; rcx = 0 (same as [sub  ecx,ecx])
	dec   rcx				; rcx = -1 (0xFFFFFFFFFFFFFFFF)
repne scasb					; while [rdi] != al, keep scanning
	sub   rdi, rbx			; length = dist2 - dist1
	sub   rdi, 0x1			; fix that into "string length" (-1 for '\0')
	mov   rax, rdi			; rax now holds our length

	; restore saved registers
	pop   rbx
	ret                       ; all done!
.end:
    nop
