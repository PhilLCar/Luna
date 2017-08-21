# File: mmap.s
#
# This file contains an interface to the operating system's memory
# allocation function mmap which allows the allocation of large
# blocks of memory. The implementation is designed to work on linux
# and OS X without any changes.  The operating system is automatically
# detected and the appropriate system calls are performed.
# This allows portable memory allocation to be written in assembly language.

        .text


# The mmap function allocates a block of memory in the virtual
# memory of the process.  The calling convention is
# to push to the stack a word (64 bits) containing the
# length of the block to allocate, and then to execute a "call mmap".
# When control returns from the function, the stack will
# be back to the state it had before the length was
# pushed and %rax contains a pointer to the allocated block.
# The operating system will round up the length of the block
# to a multiple of the page size, which is typically 4096 bytes or more.
# The returned address will be a multiple of the page size.

        .globl mmap
mmap:

        push    %r8
        push    %r9
        push    %r10
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
        js      mmap_syscall_linux

mmap_syscall_osx:
        mov     $0x20000c5, %rax     # "mmap" system call is 0x20000c5
        mov     $0x1002, %rcx        # rcx = MAP_PRIVATE | MAP_ANON
        jmp     mmap_syscall

mmap_syscall_linux:
        mov     $9, %rax             # "mmap" system call is 9
        mov     $0x22, %rcx          # rcx = MAP_PRIVATE | MAP_ANON

mmap_syscall:
        mov     $0, %rdi             # rdi = address
        mov     88(%rsp), %rsi       # rsi = block length
        mov     $7, %rdx             # rdx = PROT_READ | PROT_WRITE | PROT_EXEC
        mov     $-1, %r8             # r8 = file descriptor (-1 = none)
        mov     $0, %r9              # r9 = offset
        mov     %rcx, %r10           # r10 = rcx (unclear why this is needed)
        syscall                      # perform system call to OS

        pop     %rbx
        pop     %rcx
        pop     %rdx
        pop     %rdi
        pop     %rsi
        pop     %rbp
        pop     %r11
        pop     %r10
        pop     %r9
        pop     %r8
        ret     $8                   # return and pop parameter

        .globl end_mmap
end_mmap:

