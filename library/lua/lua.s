	.text
	.global	_load_lua
_load_lua:
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
	leaq	_ST2(%rip), %rax
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
	movq	$-1, %rax
	movq	$-1, %rbx
	subq	$16, %rsp
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
	leaq	_FN3(%rip), %rdx
	movq	%rdx, (%r12)
	movq	%r14, 8(%r12)
	leaq	7(, %r12, 8), %rdx
	addq	$16, %r12
	movq	%rdx, -16(%rbp)
	movq	$-1, %rax
	movq	$-1, %rbx
	subq	$16, %rsp
	call	_transfer
	leaq	_ST4(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	addq	$16, %rsp
	call	_new	
	leaq	(%rax), %rdx
	movq	%rdx, -8(%rbp)
	movq	_trf_mask(%rip), %rax
	xorq	%rax, -8(%rbp)
	leaq	_FN4(%rip), %rdx
	movq	%rdx, (%r12)
	movq	%r14, 8(%r12)
	leaq	7(, %r12, 8), %rdx
	addq	$16, %r12
	movq	%rdx, -16(%rbp)
	movq	$-1, %rax
	movq	$-1, %rbx
	subq	$16, %rsp
	call	_transfer
	leaq	_ST5(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	addq	$16, %rsp
	call	_new	
	leaq	(%rax), %rdx
	movq	%rdx, -8(%rbp)
	movq	_trf_mask(%rip), %rax
	xorq	%rax, -8(%rbp)
	leaq	_FN5(%rip), %rdx
	movq	%rdx, (%r12)
	movq	%r14, 8(%r12)
	leaq	7(, %r12, 8), %rdx
	addq	$16, %r12
	movq	%rdx, -16(%rbp)
	movq	$-1, %rax
	movq	$-1, %rbx
	subq	$16, %rsp
	call	_transfer
	leaq	_ST6(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	addq	$16, %rsp
	call	_new	
	leaq	(%rax), %rdx
	movq	%rdx, -8(%rbp)
	movq	_trf_mask(%rip), %rax
	xorq	%rax, -8(%rbp)
	leaq	_FN6(%rip), %rdx
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
	call	_clear_regs
	movq	$0, %rax
	ret

# FUNCTIONS
################################################################################

	.align	8
_FN1:
	movq	$1, %rax
	call	_nil_fill
	call	_prep_gc
type:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -8(%rbp)
	leaq	-8(%rbp), %rsp
	movq	-8(%rbp), %rdi
	pushq	$33
	andq	$-16, %rsp
	.align	8
	.fill	3, 1, 0x90
	callq	_type
	call	_clear_regs
	leaq	-8(%rbp), %rsp
	movq	%rax, -16(%rbp)
_IF1:
	movq	-16(%rbp), %rdx
	movsd	_DB7(%rip), %xmm4
	movsd	%xmm4, (%r12)
	movq	%rdx, %rbx
	leaq	6(, %r12, 8), %rax
	addq	$8, %r12
	subq	$8, %rsp
	call	_compare
	xorq	%rbx, %rbx
_TH1:
	cmpq	$1, %rax
	jz	_EL1
	cmpq	$17, %rax
	jz	_EL1
	leaq	_ST8(%rip), %rax
	leaq	2(, %rax, 8), %rdx
	xorq	%rbx, %rbx
	movq	%rdx, %rax
	leave
	ret
	jmp	_FI1
_EL1:
_IF2:
	movq	-16(%rbp), %rdx
	movsd	_DB9(%rip), %xmm4
	movsd	%xmm4, (%r12)
	movq	%rdx, %rbx
	leaq	6(, %r12, 8), %rax
	addq	$8, %r12
	call	_compare
	xorq	%rbx, %rbx
_TH2:
	cmpq	$1, %rax
	jz	_EL2
	cmpq	$17, %rax
	jz	_EL2
	leaq	_ST10(%rip), %rax
	leaq	2(, %rax, 8), %rdx
	xorq	%rbx, %rbx
	movq	%rdx, %rax
	leave
	ret
	jmp	_FI2
_EL2:
_IF3:
	movq	-16(%rbp), %rdx
	movsd	_DB11(%rip), %xmm4
	movsd	%xmm4, (%r12)
	movq	%rdx, %rbx
	leaq	6(, %r12, 8), %rax
	addq	$8, %r12
	call	_compare
	xorq	%rbx, %rbx
_TH3:
	cmpq	$1, %rax
	jz	_EL3
	cmpq	$17, %rax
	jz	_EL3
	leaq	_ST12(%rip), %rax
	leaq	2(, %rax, 8), %rdx
	xorq	%rbx, %rbx
	movq	%rdx, %rax
	leave
	ret
	jmp	_FI3
_EL3:
_IF4:
	movq	-16(%rbp), %rdx
	movsd	_DB13(%rip), %xmm4
	movsd	%xmm4, (%r12)
	movq	%rdx, %rbx
	leaq	6(, %r12, 8), %rax
	addq	$8, %r12
	call	_compare
	xorq	%rbx, %rbx
_TH4:
	cmpq	$1, %rax
	jz	_EL4
	cmpq	$17, %rax
	jz	_EL4
	leaq	_ST14(%rip), %rax
	leaq	2(, %rax, 8), %rdx
	xorq	%rbx, %rbx
	movq	%rdx, %rax
	leave
	ret
	jmp	_FI4
_EL4:
_IF5:
	movq	-16(%rbp), %rdx
	movsd	_DB15(%rip), %xmm4
	movsd	%xmm4, (%r12)
	movq	%rdx, %rbx
	leaq	6(, %r12, 8), %rax
	addq	$8, %r12
	call	_compare
	xorq	%rbx, %rbx
_TH5:
	cmpq	$1, %rax
	jz	_EL5
	cmpq	$17, %rax
	jz	_EL5
	leaq	_ST8(%rip), %rax
	leaq	2(, %rax, 8), %rdx
	xorq	%rbx, %rbx
	movq	%rdx, %rax
	leave
	ret
	jmp	_FI5
_EL5:
_IF6:
	movq	-16(%rbp), %rdx
	movsd	_DB16(%rip), %xmm4
	movsd	%xmm4, (%r12)
	movq	%rdx, %rbx
	leaq	6(, %r12, 8), %rax
	addq	$8, %r12
	call	_compare
	xorq	%rbx, %rbx
_TH6:
	cmpq	$1, %rax
	jz	_FI6
	cmpq	$17, %rax
	jz	_FI6
	leaq	_ST17(%rip), %rax
	leaq	2(, %rax, 8), %rdx
	xorq	%rbx, %rbx
	movq	%rdx, %rax
	leave
	ret
_FI6:
	leaq	-16(%rbp), %rsp
_FI5:
_FI4:
_FI3:
_FI2:
_FI1:
	leaq	_ST18(%rip), %rax
	leaq	2(, %rax, 8), %rdx
	xorq	%rbx, %rbx
	movq	%rdx, %rax
	leave
	ret

_FE1:

	.align	8
_FN2:
	movq	$1, %rax
	call	_nil_fill
	call	_prep_gc
tostring:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -8(%rbp)
	movq	$33, %rax
	popq	%rbp
	ret
_FE2:

	.align	8
_FN3:
	movq	$1, %rax
	call	_nil_fill
	call	_prep_gc
tonumber:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -8(%rbp)
	leaq	-8(%rbp), %rsp
	movq	-8(%rbp), %rdi
	pushq	$33
	andq	$-16, %rsp
	.align	8
	.fill	3, 1, 0x90
	callq	_type
	call	_clear_regs
	leaq	-8(%rbp), %rsp
	movq	%rax, -16(%rbp)
_IF7:
	movq	-16(%rbp), %rdx
	movsd	_DB11(%rip), %xmm4
	movsd	%xmm4, (%r12)
	movq	%rdx, %rbx
	leaq	6(, %r12, 8), %rax
	addq	$8, %r12
	subq	$8, %rsp
	call	_compare
	xorq	%rbx, %rbx
_TH7:
	cmpq	$1, %rax
	jz	_EL7
	cmpq	$17, %rax
	jz	_EL7
	jmp	_FI7
_EL7:
_IF8:
	movq	-16(%rbp), %rdx
	movsd	_DB7(%rip), %xmm4
	movsd	%xmm4, (%r12)
	movq	%rdx, %rbx
	leaq	6(, %r12, 8), %rax
	addq	$8, %r12
	call	_compare
	movq	%rax, %rdx
	movq	%rdx, %rax
	orq	$17, %rdx
	cmpq	$17, %rdx
	jnz	_CH1
	movq	-16(%rbp), %rdx
	movsd	_DB15(%rip), %xmm4
	movsd	%xmm4, (%r12)
	movq	%rdx, %rbx
	leaq	6(, %r12, 8), %rax
	addq	$8, %r12
	call	_compare
	movq	%rax, %rdx
	movq	%rdx, %rax
_CH1:	leaq	-16(%rbp), %rsp
	xorq	%rbx, %rbx
	xorq	%rbx, %rbx
_TH8:
	cmpq	$1, %rax
	jz	_FI8
	cmpq	$17, %rax
	jz	_FI8
	xorq	%rbx, %rbx
	movq	-8(%rbp), %rax
	leave
	ret
_FI8:
	leaq	-16(%rbp), %rsp
_FI7:
	xorq	%rbx, %rbx
	movq	$17, %rax
	leave
	ret

_FE3:

	.align	8
_FN4:
	movq	$2, %rax
	call	_nil_fill
	call	_prep_gc
next:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-8(%rbp), %rdi
	leaq	-16(%rbp), %rsp
	movq	-16(%rbp), %rsi
	pushq	$33
	andq	$-16, %rsp
	.align	8
	.fill	3, 1, 0x90
	callq	_next
	call	_clear_regs
	leaq	-16(%rbp), %rsp
	cmpq	$33, %rax
	jnz	_LU21
	addq	$8, %rsp
	jmp	_LU22
_LU21:	cmp	$0, %rbx
	jz	_LU22
_LU23:	cmpq	$33, (%rbx)
	jz	_LU22
	pushq	(%rbx)
	subq	$8, %rbx
	jmp	_LU23
_LU22:	pushq	$33
	leaq	-24(%rbp), %rbx
	leave
	ret

_FE4:

	.align	8
_FN5:
	movq	$1, %rax
	call	_nil_fill
	call	_prep_gc
pairs:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -8(%rbp)
	leaq	_ST4(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	subq	$8, %rsp
	call	_index	
	movq	(%rax), %r15
	movq	%r15, -16(%rbp)
	movq	-8(%rbp), %r15
	movq	%r15, -24(%rbp)
	movq	$17, -32(%rbp)
	movq	$33, -40(%rbp)
	leaq	-24(%rbp), %rbx
	movq	-16(%rbp), %rax
	leave
	ret

_FE5:

	.align	8
_FN7:
	movq	$2, %rax
	call	_nil_fill
	call	_prep_gc
inext:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-8(%rbp), %rdi
	leaq	-16(%rbp), %rsp
	movq	-16(%rbp), %rsi
	pushq	$33
	andq	$-16, %rsp
	.align	8
	.fill	3, 1, 0x90
	callq	_inext
	call	_clear_regs
	leaq	-16(%rbp), %rsp
	cmpq	$33, %rax
	jnz	_LU26
	addq	$8, %rsp
	jmp	_LU27
_LU26:	cmp	$0, %rbx
	jz	_LU27
_LU28:	cmpq	$33, (%rbx)
	jz	_LU27
	pushq	(%rbx)
	subq	$8, %rbx
	jmp	_LU28
_LU27:	pushq	$33
	leaq	-24(%rbp), %rbx
	leave
	ret

_FE7:

	.align	8
_FN6:
	movq	$1, %rax
	call	_nil_fill
	call	_prep_gc
ipairs:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -8(%rbp)
	leaq	_FN7(%rip), %rdx
	movq	%rdx, (%r12)
	movq	%r14, 8(%r12)
	leaq	7(, %r12, 8), %rdx
	addq	$16, %r12
	movq	%rdx, -16(%rbp)
	movq	-16(%rbp), %r15
	movq	%r15, -24(%rbp)
	movq	-8(%rbp), %r15
	movq	%r15, -32(%rbp)
	movsd	_DB7(%rip), %xmm4
	movsd	%xmm4, (%r12)
	leaq	6(, %r12, 8), %r15
	addq	$8, %r12
	movq	%r15, -40(%rbp)
	movq	$33, -48(%rbp)
	leaq	-32(%rbp), %rbx
	movq	-24(%rbp), %rax
	popq	%rbp
	ret

_FE6:


# DATA
################################################################################

	.data

_ST1:
	.quad	4
	.asciz	"type"
_ST2:
	.quad	8
	.asciz	"tostring"
_ST3:
	.quad	8
	.asciz	"tonumber"
_ST4:
	.quad	4
	.asciz	"next"
_ST5:
	.quad	5
	.asciz	"pairs"
_ST6:
	.quad	6
	.asciz	"ipairs"
_DB7:
	.double	0
_ST8:
	.quad	6
	.asciz	"number"
_DB9:
	.double	1
_ST10:
	.quad	7
	.asciz	"boolean"
_DB11:
	.double	2
_ST12:
	.quad	6
	.asciz	"string"
_DB13:
	.double	3
_ST14:
	.quad	5
	.asciz	"table"
_DB15:
	.double	6
_DB16:
	.double	7
_ST17:
	.quad	8
	.asciz	"function"
_ST18:
	.quad	3
	.asciz	"nil"
