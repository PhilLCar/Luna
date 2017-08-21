	.file	"gc.c"
	.comm	_stack_base,8,8
	.comm	_mem_size,8,8
	.comm	_mem_max,8,8
	.comm	copy,8,8
	.globl	heartbreaker
	.data
	.align 8
	.type	heartbreaker, @object
	.size	heartbreaker, 8
heartbreaker:
	.quad	-2305843009213693952
	.text
	.globl	copydata
	.type	copydata, @function
copydata:
.LFB5:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$72, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -72(%rbp)
	movq	-72(%rbp), %rax
	andl	$7, %eax
	movl	%eax, -48(%rbp)
	movq	-72(%rbp), %rax
	sarq	$3, %rax
	movq	%rax, -40(%rbp)
	movq	-40(%rbp), %rax
	movq	(%rax), %rdx
	movq	heartbreaker(%rip), %rax
	andq	%rdx, %rax
	testq	%rax, %rax
	je	.L2
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	leaq	0(,%rax,8), %rdx
	movl	-48(%rbp), %eax
	cltq
	orq	%rdx, %rax
	jmp	.L1
.L2:
	cmpl	$7, -48(%rbp)
	ja	.L4
	movl	-48(%rbp), %eax
	leaq	0(,%rax,4), %rdx
	leaq	.L6(%rip), %rax
	movl	(%rdx,%rax), %eax
	movslq	%eax, %rdx
	leaq	.L6(%rip), %rax
	addq	%rdx, %rax
	jmp	*%rax
	.section	.rodata
	.align 4
	.align 4
.L6:
	.long	.L5-.L6
	.long	.L7-.L6
	.long	.L8-.L6
	.long	.L9-.L6
	.long	.L10-.L6
	.long	.L11-.L6
	.long	.L12-.L6
	.long	.L13-.L6
	.text
.L5:
	movq	-72(%rbp), %rax
	jmp	.L1
.L7:
	movq	-72(%rbp), %rax
	jmp	.L1
.L8:
	movq	copy(%rip), %rax
	movq	-40(%rbp), %rdx
	movq	(%rdx), %rdx
	movq	%rdx, (%rax)
	movq	heartbreaker(%rip), %rcx
	movq	copy(%rip), %rax
	movq	%rax, %rsi
	movq	-40(%rbp), %rax
	leaq	8(%rax), %rdx
	movq	%rdx, -40(%rbp)
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	%rdx, (%rax)
	movq	copy(%rip), %rax
	leaq	8(%rax), %rdx
	movq	%rdx, copy(%rip)
	movq	%rax, -32(%rbp)
.L16:
	movq	-72(%rbp), %rdx
	movq	copy(%rip), %rax
	movzbl	(%rdx), %edx
	movb	%dl, (%rax)
	movq	copy(%rip), %rax
	addq	$1, %rax
	movq	%rax, copy(%rip)
	cmpq	$0, -40(%rbp)
	je	.L28
	addq	$1, -40(%rbp)
	jmp	.L16
.L28:
	nop
	movq	-32(%rbp), %rax
	salq	$3, %rax
	orq	$2, %rax
	jmp	.L1
.L9:
	movq	copy(%rip), %rax
	movq	-40(%rbp), %rdx
	movq	(%rdx), %rdx
	movq	%rdx, (%rax)
	movq	heartbreaker(%rip), %rcx
	movq	copy(%rip), %rax
	movq	%rax, %rsi
	movq	-40(%rbp), %rax
	leaq	8(%rax), %rdx
	movq	%rdx, -40(%rbp)
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	%rdx, (%rax)
	movq	copy(%rip), %rax
	movq	%rax, -32(%rbp)
	movq	copy(%rip), %rax
	addq	$24, %rax
	movq	%rax, copy(%rip)
	movq	-32(%rbp), %rax
	leaq	8(%rax), %rcx
	movq	-40(%rbp), %rax
	leaq	8(%rax), %rdx
	movq	%rdx, -40(%rbp)
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	copyll
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	cmpq	$17, %rax
	je	.L17
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -24(%rbp)
	movq	copy(%rip), %rdx
	movq	-32(%rbp), %rax
	addq	$16, %rax
	movq	%rdx, (%rax)
	movl	$-1, -56(%rbp)
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	sarq	$3, %rax
	movl	%eax, -44(%rbp)
	movq	-24(%rbp), %rdx
	leaq	8(%rdx), %rax
	movq	%rax, -24(%rbp)
	movq	copy(%rip), %rax
	leaq	8(%rax), %rcx
	movq	%rcx, copy(%rip)
	movq	(%rdx), %rdx
	movq	%rdx, (%rax)
	movq	-24(%rbp), %rdx
	leaq	8(%rdx), %rax
	movq	%rax, -24(%rbp)
	movq	copy(%rip), %rax
	leaq	8(%rax), %rcx
	movq	%rcx, copy(%rip)
	movq	(%rdx), %rdx
	movq	%rdx, (%rax)
	movl	$0, -60(%rbp)
	jmp	.L18
.L21:
	movl	-60(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	movq	-40(%rbp), %rax
	addq	%rdx, %rax
	movq	copy(%rip), %rdx
	movl	-60(%rbp), %ecx
	movslq	%ecx, %rcx
	salq	$3, %rcx
	addq	%rcx, %rdx
	movq	(%rax), %rax
	movq	%rax, (%rdx)
	movq	copy(%rip), %rax
	movl	-60(%rbp), %edx
	movslq	%edx, %rdx
	salq	$3, %rdx
	addq	%rdx, %rax
	movq	(%rax), %rax
	cmpq	$17, %rax
	je	.L19
	cmpl	$0, -56(%rbp)
	jns	.L20
	movl	-60(%rbp), %eax
	movl	%eax, -56(%rbp)
.L20:
	movl	-60(%rbp), %eax
	movl	%eax, -52(%rbp)
.L19:
	addl	$1, -60(%rbp)
.L18:
	movl	-60(%rbp), %eax
	cmpl	-44(%rbp), %eax
	jl	.L21
	movq	copy(%rip), %rax
	movl	-44(%rbp), %edx
	movslq	%edx, %rdx
	salq	$3, %rdx
	addq	%rdx, %rax
	movq	%rax, copy(%rip)
	jmp	.L22
.L17:
	movq	-32(%rbp), %rax
	addq	$16, %rax
	movq	$17, (%rax)
.L22:
	movq	-32(%rbp), %rax
	salq	$3, %rax
	orq	$3, %rax
	jmp	.L1
.L10:
	movq	-72(%rbp), %rax
	jmp	.L1
.L11:
	movq	-40(%rbp), %rax
	movq	%rax, -24(%rbp)
	movq	copy(%rip), %rax
	movq	%rax, -32(%rbp)
	jmp	.L23
.L24:
	movq	-40(%rbp), %rax
	leaq	8(%rax), %rdx
	movq	%rdx, -40(%rbp)
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	copydata
.L23:
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	cmpq	$33, %rax
	jne	.L24
	movq	-24(%rbp), %rax
	movq	%rax, -40(%rbp)
	jmp	.L25
.L26:
	movq	-40(%rbp), %rax
	leaq	8(%rax), %rdx
	movq	%rdx, -40(%rbp)
	movq	(%rax), %rax
	movq	copy(%rip), %rbx
	leaq	8(%rbx), %rdx
	movq	%rdx, copy(%rip)
	movq	%rax, %rdi
	call	copydata
	movq	%rax, (%rbx)
.L25:
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	cmpq	$33, %rax
	jne	.L26
	movq	heartbreaker(%rip), %rax
	movq	copy(%rip), %rdx
	orq	%rax, %rdx
	movq	-24(%rbp), %rax
	movq	%rdx, (%rax)
	movq	-32(%rbp), %rax
	salq	$3, %rax
	orq	$5, %rax
	jmp	.L1
.L12:
	movq	copy(%rip), %rax
	movq	-40(%rbp), %rdx
	movq	(%rdx), %rdx
	movq	%rdx, (%rax)
	movq	heartbreaker(%rip), %rcx
	movq	copy(%rip), %rax
	movq	%rax, %rsi
	movq	-40(%rbp), %rax
	leaq	8(%rax), %rdx
	movq	%rdx, -40(%rbp)
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	%rdx, (%rax)
	movq	copy(%rip), %rax
	leaq	8(%rax), %rdx
	movq	%rdx, copy(%rip)
	salq	$3, %rax
	orq	$6, %rax
	jmp	.L1
.L13:
	movq	copy(%rip), %rax
	movq	-40(%rbp), %rdx
	movq	(%rdx), %rdx
	movq	%rdx, (%rax)
	movq	heartbreaker(%rip), %rcx
	movq	copy(%rip), %rax
	movq	%rax, %rsi
	movq	-40(%rbp), %rax
	leaq	8(%rax), %rdx
	movq	%rdx, -40(%rbp)
	orq	%rsi, %rcx
	movq	%rcx, %rdx
	movq	%rdx, (%rax)
	movq	copy(%rip), %rax
	movq	%rax, -32(%rbp)
	movq	copy(%rip), %rax
	addq	$16, %rax
	movq	%rax, copy(%rip)
	movq	-32(%rbp), %rax
	leaq	8(%rax), %rdx
	movq	-40(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	copyll
	movq	-32(%rbp), %rax
	salq	$3, %rax
	orq	$7, %rax
	jmp	.L1
.L4:
.L1:
	addq	$72, %rsp
	popq	%rbx
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE5:
	.size	copydata, .-copydata
	.globl	copyll
	.type	copyll, @function
copyll:
.LFB6:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	jmp	.L30
.L31:
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	copydata
	movq	%rax, -16(%rbp)
	movq	-24(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	copydata
	movq	%rax, -8(%rbp)
	movq	copy(%rip), %rax
	movq	-16(%rbp), %rdx
	movq	%rdx, (%rax)
	movq	copy(%rip), %rax
	leaq	8(%rax), %rdx
	movq	-8(%rbp), %rax
	movq	%rax, (%rdx)
	movq	copy(%rip), %rax
	movq	%rax, %rdx
	movq	-32(%rbp), %rax
	movq	%rdx, (%rax)
	movq	copy(%rip), %rax
	addq	$16, %rax
	movq	%rax, -32(%rbp)
	movq	copy(%rip), %rax
	addq	$24, %rax
	movq	%rax, copy(%rip)
	addq	$16, -24(%rbp)
.L30:
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	cmpq	$17, %rax
	jne	.L31
	movq	-32(%rbp), %rax
	movq	$17, (%rax)
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	copyll, .-copyll
	.globl	place_roots
	.type	place_roots, @function
place_roots:
.LFB7:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	place_roots, .-place_roots
	.section	.rodata
	.align 8
.LC0:
	.string	"Memory allocation failed (Process aborted)\n"
.LC1:
	.string	"\303\211tape 1: %p\n"
.LC2:
	.string	"\303\211tape 2"
.LC3:
	.string	"\303\211tape 3"
.LC4:
	.string	"\303\211tape 4"
.LC5:
	.string	"\303\211tape 5"
	.align 8
.LC6:
	.string	"Memory reallocation failed (Process aborted)\n"
.LC7:
	.string	"\303\211tape 6: %d\n"
	.text
	.globl	_gc
	.type	_gc, @function
_gc:
.LFB8:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	%rdx, -56(%rbp)
	movq	_mem_size(%rip), %rax
	movl	$0, %r9d
	movl	$-1, %r8d
	movl	$34, %ecx
	movl	$7, %edx
	movq	%rax, %rsi
	movl	$0, %edi
	call	mmap@PLT
	movq	%rax, copy(%rip)
	movq	copy(%rip), %rax
	movq	%rax, -16(%rbp)
	movq	copy(%rip), %rax
	cmpq	$-1, %rax
	jne	.L34
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$43, %edx
	movl	$1, %esi
	leaq	.LC0(%rip), %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L34:
	movq	copy(%rip), %rax
	movq	%rax, %rsi
	leaq	.LC1(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	cmpq	$33, %rax
	jne	.L35
	addq	$8, -40(%rbp)
.L35:
	movq	-56(%rbp), %rax
	salq	$3, %rax
	orq	$3, %rax
	movq	%rax, %rdi
	call	copydata
	leaq	.LC2(%rip), %rdi
	call	puts@PLT
	movq	_stack_base(%rip), %rax
	subq	$8, %rax
	movq	%rax, -24(%rbp)
	jmp	.L36
.L37:
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	copydata
	movq	%rax, %rdx
	movq	-24(%rbp), %rax
	movq	%rdx, (%rax)
	subq	$8, -24(%rbp)
.L36:
	movq	-24(%rbp), %rax
	cmpq	-40(%rbp), %rax
	ja	.L37
	leaq	.LC3(%rip), %rdi
	call	puts@PLT
	movq	-24(%rbp), %rdx
	movq	-24(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	copyll
	leaq	.LC4(%rip), %rdi
	call	puts@PLT
	movq	_mem_size(%rip), %rax
	movq	%rax, %rdx
	movq	-48(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	munmap@PLT
	leaq	.LC5(%rip), %rdi
	call	puts@PLT
	movq	copy(%rip), %rax
	movq	%rax, -8(%rbp)
	movq	copy(%rip), %rax
	movq	%rax, %rdx
	movq	-16(%rbp), %rax
	subq	%rax, %rdx
	movq	%rdx, %rax
	sarq	$3, %rax
	movq	%rax, %rcx
	movq	_mem_size(%rip), %rax
	leaq	3(%rax), %rdx
	testq	%rax, %rax
	cmovs	%rdx, %rax
	sarq	$2, %rax
	movq	%rax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	cmpq	%rax, %rcx
	jle	.L38
	movq	_mem_size(%rip), %rax
	addq	%rax, %rax
	movl	$0, %r9d
	movl	$-1, %r8d
	movl	$34, %ecx
	movl	$7, %edx
	movq	%rax, %rsi
	movl	$0, %edi
	call	mmap@PLT
	movq	%rax, copy(%rip)
	movq	copy(%rip), %rax
	cmpq	$-1, %rax
	jne	.L39
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$45, %edx
	movl	$1, %esi
	leaq	.LC6(%rip), %rdi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L39:
	movq	_mem_size(%rip), %rax
	movq	%rax, %rdx
	movq	-8(%rbp), %rcx
	movq	copy(%rip), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	memcpy@PLT
	movq	_mem_size(%rip), %rax
	movq	%rax, %rdx
	movq	-8(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	munmap@PLT
	movq	_mem_size(%rip), %rax
	addq	%rax, %rax
	movq	%rax, _mem_size(%rip)
.L38:
	movq	_mem_size(%rip), %rax
	leaq	3(%rax), %rdx
	testq	%rax, %rax
	cmovs	%rdx, %rax
	sarq	$2, %rax
	movq	%rax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rax, %rdx
	movq	copy(%rip), %rax
	addq	%rdx, %rax
	movq	%rax, _mem_max(%rip)
	movq	_mem_max(%rip), %rax
	movq	%rax, %rsi
	leaq	.LC7(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movq	-16(%rbp), %rax
	movq	-8(%rbp), %rdx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	_gc, .-_gc
	.ident	"GCC: (GNU) 7.1.1 20170630"
	.section	.note.GNU-stack,"",@progbits
