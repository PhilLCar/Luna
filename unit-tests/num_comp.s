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
	mov	$8, %rsi
	mov	%r10, %rdi
	call	compare
	mov	%rsi, %r10
	push	%r10
	call	print_lua
	call	print_ret
	mov	$0, %rax
	ret
