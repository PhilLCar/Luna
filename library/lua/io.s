	.text
	.global	_load_io
_load_io:
	pushq	%rbp
	movq	%rsp, %rbp

# GENERATED CODE BEGINING
################################################################################

	subq	$15, %rsp
	andq	$-16, %rsp
	.align	8
	.fill	3, 1, 0x90
	callq	__file_init
	call	_clear_regs
	leaq	(%rbp), %rsp
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
	leaq	_ST1(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	addq	$16, %rsp
	call	_new	
	movq	(%rax), %rdx
	leaq	_ST3(%rip), %rax
	leaq	2(, %rax, 8), %rcx
	movq	%rcx, %rax
	movq	%rdx, %rbx
	call	_new	
	movq	%rax, -8(%rbp)
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
	leaq	_ST1(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	addq	$16, %rsp
	call	_new	
	movq	(%rax), %rdx
	leaq	_ST4(%rip), %rax
	leaq	2(, %rax, 8), %rcx
	movq	%rcx, %rax
	movq	%rdx, %rbx
	call	_new	
	movq	%rax, -8(%rbp)
	movq	_trf_mask(%rip), %rax
	xorq	%rax, -8(%rbp)
	leaq	_FN3(%rip), %rdx
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
	leaq	_ST1(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	addq	$16, %rsp
	call	_new	
	movq	(%rax), %rdx
	leaq	_ST5(%rip), %rax
	leaq	2(, %rax, 8), %rcx
	movq	%rcx, %rax
	movq	%rdx, %rbx
	call	_new	
	movq	%rax, -8(%rbp)
	movq	_trf_mask(%rip), %rax
	xorq	%rax, -8(%rbp)
	leaq	_FN4(%rip), %rdx
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
	jz	_LU7
_LU6:	cmp	$0, %rbx
	jz	_LU7
_LU8:	cmpq	$33, (%rbx)
	jz	_LU7
	pushq	(%rbx)
	subq	$8, %rbx
	jmp	_LU8
_LU7:	pushq	$33
	call	_prep_gc
	movq	%rdx, %rax
	call	_array_copy
	leaq	-8(%rbp), %rsp
	movq	%rdx, -16(%rbp)
	subq	$8, %rsp
	call	_prep_gc
	movsd	_DB9(%rip), %xmm4
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
	jnz	_LU10
	call	_check
_LU10:	cvtsi2sd (%rax), %xmm0
	movsd	%xmm0, %xmm4
	movsd	%xmm4, -48(%rbp)
	movsd	_DB9(%rip), %xmm4
	movsd	%xmm4, -56(%rbp)
	movsd	-40(%rbp), %xmm0
_FRC1:
	leaq	-56(%rbp), %rsp
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
	call	_prep_gc
	movq	-16(%rbp), %rdi
	movq	-32(%rbp), %rax
	movq	%rdi, %rbx
	call	_index	
	movq	__CUROUT__(%rip), %rsi
	subq	$15, %rsp
	andq	$-16, %rsp
	.align	8
	.fill	3, 1, 0x90
	callq	_write
	call	_clear_regs
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
	leave
	ret
	.byte	0x0F, 0x90
_FE1:

	.align	8
_FN2:
	movq	$0, %rax
	call	_nil_fill
	call	_prep_gc
io_read:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	__CURIN__(%rip), %rdi
	subq	$15, %rsp
	andq	$-16, %rsp
	.align	8
	.fill	3, 1, 0x90
	callq	_io_read
	call	_clear_regs
	leaq	(%rbp), %rsp
	cmpq	$33, %rax
	jz	_LU14
_LU13:	cmp	$0, %rbx
	jz	_LU14
_LU15:	cmpq	$33, (%rbx)
	jz	_LU14
	pushq	(%rbx)
	subq	$8, %rbx
	jmp	_LU15
_LU14:	pushq	$33
	leaq	-8(%rbp), %rbx
	leave
	ret
	.byte	0x0F, 0x90
_FE2:

	.align	8
_FN3:
	movq	$2, %rax
	call	_nil_fill
	call	_prep_gc
io_open:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-8(%rbp), %rdi
	leaq	-16(%rbp), %rsp
	movq	-16(%rbp), %rsi
	subq	$15, %rsp
	andq	$-16, %rsp
	.align	8
	.fill	3, 1, 0x90
	callq	_io_open
	call	_clear_regs
	leaq	-16(%rbp), %rsp
	cmpq	$33, %rax
	jz	_LU19
_LU18:	cmp	$0, %rbx
	jz	_LU19
_LU20:	cmpq	$33, (%rbx)
	jz	_LU19
	pushq	(%rbx)
	subq	$8, %rbx
	jmp	_LU20
_LU19:	pushq	$33
	leaq	-24(%rbp), %rbx
	leave
	ret
	.byte	0x0F, 0x90
_FE3:

	.align	8
_FN4:
	movq	$1, %rax
	call	_nil_fill
	call	_prep_gc
io_popen:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -8(%rbp)
	leaq	-8(%rbp), %rsp
	movq	-8(%rbp), %rdi
	subq	$15, %rsp
	andq	$-16, %rsp
	.align	8
	.fill	3, 1, 0x90
	callq	_io_popen
	call	_clear_regs
	leaq	-8(%rbp), %rsp
	cmpq	$33, %rax
	jz	_LU24
_LU23:	cmp	$0, %rbx
	jz	_LU24
_LU25:	cmpq	$33, (%rbx)
	jz	_LU24
	pushq	(%rbx)
	subq	$8, %rbx
	jmp	_LU25
_LU24:	pushq	$33
	leaq	-16(%rbp), %rbx
	leave
	ret
	.byte	0x0F, 0x90
_FE4:


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
	.quad	4
	.asciz	"read"
_ST4:
	.quad	4
	.asciz	"open"
_ST5:
	.quad	5
	.asciz	"popen"
_DB9:
	.double	1
