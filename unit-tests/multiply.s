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
	mov	$16, %r10
	imul	$24, %r10
	sar	$3, %r10
	imul	$32, %r10
	sar	$3, %r10
	push	%r10
	call	print_lua
	call	print_ret
	mov	$0, %rax
	ret
