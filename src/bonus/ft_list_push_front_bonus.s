; ************************************************************************** ;
;   ft_list_push_front_bonus.s — TODO: implement per subject Annex                        ;
; ************************************************************************** ;

bits 64
default rel

SECTION .rodata
SECTION .bss
section .text.pad exec nowrite align=1
    nop

global  ft_list_push_front:function (ft_list_push_front.end - ft_list_push_front)

SECTION .text

ft_list_push_front:
    xor     eax, eax            ; TODO: real implementation
    ret
.end:
