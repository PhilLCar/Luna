# File: exio.s
#
# Contient des fonctions standard pour l'I/O de data lua

	.text

	.globl print_lua
	.globl print_ret

#print ret imprime le retour de chariot
print_ret:
	push	%rax
	push	$'\n'
	call	putchar
	pop	%rax
	ret

#print lua choisi quelle fonction utiliser en fonction du type

print_lua:
	pushf
	push	%rax
	mov	24(%rsp), %rax
	and	$7, %rax
	jz	print_int
	cmp	$1, %rax
	jz	print_special
	cmp	$2, %rax
	jz	print_str
	cmp	$3, %rax
	jz	print_table
##### not printable #####
#	cmp	$4, %rax
#	jz	print_pair
#########################
#	cmp	$5, %rax
#	jz	print_io
#	cmp	$6, %rax
#	jz	print_scmpair
#	cmp	$7, %rax
#	jz	print_scmproc
	#	jmp	print_void
	pop	%rax
	popf
	ret	$8

# print_scmint fonction envoie une représentation décimale d'un entier scheme.
# (les trois bits de gauche servent à identifier le type)

print_int:

	mov	24(%rsp), %rax
	sar	$3, %rax
	push	%rax
	call	print_word_dec

	pop     %rax
	popf
	ret     $8	#Return and pop parameter


# print_scmbool fonction qui envoie #t, ou #f à stdout
# Un mot contenant la valeur 1 est true, la valeur 9 est false

print_special:

	mov	24(%rsp), %rax		#Gets the bool value
	cmp	$1, %rax		#The literal value 1 is false
	je	print_bool_false
	cmp	$9, %rax
	je	print_bool_true
	
################################################
	# Check for special values here!
print_nil:
	lea	string_nil(%rip), %rax
	push	%rax
	call	print_string
	jmp	print_special_end
################################################
	
print_bool_true:
	lea	string_true(%rip), %rax
	push	%rax
	call 	print_string
	jmp 	print_special_end
	
print_bool_false:
	lea	string_false(%rip), %rax
	push	%rax
	call 	print_string
	
print_special_end:
        pop     %rax
        popf
        ret     $8    #Return and pop parameter

# print_str permet d'imprimer un string situé dans le heap

print_str:

	mov	24(%rsp), %rax
	sar	$3, %rax
	add	$8, %rax
	push	%rax
	call	print_string
	pop	%rax
	popf
	ret	$8

print_table:
	lea	string_table(%rip), %rax
	push	%rax
	call 	print_string
	mov	24(%rsp), %rax
	sar	$3, %rax
	push	%rax
	call	print_word_hex
	pop	%rax
	popf
	ret	$8

#print_func:
#	lea	string_proc(%rip), %rax
#	push	%rax
#	call	print_string
#	mov	24(%rsp), %rax
#	sar	$3, %rax
#	mov	(%rax), %rax
#	push	2(%rax)
#	call	print_word_dec
#	push	$'>'
#	call	putchar
#	pop	%rax
#	popf
#	ret	$8

############################################################################
.data

string_false:
	.asciz	"false"
string_true:
	.asciz	"true"
string_nil:
	.asciz	"nil"

string_table:
	.asciz	"table: " 
	
