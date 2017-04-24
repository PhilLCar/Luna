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
	push	$16
	push	$24
	push	$32
	add	$8, %rsp
	push	8(%rsp)
	call	print_lua
	call	print_ret
	add	$24, %rsp
	mov	$0, %rax
	ret
