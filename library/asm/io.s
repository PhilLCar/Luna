_load_io:
	leaq	_ST1(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	call	_new	
	leaq	(%rax), %rdx
	movq	%rdx, -8(%rbp)
	leaq	_FN1(%rip), %rdx
	movq	%rdx, (%r12)
	movq	%r14, 8(%r12)
	leaq	7(, %r12, 8), %rdx
	addq	$16, %r12
	movq	%rdx, -16(%rbp)
	movq	$-1, %rax
	movq	$-1, %rbx
	subq	$16, %rsp
	call	_transfer
	leave
	movq	$0, %rax
	ret

# FUNCTIONS
################################################################################

	.align	8
	.fill	1, 1, 0x90
_FN1:
	movq	$1, %rax
	call	_nil_fill
	call	_varargs
	movq	%r15, %rdi
print:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	sarq	$3, %rax
	leaq	-8(%rax), %rbx
	movq	(%rax), %rax
	leaq	-8(%rbp), %rsp
	movq	%rax, %rdi
# Comparison routine
	cmpq	$0, %rbx
	jz	_DE3
	movq	(%rbx), %rsi
	jmp	_DA4
_DM2:	cmpq	$33, (%rbx)
	jz	_DE3
	cmpq	$2, %r15
	jz	_DV5
	cmpq	$3, %r15
	jz	_DV6
	cmpq	$4, %r15
	jz	_DV7
	cmpq	$5, %r15
	jz	_DV8
	jmp	_DV9
_DV5:	movq	(%rbx), %rdx
	jmp	_DA4
_DV6:	movq	(%rbx), %rcx
	jmp	_DA4
_DV7:	movq	(%rbx), %r8
	jmp	_DA4
_DV8:	movq	(%rbx), %r9
	jmp	_DA4
_DV9:	pushq	(%rbx)
_DA4:	subq	$8, %rbx
	inc	%r15
	jmp	_DM2
_DE3:	subq	$16, %rsp
	andq	$-16, %rsp
	call	_print
	leaq	-8(%rbp), %rsp
	movq	$17, %rax
	leave
	ret


# DATA
################################################################################

	.data

_ST1:
	.quad	5
	.asciz	"print"
