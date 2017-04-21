	.text
	.global	_main
	.global	main
_main:
main:
	mov	$24, %rbx
	mov	$24, %r10
	add	$32, %r10
	add	$40, %r10
	add	%rbx, %r10
	mov	%r10, %rbp
	push	%rbp
	call	print_lua
	call	print_ret
	mov	$0, %rax
	ret
