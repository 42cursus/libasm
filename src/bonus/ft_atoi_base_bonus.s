; ************************************************************************** ;
;   ft_atoi_base_bonus.s — TODO: implement per subject Annex                        ;
; ************************************************************************** ;

bits 64
default rel

SECTION .rodata
SECTION .bss
section .text.pad exec nowrite align=1
    nop

global  ft_atoi_base:function (ft_atoi_base.end - ft_atoi_base)

SECTION .text

ft_atoi_base:
    xor     eax, eax            ; TODO: real implementation
    ret
.end:
