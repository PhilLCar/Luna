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
	mov	%rbp, %rbx
	add	$16, %rbp
	movq	$0, (%rbx)
	movq	$17, 8(%rbx)
	lea	3(, %rbx, 8), %rbx
	lea	string1(%rip), %r10
	lea	2(, %r10, 8), %r10
	lea	string2(%rip), %r11
	lea	2(, %r11, 8), %r11
	mov	%r11, %rsi
	mov	%r10, %rdi
	call	compare
	mov	%rsi, %r10
	push	%r10
	call	print_lua
	call	print_ret
	mov	$0, %rax
	ret


################################################################################
.data

string1:
	.quad	32
	.asciz	"test"
string2:
	.quad	32
	.asciz	"test"
