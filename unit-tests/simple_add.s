	.text
	.global	_main
	.global	main
_main:
main:
	mov	$16, %rbx
	add	$24, %rbx
	push	%rbx
	call	print_lua
	call	print_ret
	mov	$0, %rax
	ret
