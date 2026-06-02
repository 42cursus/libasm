; ************************************************************************** ;
;   ft_list_size_bonus.s — TODO: implement per subject Annex                        ;
; ************************************************************************** ;

bits 64
default rel

SECTION .rodata
SECTION .bss
section .text.pad exec nowrite align=1
    nop

global  ft_list_size:function (ft_list_size.end - ft_list_size)

SECTION .text

ft_list_size:
    xor     eax, eax            ; TODO: real implementation
    ret
.end:
