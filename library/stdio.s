# File: stdio.s
#
# This file contains some basic functions to do I/O on the standard
# input/output (i.e. stdin and stdout).  The implementation is designed
# to work on linux and OS X without any changes.  The operating system is
# automatically detected and the appropriate system calls are performed.
# This allows portable I/O to be written in assembly language.

# The exported functions are:
#
#  putchar           write single character to stdout
#  getchar           read single character from stdin
#  print_string      print string
#  print_word_hex    print 64 bit integer in hexadecimal
#  print_word_dec    print 64 bit integer in decimal
#  print_rax         print the content of register rax in hexadecimal
#  print_rbx         same for rbx
#  print_rcx         same for rcx
#  print_rdx         same for rdx
#  print_rsi         same for rsi
#  print_rdi         same for rdi
#  print_rbp         same for rbp
#  print_rsp         same for rsp
#  print_r8          same for r8
#  print_r9          same for r9
#  print_r10         same for r10
#  print_r11         same for r11
#  print_r12         same for r12
#  print_r13         same for r13
#  print_r14         same for r14
#  print_r15         same for r15
#  print_rip         same for rip
#  print_regs        print all registers


        .text


# The putchar function sends a single character to the
# standard output (stdout).  The calling convention is
# to push to the stack a word (64 bits) containing the
# character to write, and then to execute a "call putchar".
# When control returns from the function, the stack will
# be back to the state it had before the character was
# pushed.

        .globl putchar
putchar:

        push    %r11
        push    %rbp
        push    %rsi
        push    %rdi
        push    %rdx
        push    %rcx
        push    %rbx

        # determine if OS is linux or OS X

        mov     $-1, %rdi            # parameter of system call is -1
        mov     $13, %rax            # system call number 13 is "time" on linux and a noop on OS X
        syscall                      # perform system call to OS

        cmp     $0, %rax             # negative means error which means linux
        js      write_syscall_linux

write_syscall_osx:
        mov     $0x2000004, %rax     # "write" system call is 0x2000004
        jmp     write_syscall

write_syscall_linux:
        mov     $1, %rax             # "write" system call is 1

write_syscall:
        lea     64(%rsp), %rsi       # get address of character to write
        mov     $1, %rdx             # number of bytes to write = 1
        mov     $1, %rdi             # file descriptor 1 = stdout
        syscall                      # perform system call to OS

        pop     %rbx
        pop     %rcx
        pop     %rdx
        pop     %rdi
        pop     %rsi
        pop     %rbp
        pop     %r11
        ret     $8                   # return and pop parameter


# The getchar function reads a single character from the
# standard input (stdin).  The calling convention is
# to execute a "call getchar".  When control
# returns from the function, the register %rax will
# contain the character (byte) that was read.  The
# value -1 is returned when end-of-file is reached.

        .globl getchar
getchar:

        push    %r11
        push    %rbp
        push    %rsi
        push    %rdi
        push    %rdx
        push    %rcx
        push    %rbx

        # determine if OS is linux or OS X

        mov     $-1, %rdi            # parameter of system call is -1
        mov     $13, %rax            # system call number 13 is "time" on linux and a noop on OS X
        syscall                      # perform system call to OS

        cmp     $0, %rax             # negative means error which means linux
        js      read_syscall_linux

read_syscall_osx:
        mov     $0x2000003, %rax     # "read" system call is 0x2000003
        jmp     read_syscall

read_syscall_linux:
        mov     $0, %rax             # "read" system call is 0

read_syscall:
        push    $0                   # buffer
        lea     0(%rsp), %rsi        # get address of buffer
        mov     $1, %rdx             # number of bytes to read = 1
        mov     $0, %rdi             # file descriptor 0 = stdin
        syscall                      # perform system call to OS

        cmp     $1, %rax             # did we read 1 byte?
        pop     %rax
        jz      getchar1
        mov     $-1, %rax            # indicate end-of-file
getchar1:

        pop     %rbx
        pop     %rcx
        pop     %rdx
        pop     %rdi
        pop     %rsi
        pop     %rbp
        pop     %r11
        ret                          # return


# The print_string function sends a null-terminated string
# of characters to the standard output (stdout).  The calling
# convention is to push to the stack a word (64 bits) containing
# the address of the string to write, and then to execute a
# "call print_string".  When control returns from the function,
# the stack and all the registers will be back to the state they
# had before the string was pushed.

        .globl print_string
print_string:
        pushf
        push    %rax
        push    %rbx
        push    %rcx
        push    %rdx
        push    %rsi
        push    %rdi
        push    %rbp
#       push    %rsp
        push    %r8
        push    %r9
        push    %r10
        push    %r11
        push    %r12
        push    %r13
        push    %r14
        push    %r15

        mov     17*8(%rsp), %rbx   # get the string to print
        mov     $0, %rax

print_string_loop:
        movb    (%rbx), %al
        cmp     $0, %rax
        je      print_string_loop_done
        push    %rax
        call    putchar
        inc     %rbx
        jmp     print_string_loop

print_string_loop_done:

        pop     %r15
        pop     %r14
        pop     %r13
        pop     %r12
        pop     %r11
        pop     %r10
        pop     %r9
        pop     %r8
#       pop     %rsp
        pop     %rbp
        pop     %rdi
        pop     %rsi
        pop     %rdx
        pop     %rcx
        pop     %rbx
        pop     %rax
        popf
        ret     $1*8

print_hex1:
        push    %rax

        mov     2*8(%rsp), %rax
        and     $0x0f, %rax
        cmp     $10, %rax
        jb      print_hex1_putchar
        add     $39, %rax       # adjust for a-f
print_hex1_putchar:
        add     $48, %rax       # offset for 0-9
        push    %rax
        call    putchar

        pop     %rax
        ret     $1*8


# The print_word_hex function sends a hexadecimal integer
# representation of a word to the standard output (stdout).
# The calling convention is to push to the stack the word (64 bits)
# to write, and then to execute a "call print_word_hex".  When
# control returns from the function, the stack and all the registers
# will be back to the state they had before the word was pushed.

        .globl print_word_hex
print_word_hex:
        pushf
        push    %rax
        push    %rbx
        push    %rcx
        push    %rdx
        push    %rsi
        push    %rdi
        push    %rbp
#       push    %rsp
        push    %r8
        push    %r9
        push    %r10
        push    %r11
        push    %r12
        push    %r13
        push    %r14
        push    %r15

        lea     string_0x(%rip), %rax
        push    %rax
        call    print_string

        mov     17*8(%rsp), %rax   # get the number to print
        mov     $16, %rbx

print_word_hex_loop:
        rol     $4, %rax
        push    %rax
        call    print_hex1
        dec     %rbx
        jnz     print_word_hex_loop

        pop     %r15
        pop     %r14
        pop     %r13
        pop     %r12
        pop     %r11
        pop     %r10
        pop     %r9
        pop     %r8
#       pop     %rsp
        pop     %rbp
        pop     %rdi
        pop     %rsi
        pop     %rdx
        pop     %rcx
        pop     %rbx
        pop     %rax
        popf
        ret     $1*8

# The print_word_dec function sends a decimal integer
# representation of a word to the standard output (stdout).
# The calling convention is to push to the stack the word (64 bits)
# to write, and then to execute a "call print_word_dec".  When
# control returns from the function, the stack and all the registers
# will be back to the state they had before the word was pushed.

        .globl print_word_dec
print_word_dec:
        pushf
        push    %rax
        push    %rbx
        push    %rcx
        push    %rdx
        push    %rsi
        push    %rdi
        push    %rbp
#       push    %rsp
        push    %r8
        push    %r9
        push    %r10
        push    %r11
        push    %r12
        push    %r13
        push    %r14
        push    %r15

        mov     17*8(%rsp), %rax   # get the number to print
	# Fais la même chose que le code précédent sans tous les push inutiles
	# qui reviennent à chaque itération
######################################################################################
	cmp	$0, %rax
	jns	print_word_dec_pos
	push	$'-'
	call	putchar
	mov     17*8(%rsp), %rax
	neg	%rax
print_word_dec_pos:
	mov	$1000000000000000000, %rcx
	mov	$10, %rbx
	xor	%rdx, %rdx
	xor	%rsi, %rsi
print_word_dec_loop:
	div	%rcx
	cmp	%rsi, %rax
	je	print_word_dec_new
	mov	$-1, %rsi
	or	$48, %rax
	push	%rax
	call	putchar
print_word_dec_new:
	push	%rdx
	xor	%rdx, %rdx
	mov	%rcx, %rax
	div	%rbx
	cmp	$1, %rax
	je	print_word_dec_end
	mov	%rax, %rcx
	pop	%rax
	jmp	print_word_dec_loop
print_word_dec_end:
	or	$48, (%rsp)
        call    putchar
######################################################################################	
#        cmp     $0, %rax
#        jns     print_word_dec_pos
#print_word_dec_neg:
#        push    $'-'  # -
#        call    putchar
#        mov     17*8(%rsp), %rax   # negate the number to print
#        neg     %rax
#print_word_dec_pos:

#        mov     $0, %rdx
#        mov     $10, %rbx
#        div     %rbx        # rax = rdx::rax / 10, rdx = rdx::rax % 10

#        cmp     $0, %rax
#        jz      print_word_dec_digit

#        push    %rax
#        call    print_word_dec

#print_word_dec_digit:
#        add     $'0', %rdx  # 0..9
#        push    %rdx
#        call    putchar
######################################################################################
        pop     %r15
        pop     %r14
        pop     %r13
        pop     %r12
        pop     %r11
        pop     %r10
        pop     %r9
        pop     %r8
#       pop     %rsp
        pop     %rbp
        pop     %rdi
        pop     %rsi
        pop     %rdx
        pop     %rcx
        pop     %rbx
        pop     %rax
        popf
        ret     $1*8

print_word_reg:
        push    %rax

        mov     2*8(%rsp), %rax
        push    %rax
        call    print_string

        lea     string_eq(%rip), %rax
        push    %rax
        call    print_string

        mov     3*8(%rsp), %rax
        push    %rax
        call    print_word_hex

        lea     string_lf(%rip), %rax
        push    %rax
        call    print_string

        pop     %rax
        ret     $2*8


# The print_rax, print_rbx, etc functions send a hexadecimal integer
# representation of the content of a register to the standard output
# (stdout).  The calling convention is to execute a "call print_rax"
# (or "call print_rbx", etc).  When control returns from the function,
# the stack and all the registers will be back to the state they had
# before the call was executed.

        .globl print_rax
print_rax:
        push    %rax
        push    %rax
        lea     string_rax(%rip), %rax
        push    %rax
        call    print_word_reg
        pop     %rax
        ret

        .globl print_rbx
print_rbx:
        push    %rax
        push    %rbx
        lea     string_rbx(%rip), %rax
        push    %rax
        call    print_word_reg
        pop     %rax
        ret

        .globl print_rcx
print_rcx:
        push    %rax
        push    %rcx
        lea     string_rcx(%rip), %rax
        push    %rax
        call    print_word_reg
        pop     %rax
        ret

        .globl print_rdx
print_rdx:
        push    %rax
        push    %rdx
        lea     string_rdx(%rip), %rax
        push    %rax
        call    print_word_reg
        pop     %rax
        ret

        .globl print_rsi
print_rsi:
        push    %rax
        push    %rsi
        lea     string_rsi(%rip), %rax
        push    %rax
        call    print_word_reg
        pop     %rax
        ret

        .globl print_rdi
print_rdi:
        push    %rax
        push    %rdi
        lea     string_rdi(%rip), %rax
        push    %rax
        call    print_word_reg
        pop     %rax
        ret

        .globl print_rbp
print_rbp:
        push    %rax
        push    %rbp
        lea     string_rbp(%rip), %rax
        push    %rax
        call    print_word_reg
        pop     %rax
        ret

        .globl print_rsp
print_rsp:
        push    %rax
        lea     2*8(%rsp), %rax
        push    %rax
        lea     string_rsp(%rip), %rax
        push    %rax
        call    print_word_reg
        pop     %rax
        ret

        .globl print_r8
print_r8:
        push    %rax
        push    %r8
        lea     string_r8(%rip), %rax
        push    %rax
        call    print_word_reg
        pop     %rax
        ret

        .globl print_r9
print_r9:
        push    %rax
        push    %r9
        lea     string_r9(%rip), %rax
        push    %rax
        call    print_word_reg
        pop     %rax
        ret

        .globl print_r10
print_r10:
        push    %rax
        push    %r10
        lea     string_r10(%rip), %rax
        push    %rax
        call    print_word_reg
        pop     %rax
        ret

        .globl print_r11
print_r11:
        push    %rax
        push    %r11
        lea     string_r11(%rip), %rax
        push    %rax
        call    print_word_reg
        pop     %rax
        ret

        .globl print_r12
print_r12:
        push    %rax
        push    %r12
        lea     string_r12(%rip), %rax
        push    %rax
        call    print_word_reg
        pop     %rax
        ret

        .globl print_r13
print_r13:
        push    %rax
        push    %r13
        lea     string_r13(%rip), %rax
        push    %rax
        call    print_word_reg
        pop     %rax
        ret

        .globl print_r14
print_r14:
        push    %rax
        push    %r14
        lea     string_r14(%rip), %rax
        push    %rax
        call    print_word_reg
        pop     %rax
        ret

        .globl print_r15
print_r15:
        push    %rax
        push    %r15
        lea     string_r15(%rip), %rax
        push    %rax
        call    print_word_reg
        pop     %rax
        ret

        .globl print_rip
print_rip:
        push    %rax
        mov     1*8(%rsp), %rax
        push    %rax
        lea     string_rip(%rip), %rax
        push    %rax
        call    print_word_reg
        pop     %rax
        ret

string_lf:  .asciz "\n"
string_eq:  .asciz " = "
string_0x:  .asciz "0x"
string_rax: .asciz "rax"
string_rbx: .asciz "rbx"
string_rcx: .asciz "rcx"
string_rdx: .asciz "rdx"
string_rsi: .asciz "rsi"
string_rdi: .asciz "rdi"
string_rbp: .asciz "rbp"
string_rsp: .asciz "rsp"
string_r8:  .asciz "r8 "
string_r9:  .asciz "r9 "
string_r10: .asciz "r10"
string_r11: .asciz "r11"
string_r12: .asciz "r12"
string_r13: .asciz "r13"
string_r14: .asciz "r14"
string_r15: .asciz "r15"
string_rip: .asciz "rip"


# The print_regs function sends a hexadecimal integer representation
# of the content of all the registers to the standard output (stdout).
# The calling convention is to execute a "call print_regs".
# When control returns from the function, the stack and all the registers
# will be back to the state they had before the call was executed.

        .globl print_regs
print_regs:
        push    %rax
        lea     string_lf(%rip), %rax
        push    %rax
        call    print_string
        pop     %rax

        call    print_rax
        call    print_rbx
        call    print_rcx
        call    print_rdx
        call    print_rsi
        call    print_rdi
        call    print_rbp
        push    %rax
        lea     2*8(%rsp), %rax
        push    %rax
        lea     string_rsp(%rip), %rax
        push    %rax
        call    print_word_reg
        pop     %rax
        call    print_r8
        call    print_r9
        call    print_r10
        call    print_r11
        call    print_r12
        call    print_r13
        call    print_r14
        call    print_r15
        jmp     print_rip
