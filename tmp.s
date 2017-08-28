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
	leaq	_ST2(%rip), %rax
	leaq	2(, %rax, 8), %rdx
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

# DATA
################################################################################

	.data

_ST1:
	.quad	3
	.asciz	"tmp"
_ST2:
	.quad	103
	.asciz	"Paul profitait du soleil.\n\t- \"Il n'y avait pas beaucoup de monde sur la plage aujourd'hui\", pensait-il."
