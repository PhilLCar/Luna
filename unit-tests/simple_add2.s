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
	mov	$24, %rbx
	mov	$24, %r11
	add	$32, %r11
	add	$40, %r11
	add	%rbx, %r11
	mov	%r11, %r10
	push	%r10
	call	print_lua
	call	print_ret
	mov	$0, %rax
	ret
