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
	mov	$8, %rbx
	sub	$16, %rbx
	push	%rbx
	call	print_lua
	call	print_ret
	mov	$0, %rax
	ret
