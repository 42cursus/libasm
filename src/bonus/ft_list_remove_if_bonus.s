; ************************************************************************** ;
;   ft_list_remove_if_bonus.s — TODO: implement per subject Annex                        ;
; ************************************************************************** ;

bits 64
default rel

SECTION .rodata
SECTION .bss
section .text.pad exec nowrite align=1
    nop

global  ft_list_remove_if:function (ft_list_remove_if.end - ft_list_remove_if)

SECTION .text

ft_list_remove_if:
    xor     eax, eax            ; TODO: real implementation
    ret
.end:
