extrn ExitProcess : proc

.data
letter DB ?
r DD ?
s DD ?
t DD ?
x DW ?
y DW ?
z DW ?

.code
_main PROC
sub rsp, 28h

mov letter, 77h
mov r, 5h
mov s, 2h
mov x, 0Ah
mov y, 4h

mov ax, x
add ax, y
mov z, ax

mov ax, x
sub ax, y
mov z, ax

mov edx, 0h
mov eax, r
mov ecx, s
div ecx
mov t, eax

mov edx, 0h
mov eax, r
mov ecx, s
div ecx
mov t, edx

xor rcx, rcx
call ExitProcess
_main ENDP
END
