	.text
	.global	_main
	.global	main
_main:
main:
	pushq	%rbx
	pushq	%r12
	pushq	%r13
	pushq	%r14
	pushq	%r15
	pushq	%rdi
	pushq	%rsi
	pushq	%rbp
	movq	%rsp, %rbp
	xor	%rbx, %rbx
	movq	%rbp, _stack_base(%rip)
	movq	$134217728, %rax
	movq	%rax, _mem_size(%rip)
	call	_minit
	movq	%rax, %r12
	addq	$100663296, %rax
	movq	%rax, _mem_max(%rip)
	movq	$0, (%r12)
	movq	$17, 8(%r12)
	movq	$17, 16(%r12)
	lea	3(, %r12, 8), %r13
	addq	$24, %r12
	movq	$17, %r14
	call	_clear_regs
	.align	8

# GENERATED CODE BEGINING
################################################################################

	leaq	_ST1(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	call	_new	
	leaq	(%rax), %rdx
	movq	%rdx, -8(%rbp)
	movq	_trf_mask(%rip), %rax
	xorq	%rax, -8(%rbp)
	leaq	_FN1(%rip), %rdx
	movq	%rdx, (%r12)
	movq	%r14, 8(%r12)
	leaq	7(, %r12, 8), %rdx
	addq	$16, %r12
	movq	%rdx, -16(%rbp)
	subq	$16, %rsp
	call	_prep_gc
	movq	$-1, %rax
	movq	$-1, %rbx
	call	_transfer
	leave
	addq	$16, %rsp
	popq	%r15
	popq	%r14
	popq	%r13
	popq	%r12
	popq	%rbx
	movq	$0, %rax
	ret

# FUNCTIONS
################################################################################

	.align	8
_FN2:
	movq	$1, %rax
	call	_nil_fill
	call	_prep_gc
mem:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -8(%rbp)
_IF1:
_TH1:
	cmpq	$1, -8(%rbp)
	jz	_FI1
	cmpq	$17, -8(%rbp)
	jz	_FI1
	leaq	-8(%rbp), %rdx
	movq	%rdx, -16(%rbp)
	movq	_trf_mask(%rip), %rax
	xorq	%rax, -16(%rbp)
	leaq	_ST2(%rip), %rax
	leaq	2(, %rax, 8), %rdx
	movq	%rdx, -24(%rbp)
	subq	$16, %rsp
	call	_prep_gc
	movq	$-2, %rax
	movq	$-1, %rbx
	call	_transfer
_FI1:
	leaq	-8(%rbp), %rsp
	movq	$17, %rax
	leave
	ret
	.byte	0x0F, 0x90
_FE2:

	.align	8
_FN1:
	movq	$2, %rax
	call	_nil_fill
	call	_prep_gc
add:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	$17, -24(%rbp)
	subq	$24, %rsp
	call	_prep_gc
	leaq	-24(%rbp), %rdx
	movq	%rdx, -32(%rbp)
	movq	_trf_mask(%rip), %rax
	xorq	%rax, -32(%rbp)
	leaq	_FN2(%rip), %rdx
	movq	%rdx, (%r12)
	movq	%r14, 8(%r12)
	leaq	7(, %r12, 8), %rdx
	addq	$16, %r12
	movq	%rdx, -40(%rbp)
	subq	$16, %rsp
	call	_prep_gc
	movq	$-4, %rax
	movq	$-1, %rbx
	call	_transfer
	leaq	_ST3(%rip), %rax
	leaq	2(, %rax, 8), %rdx
	movq	-8(%rbp), %rcx
	leaq	_ST4(%rip), %rax
	leaq	2(, %rax, 8), %r8
	leaq	_ST3(%rip), %rax
	leaq	2(, %rax, 8), %r9
	movq	-16(%rbp), %r10
	leaq	_ST5(%rip), %rax
	leaq	2(, %rax, 8), %r11
	leaq	_ST6(%rip), %rax
	leaq	2(, %rax, 8), %rdi
	movq	%rdi, %rax
	movq	%r11, %rbx
	addq	$16, %rsp
	call	_concat
	movq	%r10, %rbx
	call	_concat
	xorq	%rbx, %rbx
	movq	%r9, %rbx
	call	_concat
	xorq	%rbx, %rbx
	movq	%r8, %rbx
	call	_concat
	xorq	%rbx, %rbx
	movq	%rcx, %rbx
	call	_concat
	xorq	%rbx, %rbx
	movq	%rdx, %rbx
	call	_concat
	xorq	%rbx, %rbx
	xorq	%rbx, %rbx
	xorq	%rbx, %rbx
	leave
	ret
	.byte	0x0F, 0x90
_FE1:


# DATA
################################################################################

	.data

_ST1:
	.quad	3
	.asciz	"add"
_ST2:
	.quad	6
	.asciz	"(%rbx)"
_ST3:
	.quad	6
	.asciz	"\tmovq\t"
_ST4:
	.quad	7
	.asciz	", %rax\n"
_ST5:
	.quad	7
	.asciz	", %rdx\n"
_ST6:
	.quad	16
	.asciz	"\addq\t%rax, %rdx\n"
