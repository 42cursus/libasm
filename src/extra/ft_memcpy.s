ft_memcpy:
	mov	rax, rdi
	cmp	rdx, 8
	jnb	.L2
	test	dl, 4
	je	.L4
	mov	ecx, dword [rsi]
	mov	dword [rdi], ecx
	mov	ecx, dword -4[rsi+rdx]
	mov	dword -4[rdi+rdx], ecx
	ret
.L4:
	test	rdx, rdx
	je	.L3
	mov	cl, byte [rsi]
	mov	byte [rdi], cl
	test	dl, 2
	je	.L3
	mov	cx, word -2[rsi+rdx]
	mov	word -2[rdi+rdx], cx
	ret
.L2:
	mov	rcx, qword -8[rsi+rdx]
	mov	qword -8[rdi+rdx], rcx
	dec	rdx
	cmp	rdx, 8
	jb	.L3
	and	rdx, -8
	xor	ecx, ecx
.L6:
	mov	rdi, qword [rsi+rcx]
	mov	qword [rax+rcx], rdi
	add	rcx, 8
	cmp	rcx, rdx
	jb	.L6
.L3:
	ret