	.text
# Fonctions utiles à la compilation, pour alléger le compilateur
	.global compare
compare:
	mov	%rsi, %rcx
	and	$7, %rcx
	cmp	$2, %rcx
	jz	comp_string
	cmp	%rsi, %rdi
	jz	res_t
	mov	$1, %rsi
	ret
res_t:	mov	$9, %rsi
	ret

comp_string:
	sar	$3, %rsi
	sar	$3, %rdi
	add	$8, %rsi
	add	$8, %rdi
cp_lp:	xor	%rcx, %rcx
	mov	(%rdi), %cl
	cmp	(%rsi), %cl
	jnz	cp_f
	cmp	$0, %cl
	jz	cp_t
	cmpl	$0, (%rsi)
	jz	cp_f
	inc	%rsi
	inc	%rdi
	jmp	cp_lp
cp_f:	mov	$1, %rsi
	ret
cp_t:	cmpl	$0, (%rsi)
	jnz	cp_f
	mov	$9, %rsi
	ret
