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
	lea	string1(%rip), %rbx
	lea	2(, %rbx, 8), %rbx
	push	%rbx
	call	print_lua
	call	print_ret
	mov	$0, %rax
	ret


################################################################################
.data

string1:
	.asciz	"test"
