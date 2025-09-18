.data

.bss
.lcomm letter, 1
.lcomm r, 4
.lcomm s, 4
.lcomm t, 4
.lcomm x, 2
.lcomm y, 2
.lcomm z, 2

.text
.global _main
_main:

movb $0x77, letter(%rip)
movl $0x5, r(%rip)
movl $0x2, s(%rip)
movw $0xa, x(%rip)
movw $0x4, y(%rip)

movw x(%rip), %ax
addw y(%rip), %ax
movw %ax, z(%rip)

movw x(%rip), %ax
subw y(%rip), %ax
movw %ax, z(%rip)

movl $0x0, %edx
movl r(%rip), %eax
movl s(%rip), %ecx
divl %ecx
movl %eax, t(%rip)

movl $0x0, %edx
movl r(%rip), %eax
movl s(%rip), %ecx
divl %ecx
movl %edx, t(%rip)

mov $0x2000001, %rax
xor %rdi, %rdi
syscall
.end
