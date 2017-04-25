	.text
	.global	_main
	.global	main
_main:
main:
	push	$0
	push	$3
	push	$8
	pop	%rax
	push	(%rsp)
	call	print_word_dec
	push	$'\n'
	call	putchar
	pop	%rax
	pop	%rax
	ret


################################################################################
.data

string1:
	.quad	32
	.asciz	"test"
