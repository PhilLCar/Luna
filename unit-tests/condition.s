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
	pop	%rsi
	mov	$1, %rdi
	call	stack
	mov	$9, %rsi
	cmp	$1, %rsi
	jz	else1
	cmp	$17, %rsi
	jz	else1
	lea	(%rsp), %rsi
	push	%rsi
	push	$17
	mov	%rsp, %r10
	movq	$4, (%rbp)
	movq	$24, 8(%rbp)
	movq	$17, 16(%rbp)
	lea	4(, %rbp, 8), %rsi
	mov	%rsi, (%r10)
	lea	16(%rbp), %r10
	add	$24, %rbp
	pop	%rsi
	mov	$1, %rdi
	call	place
	jmp	iend1
else1:
	lea	(%rsp), %rsi
	push	%rsi
	push	$17
	mov	%rsp, %r10
	mov	$24, %rsi
	neg	%rsi
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
iend1:
	push	(%rsp)
	call	print_lua
	call	print_ret
	mov	$0, %rax
	ret
