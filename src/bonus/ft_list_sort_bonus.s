; ************************************************************************** ;
;   ft_list_sort_bonus.s — TODO: implement per subject Annex                        ;
; ************************************************************************** ;

bits 64
default rel

SECTION .rodata
SECTION .bss
section .text.pad exec nowrite align=1
    nop

global  ft_list_sort:function (ft_list_sort.end - ft_list_sort)

SECTION .text

ft_list_sort:
    xor     eax, eax            ; TODO: real implementation
    ret
.end:
