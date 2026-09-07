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

; -----------------------------
; DWARF constants
; -----------------------------
%define DW_TAG_compile_unit        0x11
%define DW_TAG_subprogram          0x2e
%define DW_TAG_formal_parameter    0x05
%define DW_TAG_base_type           0x24
%define DW_TAG_pointer_type        0x0f
%define DW_TAG_structure_type      0x13

%define DW_CHILDREN_no             0x00
%define DW_CHILDREN_yes            0x01

%define DW_AT_producer             0x25
%define DW_AT_language             0x13
%define DW_AT_name                 0x03
%define DW_AT_comp_dir             0x1b
%define DW_AT_low_pc               0x11
%define DW_AT_high_pc              0x12
%define DW_AT_stmt_list            0x10
%define DW_AT_type                 0x49
%define DW_AT_external             0x3f
%define DW_AT_declaration          0x3c
%define DW_AT_location             0x02
%define DW_AT_encoding             0x3e
%define DW_AT_byte_size            0x0b

%define DW_FORM_addr               0x01
%define DW_FORM_data1              0x0b
%define DW_FORM_data2              0x05
%define DW_FORM_string             0x08
%define DW_FORM_strp               0x0e
%define DW_FORM_flag_present       0x19
%define DW_FORM_exprloc            0x18
%define DW_FORM_ref4               0x13
%define DW_FORM_sec_offset         0x17

%define DW_LANG_C99                0x000c

%define DW_ATE_signed              0x05
%define DW_ATE_signed_char         0x06
%define DW_ATE_unsigned            0x07

%define DW_LANG_Mips_Assembler	0x8001

%define DW_OP_reg5                 0x55

; -----------------------------
; Helpers
; -----------------------------
%macro uleb128 1
%assign __v %1
%rep 10
  %if __v < 0x80
    db __v
    %exitrep
  %else
    db (__v & 0x7f) | 0x80
    %assign __v __v >> 7
  %endif
%endrep
%endmacro

%macro exprloc_regop 1
  ; DW_FORM_exprloc = uleb128 length + bytes
  uleb128 1
  db %1
%endmacro

SECTION .rodata
SECTION .bss
SECTION .text exec nowrite align=16 ; Section containing code

global	ft_list_size:function (ft_list_size.end - ft_list_size)
global	ft_list_size.loop:object hidden (ft_list_size.done - ft_list_size.loop)
global	ft_list_size.done:object hidden (ft_list_size.end - ft_list_size.done)

LIST_NEXT_OFFSET	equ 8

; ft_list_size register roles
%define reg_node_ptr	rdi
%define reg_count		eax

; unsigned int ft_list_size(t_list *begin_list);
ft_list_size:
	xor	reg_count, reg_count

.loop:
	test	reg_node_ptr, reg_node_ptr
	je	.done
	inc	reg_count
	mov	reg_node_ptr, [reg_node_ptr + LIST_NEXT_OFFSET]
	jmp	.loop

.done:
	ret

.end:
	nop

; NASM emits line information but only an anonymous DW_TAG_subprogram.
; This companion CU gives GDB a named function DIE for `info functions`.
[warning -reloc-abs-dword]
[warning -reloc-abs-qword]

SECTION .debug_line progbits noalloc nowrite align=1

ft_list_size_debug_line:

SECTION .debug_abbrev progbits noalloc nowrite align=1

ft_list_size_debug_abbrev:
	; Abbreviation 1: compilation unit with children.
	uleb128	1
	uleb128	DW_TAG_compile_unit
	db	DW_CHILDREN_yes
	uleb128	DW_AT_name
	uleb128	DW_FORM_string
	uleb128	DW_AT_language
	uleb128	DW_FORM_data2
	uleb128	DW_AT_stmt_list
	uleb128	DW_FORM_sec_offset
	db	0, 0

	; Abbreviation 2: base type.
	uleb128	2
	uleb128	DW_TAG_base_type
	db	DW_CHILDREN_no
	uleb128	DW_AT_name
	uleb128	DW_FORM_string
	uleb128	DW_AT_encoding
	uleb128	DW_FORM_data1
	uleb128	DW_AT_byte_size
	uleb128	DW_FORM_data1
	db	0, 0

	; Abbreviation 3: structure type.
	uleb128	3
	uleb128	DW_TAG_structure_type
	db	DW_CHILDREN_no
	uleb128	DW_AT_name
	uleb128	DW_FORM_string
	uleb128	DW_AT_declaration
	uleb128	DW_FORM_flag_present
	db	0, 0

	; Abbreviation 4: pointer type.
	uleb128	4
	uleb128	DW_TAG_pointer_type
	db	DW_CHILDREN_no
	uleb128	DW_AT_type
	uleb128	DW_FORM_ref4
	uleb128	DW_AT_byte_size
	uleb128	DW_FORM_data1
	db	0, 0

	; Abbreviation 5: externally visible function.
	uleb128	5
	uleb128	DW_TAG_subprogram
	db	DW_CHILDREN_yes
	uleb128	DW_AT_name
	uleb128	DW_FORM_string
	uleb128	DW_AT_external
	uleb128	DW_FORM_flag_present
	uleb128	DW_AT_low_pc
	uleb128	DW_FORM_addr
	uleb128	DW_AT_high_pc
	uleb128	DW_FORM_addr
	uleb128	DW_AT_type
	uleb128	DW_FORM_ref4
	db	0, 0

	; Abbreviation 6: register-resident formal parameter.
	uleb128	6
	uleb128	DW_TAG_formal_parameter
	db	DW_CHILDREN_no
	uleb128	DW_AT_name
	uleb128	DW_FORM_string
	uleb128	DW_AT_type
	uleb128	DW_FORM_ref4
	db	0, 0

	db	0				; end abbreviation table

SECTION .debug_info progbits noalloc nowrite align=1

ft_list_size_debug_cu:
	dd	ft_list_size_debug_cu_end - ft_list_size_debug_cu_header_end
ft_list_size_debug_cu_header_end:
	dw	4				; DWARF version
	dd	ft_list_size_debug_abbrev
	db	8				; address size

	uleb128	1			; compilation unit
	db	"ft_list_size_bonus.s", 0
	dw	DW_LANG_Mips_Assembler
	dd	ft_list_size_debug_line

ft_list_size_debug_uint:
	uleb128	2			; unsigned int
	db	"unsigned int", 0
	db	DW_ATE_unsigned
	db	4

ft_list_size_debug_struct:
	uleb128	3			; incomplete t_list declaration
	db	"t_list", 0

ft_list_size_debug_list_ptr:
	uleb128	4			; t_list *
	dd	ft_list_size_debug_struct - ft_list_size_debug_cu
	db	8

ft_list_size_debug_subprogram:
	uleb128	5			; named subprogram
	db	"ft_list_size", 0
	dq	ft_list_size
	dq	ft_list_size.end
	dd	ft_list_size_debug_uint - ft_list_size_debug_cu

	uleb128	6			; begin_list
	db	"begin_list", 0
	dd	ft_list_size_debug_list_ptr - ft_list_size_debug_cu

	db	0				; end subprogram children

	db	0				; end compilation-unit children
ft_list_size_debug_cu_end:

[warning +reloc-abs-dword]
[warning +reloc-abs-qword]
