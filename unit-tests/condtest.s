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
	mov	$8, %r10
	mov	$16, %rsi
	mov	%r10, %rdi
	call	compare
	mov	%rsi, %r10
	push	%r10
	push	(%rsp)
	call	print_lua
	call	print_ret
	add	$8, %rsp
else1:
iend1:
	mov	$0, %rax
	ret
