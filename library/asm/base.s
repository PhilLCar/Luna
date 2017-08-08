	.file	"base.c"
	.text
	.globl	lint
	.type	lint, @function
lint:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	sarq	$3, %rax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	lint, .-lint
	.globl	cint
	.type	cint, @function
cint:
.LFB1:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	salq	$3, %rax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	cint, .-cint
	.globl	lstr
	.type	lstr, @function
lstr:
.LFB2:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	sarq	$3, -8(%rbp)
	movq	-8(%rbp), %rax
	addq	$8, %rax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	lstr, .-lstr
	.globl	cstr
	.type	cstr, @function
cstr:
.LFB3:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, -8(%rbp)
	salq	$3, -8(%rbp)
	movq	-8(%rbp), %rax
	addq	$2, %rax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	cstr, .-cstr
	.section	.rodata
.LC0:
	.string	"%d\n"
.LC1:
	.string	"false"
.LC2:
	.string	"true"
.LC3:
	.string	"nil"
.LC4:
	.string	"%.20g\n"
	.text
	.globl	print
	.type	print, @function
print:
.LFB4:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movq	-40(%rbp), %rax
	andl	$7, %eax
	movl	%eax, -20(%rbp)
	movq	-40(%rbp), %rax
	sarq	$3, %rax
	movq	%rax, -16(%rbp)
	movl	-20(%rbp), %eax
	cmpl	$1, %eax
	je	.L11
	cmpl	$1, %eax
	jg	.L12
	testl	%eax, %eax
	je	.L13
	jmp	.L10
.L12:
	cmpl	$2, %eax
	je	.L14
	cmpl	$6, %eax
	je	.L15
	jmp	.L10
.L13:
	movq	-16(%rbp), %rax
	movq	%rax, %rsi
	leaq	.LC0(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	jmp	.L10
.L11:
	cmpq	$0, -16(%rbp)
	jne	.L16
	leaq	.LC1(%rip), %rdi
	call	puts@PLT
	jmp	.L20
.L16:
	cmpq	$1, -16(%rbp)
	jne	.L18
	leaq	.LC2(%rip), %rdi
	call	puts@PLT
	jmp	.L20
.L18:
	cmpq	$2, -16(%rbp)
	jne	.L20
	leaq	.LC3(%rip), %rdi
	call	puts@PLT
	jmp	.L20
.L14:
	movq	-16(%rbp), %rax
	addq	$8, %rax
	movq	%rax, %rdi
	call	puts@PLT
	jmp	.L10
.L15:
	movq	-16(%rbp), %rax
	movsd	(%rax), %xmm0
	movsd	%xmm0, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, -48(%rbp)
	movsd	-48(%rbp), %xmm0
	leaq	.LC4(%rip), %rdi
	movl	$1, %eax
	call	printf@PLT
	jmp	.L10
.L20:
	nop
.L10:
	movl	$1, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4:
	.size	print, .-print
	.ident	"GCC: (GNU) 7.1.1 20170630"
	.section	.note.GNU-stack,"",@progbits
