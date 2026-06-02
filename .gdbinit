set environment GLIBC_TUNABLES glibc.cpu.hwcaps=-AVX2,-AVX_Fast_Unaligned_Load,-SSE4_1,-SSSE3
set environment LD_HWCAP_MASK 0
br main.c:77
