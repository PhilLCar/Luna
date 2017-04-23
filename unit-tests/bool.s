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
	mov	$1, %rbx
	mov	%rbx, %r10
	cmp	$1, %r10
	jz	not1
	mov	$1, %r10
	jmp	nt1
not1:	mov	$9, %r10
nt1:	mov	%r10, %rbx
	push	%rbx
	call	print_lua
	call	print_ret
	mov	$0, %rax
	ret
