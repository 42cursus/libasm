set environment GLIBC_TUNABLES glibc.cpu.hwcaps=-AVX2,-AVX_Fast_Unaligned_Load,-SSE4_1,-SSSE3
set environment LD_HWCAP_MASK 0

br main

set disassembly-flavor intel

define strlen_state
	printf "reg_start_ptr (rdi): %p\n", $rdi
	x/s $rdi
	printf "reg_cursor    (rax): %p\n", $rax
	x/4bx $rax
	printf "reg_zero_mask (rdx): 0x%08x\n", $rdx
	printf "reg_scratch_dword (ecx): 0x%08x\n", $ecx
	printf "reg_marker_bit_idx / reg_byte_offset (rcx): %u\n", $rcx
end
document strlen_state
Show ft_strlen's semantic register state at the current instruction.
end

define strcpy_state
	printf "reg_return_ptr     (rax): %p\n", $rax
	printf "reg_dest_cursor    (rdi): %p\n", $rdi
	x/4bx $rdi
	printf "reg_source_cursor  (rsi): %p\n", $rsi
	x/s $rsi
	printf "reg_copied_byte    (dl): 0x%02x\n", $dl
end
document strcpy_state
Show ft_strcpy's semantic register state at the current instruction.
end

define strcmp_state
	printf "reg_first_ptr           (rdi): %p\n", $rdi
	x/s $rdi
	printf "reg_second_ptr          (rsi): %p\n", $rsi
	x/s $rsi
	printf "reg_first_byte           (al): 0x%02x\n", $al
	printf "reg_second_byte          (dl): 0x%02x\n", $dl
end
document strcmp_state
Show ft_strcmp's semantic register state at the current instruction.
end
