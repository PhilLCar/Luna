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
	mov	$8, %r10
	mov	$16, %rsi
	mov	%r10, %rdi
	call	compare
	mov	%rsi, %r10
	xor	$8, %r10
	cmp	$1, %r10
	jz	else1
	cmp	$17, %r10
	jz	else1
	push	$17
	mov	%rsp, %r10
	mov	$8, %r11
	mov	$16, %rsi
	mov	%r11, %rdi
	call	compare
	mov	%rsi, %r11
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
	push	(%rsp)
	call	print_lua
	call	print_ret
	add	$8, %rsp
else1:
iend1:
	mov	$0, %rax
	ret
