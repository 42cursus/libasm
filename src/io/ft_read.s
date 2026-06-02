bits 64
default rel

%assign SYS_read		0

SECTION .rodata			  ; Section containing initialized read-only data
SECTION .bss              ; Section containing uninitialized data
SECTION .text.pad exec nowrite align=1
  nop

extern __errno_location
global  ft_read:function (ft_read.end - ft_read)

SECTION .text			 ; Section containing code

; ft_read() attempts to read up to count bytes from file descriptor fd into the buffer starting at buf.
; 
; On success, the number of bytes read is returned (zero indicates end  of  file),
; and  the  file  position is advanced by this number.
;
; On  error,  -1 is returned, and errno is set appropriately.
;
; ssize_t ft_read(int fd, void *buf, size_t count)
ft_read:
	push	rbp
	mov	rbp, rsp
	push	rbx
	sub	rsp, 8		; reserve 8 bytes for stack alignment

	; read(int fd, void *buf, size_t count)
	mov rax, strict qword SYS_write ; read
	mov rdx, rdx					; count
	mov rsi, rsi					; buf
	mov rdi, rdi					; fd
	syscall

	; Linux syscalls return negative error codes in the range -1 to -4095
	; glibc considers negative syscall return values in the range [-4096 < retval < 0] to be error values

	mov	ebx, eax ; unsigned long int resultvar;
	; if ((unsigned long int)(resultvar) >= (unsigned long int)-4095L)
	cmp	ebx, -4096
	jbe	.LEAVE

.fail:

	call	__errno_location wrt ..plt
	neg	ebx
	mov	dword [rax], ebx
	mov	eax, -1

.LEAVE:
	add	rsp, 8
	pop rbx
	pop	rbp
	ret            		; all done!
.end:
