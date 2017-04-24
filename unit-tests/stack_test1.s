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
	push	$8
	push	$17
	push	$17
	push	8(%rsp)
	call	print_lua
	call	print_ret
	add	$24, %rsp
	mov	$0, %rax
	ret
