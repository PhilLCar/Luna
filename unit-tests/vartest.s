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
	mov	$0, %r8
	call	var
	lea	(%rsi), %rsi
	push	%rsi
	push	$17
	mov	%rsp, %r10
	movq	$4, (%rbp)
	movq	$40, 8(%rbp)
	movq	$17, 16(%rbp)
	lea	4(, %rbp, 8), %rsi
	mov	%rsi, (%r10)
	lea	16(%rbp), %r10
	add	$24, %rbp
	pop	%rsi
	mov	$1, %rdi
	call	place
	mov	$0, %r8
	call	var
	push	(%rsi)
	call	print_lua
	call	print_ret
	mov	$0, %rax
	ret
