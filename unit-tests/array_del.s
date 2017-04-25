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
	lea	4(, %rbp, 8), %rsi
	mov	%rsi, (%r12)
	movq	$8, (%rbp)
	movq	$8, 8(%rbp)
	add	$24, %rbp
	lea	-8(%rbp), %r12
	lea	4(, %rbp, 8), %rsi
	mov	%rsi, (%r12)
	movq	$16, (%rbp)
	movq	$24, 8(%rbp)
	add	$24, %rbp
	lea	-8(%rbp), %r12
	lea	4(, %rbp, 8), %rsi
	mov	%rsi, (%r12)
	movq	$24, (%rbp)
	movq	$32, 8(%rbp)
	add	$24, %rbp
	lea	-8(%rbp), %r12
	movq	$17, (%r12)
	mov	%r11, %rsi
	sar	$3, %rsi
	movq	$24, (%rsi)
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
	mov	$8, %r8
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
	mov	(%rsp), %rsi
	call	check
	mov	(%rsp), %rsi
	sar	$3, %rsi
	mov	(%rsi), %rsi
	push	%rsi
	call	print_lua
	call	print_ret
	add	$8, %rsp
	mov	$0, %rax
	ret
