	.text
	.global	_load_io
_load_io:
	pushq	%rbp
	movq	%rsp, %rbp

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
	movq	$33, (%r12)
	movq	$17, 8(%r12)
	leaq	-16(%rbp), %rax
	movq	%rax, 16(%r12)
	leaq	3(, %r12, 8), %rdx
	addq	$24, %r12
	subq	$8, %rsp
	pushq	$33
	call	_prep_gc
	movq	%rdx, %rax
	call	_array_copy
	leaq	-8(%rbp), %rsp
	movq	%rdx, -16(%rbp)
	subq	$8, %rsp
	call	_prep_gc
	movq	$-1, %rax
	movq	$-1, %rbx
	call	_transfer
	leaq	_ST1(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	addq	$16, %rsp
	call	_new	
	movq	(%rax), %rdx
	leaq	_ST2(%rip), %rax
	leaq	2(, %rax, 8), %rcx
	movq	%rcx, %rax
	movq	%rdx, %rbx
	call	_new	
	movq	%rax, -8(%rbp)
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
	leaq	_ST3(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	addq	$16, %rsp
	call	_new	
	leaq	(%rax), %rdx
	movq	%rdx, -8(%rbp)
	movq	_trf_mask(%rip), %rax
	xorq	%rax, -8(%rbp)
	leaq	_FN2(%rip), %rdx
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
	call	_clear_regs
	movq	$0, %rax
	ret

# FUNCTIONS
################################################################################

	.align	8
_FN1:
	movq	%r15, (%r12)
	movq	$1, %rax
	call	_nil_fill
	call	_varargs
	movq	%r15, %rdi
	call	_prep_gc
io_write:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -8(%rbp)
	movq	$33, (%r12)
	movq	$17, 8(%r12)
	leaq	-16(%rbp), %rax
	movq	%rax, 16(%r12)
	leaq	3(, %r12, 8), %rdx
	addq	$24, %r12
	movq	-8(%rbp), %rax
	sarq	$3, %rax
	leaq	-8(%rax), %rbx
	movq	(%rax), %rax
	movq	%rax, -16(%rbp)
	subq	$16, %rsp
	cmpq	$33, %rax
	jnz	_LU4
	addq	$8, %rsp
	jmp	_LU5
_LU4:	cmp	$0, %rbx
	jz	_LU5
_LU6:	cmpq	$33, (%rbx)
	jz	_LU5
	pushq	(%rbx)
	subq	$8, %rbx
	jmp	_LU6
_LU5:	pushq	$33
	call	_prep_gc
	movq	%rdx, %rax
	call	_array_copy
	leaq	-8(%rbp), %rsp
	movq	%rdx, -16(%rbp)
	subq	$8, %rsp
	call	_prep_gc
	movsd	_DB7(%rip), %xmm4
	movq	$129, -24(%rbp)
	movsd	%xmm4, %xmm0
	movsd	%xmm0, (%r12)
	leaq	6(, %r12, 8), %r15
	addq	$8, %r12
	movq	%r15, -32(%rbp)
	movq	%xmm0, -40(%rbp)
	subq	$24, %rsp
	movq	-16(%rbp), %rax
	sarq	$3, %rax
	cmpq	$65, (%rax)
	jnz	_LU8
	call	_check
_LU8:	cvtsi2sd (%rax), %xmm0
	movsd	%xmm0, %xmm4
	movsd	%xmm4, -48(%rbp)
	movsd	_DB7(%rip), %xmm4
	movsd	%xmm4, -56(%rbp)
	movsd	-40(%rbp), %xmm0
_FRC1:
	leaq	-56(%rbp), %rsp
	call	_prep_gc
	xorpd	%xmm1, %xmm1
	cmpsd	$6, -56(%rbp), %xmm1
	movq	%xmm1, %rax
	cmpq	$-1, %rax
	jz	_FRN1
	movsd	%xmm0, %xmm1
	cmpsd	$6, -48(%rbp), %xmm1
	movq	%xmm1, %rax
	cmpq	$-1, %rax
	jz	_FRE1
	jmp	_FRS1
_FRN1:	movsd	%xmm0, %xmm1
	cmpsd	$1, -48(%rbp), %xmm1
	movq	%xmm1, %rax
	cmpq	$-1, %rax
	jz	_FRE1
_FRS1:
	movq	-16(%rbp), %rdi
	movq	-32(%rbp), %rax
	movq	%rdi, %rbx
	call	_index	
	movq	(%rax), %rdi
	pushq	$33
	andq	$-16, %rsp
	.align	8
	.fill	3, 1, 0x90
	callq	_print
	call	_clear_regs
	leaq	-56(%rbp), %rsp
_IF1:
	movq	-32(%rbp), %rdx
	movq	-16(%rbp), %rax
	sarq	$3, %rax
	cmpq	$65, (%rax)
	jnz	_LU9
	call	_check
_LU9:	cvtsi2sd (%rax), %xmm0
	movsd	%xmm0, %xmm4
	movsd	%xmm4, (%r12)
	movq	%rdx, %rbx
	leaq	6(, %r12, 8), %rax
	addq	$8, %r12
	call	_neq
	xorq	%rbx, %rbx
	xorq	%rbx, %rbx
_TH1:
	cmpq	$1, %rax
	jz	_FI1
	cmpq	$17, %rax
	jz	_FI1
	leaq	_ST10(%rip), %rax
	leaq	2(, %rax, 8), %rdi
	pushq	$33
	andq	$-16, %rsp
	.align	8
	.fill	3, 1, 0x90
	callq	_print
	call	_clear_regs
	leaq	-56(%rbp), %rsp
_FI1:
	leaq	-56(%rbp), %rsp
	movsd	-56(%rbp), %xmm1
	movsd	-40(%rbp), %xmm0
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -40(%rbp)
	movq	-32(%rbp), %rax
	sarq	$3, %rax
	movsd	%xmm0, (%rax)
	jmp	_FRC1
_FRE1:
	leaq	-16(%rbp), %rsp
	movq	$33, %rax
	call	_prep_ex_gc
	leave
	ret
_FE1:

	.align	8
_FN2:
	movq	%r15, (%r12)
	movq	$1, %rax
	call	_nil_fill
	call	_varargs
	movq	%r15, %rdi
	call	_prep_gc
print:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -8(%rbp)
	leaq	_ST1(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	subq	$8, %rsp
	call	_index	
	movq	(%rax), %rdx
	leaq	_ST2(%rip), %rax
	leaq	2(, %rax, 8), %rcx
	movq	%rcx, %rax
	movq	%rdx, %rbx
	call	_index	
	movq	(%rax), %r15
	movq	%r15, -16(%rbp)
	movq	-8(%rbp), %rax
	sarq	$3, %rax
	leaq	-8(%rax), %rbx
	movq	(%rax), %rax
	leaq	-16(%rbp), %rsp
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	%rax, %rdi
	movq	$1, %r15
# Comparison routine
	cmpq	$33, %rax
	jnz	_DN14
	dec	%r15
	jmp	_DE12
_DN14:	cmpq	$0, %rbx
	jz	_DE12
_DM11:	cmpq	$33, (%rbx)
	jz	_DE12
	cmpq	$1, %r15
	jz	_DV15
	cmpq	$2, %r15
	jz	_DV16
	cmpq	$3, %r15
	jz	_DV17
	cmpq	$4, %r15
	jz	_DV18
	cmpq	$5, %r15
	jz	_DV19
	jmp	_DV20
_DV15:	movq	(%rbx), %rsi
	jmp	_DA13
_DV16:	movq	(%rbx), %rdx
	jmp	_DA13
_DV17:	movq	(%rbx), %rcx
	jmp	_DA13
_DV18:	movq	(%rbx), %r8
	jmp	_DA13
_DV19:	movq	(%rbx), %r9
	jmp	_DA13
_DV20:	pushq	(%rbx)
_DA13:	subq	$8, %rbx
	inc	%r15
	jmp	_DM11
_DE12:	movq	-16(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-24(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	-8(%rbp), %rsp
	leaq	_ST21(%rip), %rax
	leaq	2(, %rax, 8), %rdi
	pushq	$33
	andq	$-16, %rsp
	.align	8
	.fill	3, 1, 0x90
	callq	_print
	call	_clear_regs
	leaq	-8(%rbp), %rsp
	movq	$33, %rax
	call	_prep_ex_gc
	leave
	ret
_FE2:


# DATA
################################################################################

	.data

_ST1:
	.quad	2
	.asciz	"io"
_ST2:
	.quad	5
	.asciz	"write"
_ST3:
	.quad	5
	.asciz	"print"
_DB7:
	.double	1
_ST10:
	.quad	2
	.asciz	"\t"
_ST21:
	.quad	2
	.asciz	"\n"
