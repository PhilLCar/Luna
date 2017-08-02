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
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	-24(%rbp), %rax
	andl	$7, %eax
	movl	%eax, -12(%rbp)
	movq	-24(%rbp), %rax
	sarq	$3, %rax
	movq	%rax, -8(%rbp)
	movl	-12(%rbp), %eax
	cmpl	$1, %eax
	je	.L11
	cmpl	$2, %eax
	je	.L12
	testl	%eax, %eax
	jne	.L10
	movq	-8(%rbp), %rax
	movq	%rax, %rsi
	leaq	.LC0(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	jmp	.L10
.L11:
	cmpq	$0, -8(%rbp)
	jne	.L14
	leaq	.LC1(%rip), %rdi
	call	puts@PLT
	jmp	.L17
.L14:
	cmpq	$1, -8(%rbp)
	jne	.L16
	leaq	.LC2(%rip), %rdi
	call	puts@PLT
	jmp	.L17
.L16:
	cmpq	$2, -8(%rbp)
	jne	.L17
	leaq	.LC3(%rip), %rdi
	call	puts@PLT
	jmp	.L17
.L12:
	movq	-8(%rbp), %rax
	addq	$8, %rax
	movq	%rax, %rdi
	call	puts@PLT
	jmp	.L10
.L17:
	nop
.L10:
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4:
	.size	print, .-print
	.ident	"GCC: (GNU) 7.1.1 20170630"
	.section	.note.GNU-stack,"",@progbits
