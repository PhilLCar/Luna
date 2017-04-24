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
	lea	string1(%rip), %r10
	lea	2(, %r10, 8), %r10
	push	%r10
	push	(%rsp)
	call	print_lua
	call	print_ret
	add	$8, %rsp
	mov	$0, %rax
	ret


################################################################################
.data

string1:
	.quad	32
	.asciz	"test"
