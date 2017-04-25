	.text
	.global	_main
	.global	main
_main:
main:
	xor	%rbx, %rbx
	mov	$134217728, %rax
	push	%rax
	call	mmap
	mov	%rax, %rbp
	mov	%rbp, %rbx
	add	$16, %rbp
	movq	$0, (%rbx)
	movq	$17, 8(%rbx)
	lea	3(, %rbx, 8), %rbx
	push	$17
	mov	%rsp, %r10
	lea	3(, %rbp, 8), %r11
	add	$16, %rbp
	lea	-8(%rbp), %r12
	mov	$8, %r13
	add	$16, %r13
	lea	4(, %rbp, 8), %rsi
	mov	%rsi, (%r12)
	movq	$8, (%rbp)
	movq	%r13, 8(%rbp)
	add	$24, %rbp
	lea	-8(%rbp), %r12
	lea	4(, %rbp, 8), %rsi
	mov	%rsi, (%r12)
	movq	$16, (%rbp)
	movq	$16, 8(%rbp)
	add	$24, %rbp
	lea	-8(%rbp), %r12
	lea	3(, %rbp, 8), %r13
	add	$16, %rbp
	lea	-8(%rbp), %r14
	lea	4(, %rbp, 8), %rsi
	mov	%rsi, (%r14)
	movq	$8, (%rbp)
	movq	$16, 8(%rbp)
	add	$24, %rbp
	lea	-8(%rbp), %r14
	lea	4(, %rbp, 8), %rsi
	mov	%rsi, (%r14)
	movq	$16, (%rbp)
	movq	$48, 8(%rbp)
	add	$24, %rbp
	lea	-8(%rbp), %r14
	movq	$17, (%r14)
	mov	%r13, %rsi
	sar	$3, %rsi
	movq	$16, (%rsi)
	lea	4(, %rbp, 8), %rsi
	mov	%rsi, (%r12)
	movq	$24, (%rbp)
	movq	%r13, 8(%rbp)
	add	$24, %rbp
	lea	-8(%rbp), %r12
	lea	4(, %rbp, 8), %rsi
	mov	%rsi, (%r12)
	movq	$32, (%rbp)
	movq	$24, 8(%rbp)
	add	$24, %rbp
	lea	-8(%rbp), %r12
	lea	4(, %rbp, 8), %rsi
	mov	%rsi, (%r12)
	movq	$40, (%rbp)
	movq	$32, 8(%rbp)
	add	$24, %rbp
	lea	-8(%rbp), %r12
	movq	$17, (%r12)
	mov	%r11, %rsi
	sar	$3, %rsi
	movq	$40, (%rsi)
	movq	$4, (%rbp)
	movq	%r11, 8(%rbp)
	movq	$17, 16(%rbp)
	lea	4(, %rbp, 8), %rsi
	mov	%rsi, (%r10)
	lea	16(%rbp), %r10
	add	$24, %rbp
	pop	%rsi
	mov	$1, %rdi
	call	stack
	mov	(%rsp), %r10
	lea	string1(%rip), %r11
	lea	2(, %r11, 8), %r11
	mov	%r11, %r8
	mov	%r10, %r9
	call	new
	lea	(%rsi), %rsi
	push	%rsi
	push	$17
	mov	%rsp, %r10
	mov	16(%rsp), %rsi
	movq	$4, (%rbp)
	movq	%rsi, 8(%rbp)
	movq	$17, 16(%rbp)
	lea	4(, %rbp, 8), %rsi
	mov	%rsi, (%r10)
	lea	16(%rbp), %r10
	add	$24, %rbp
	pop	%rsi
	mov	$1, %rdi
	call	place
	mov	(%rsp), %rsi
	call	check
	push	$17
	mov	%rsp, %r10
	mov	8(%rsp), %r11
	lea	string2(%rip), %r12
	lea	2(, %r12, 8), %r12
	mov	%r12, %r8
	mov	%r11, %r9
	call	index
	mov	(%rsi), %rsi
	sar	$3, %rsi
	mov	(%rsi), %rsi
	mov	%rsi, %r11
	mov	8(%rsp), %r12
	lea	string3(%rip), %r13
	lea	2(, %r13, 8), %r13
	mov	%r13, %r8
	mov	%r12, %r9
	call	index
	mov	(%rsi), %r12
	mov	$24, %r8
	mov	%r12, %r9
	call	index
	mov	(%rsi), %rsi
	sar	$3, %rsi
	mov	(%rsi), %rsi
	add	%rsi, %r11
	movq	$4, (%rbp)
	movq	%r11, 8(%rbp)
	movq	$17, 16(%rbp)
	lea	4(, %rbp, 8), %rsi
	mov	%rsi, (%r10)
	lea	16(%rbp), %r10
	add	$24, %rbp
	pop	%rsi
	mov	$1, %rdi
	call	stack
	mov	(%rsp), %r10
	mov	$64, %rsi
	mov	%r10, %rdi
	call	compare
	mov	%rsi, %r10
	cmp	$1, %r10
	jz	else1
	cmp	$17, %r10
	jz	else1
	mov	8(%rsp), %r10
	mov	$24, %r8
	mov	%r10, %r9
	call	new
	lea	(%rsi), %rsi
	push	%rsi
	push	$17
	mov	%rsp, %r10
	movq	$4, (%rbp)
	movq	$17, 8(%rbp)
	movq	$17, 16(%rbp)
	lea	4(, %rbp, 8), %rsi
	mov	%rsi, (%r10)
	lea	16(%rbp), %r10
	add	$24, %rbp
	pop	%rsi
	mov	$1, %rdi
	call	place
	mov	8(%rsp), %rsi
	call	check
else1:
iend1:
	mov	8(%rsp), %rsi
	sar	$3, %rsi
	mov	(%rsi), %rsi
	push	%rsi
	call	print_lua
	call	print_ret
	add	$16, %rsp
	mov	$0, %rax
	ret


################################################################################
.data

string1:
	.quad	32
	.asciz	"test"
string2:
	.quad	32
	.asciz	"test"
string3:
	.quad	32
	.asciz	"test"
