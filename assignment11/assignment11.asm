; Assignment 11
; Ryan Buck
; Copies a readonly file and makes it writeable.

extrn ExitProcess : proc
extrn CreateFileA : proc
extrn ReadFile: proc
extrn WriteFile: proc
extrn CloseHandle: proc
extrn MessageBoxA : proc

.data
sourceFile BYTE "sourceFile.txt",0
destFile BYTE "destFile.txt",0
sourceFD QWORD ?
destFD QWORD ?

numBytesRead QWORD ?
buffer BYTE 32 DUP(0)
bufferLen EQU ($ - buffer)

confirmationText BYTE "Your file has been copied successfully.",0
confirmationWindowTitle BYTE "Copy Successful",0

.code
_main PROC
sub rsp, 10h ; reserve for return and rbp
sub rsp, 18h ; reserve for parameters
sub rsp, 20h ; reserve shadow space

; Open the source file
lea rcx, sourceFile ; file name
mov rdx, 80000000h ; open with read access
mov r8, 0 ; no share
mov r9, 0 ; no security
mov QWORD PTR [rsp + 20h], 3 ; open existing file
mov QWORD PTR [rsp + 28h], 80h ; normal file attributes
mov QWORD PTR [rsp + 30h], 0 ; no template
call CreateFileA
mov sourceFD, rax ; save file handle

; Create the destination file
lea rcx, destFile ; file name
mov rdx, 10000000h ; open with all access
mov r8, 0 ; no share
mov r9, 0 ; no security
mov QWORD PTR [rsp + 20h], 2 ; always create (if already exists, delete all contents)
mov QWORD PTR [rsp + 28h], 80h ; normal file attributes
mov QWORD PTR [rsp + 30h], 0 ; no template
call CreateFileA
mov destFD, rax ; save file handle

; Copy the contents from the source to the destination
copy_contents:
	; Read from source
	mov rcx, sourceFD ; source file
	lea rdx, buffer ; buffer address
	mov r8, bufferLen ; num bytes to read
	lea r9, numBytesRead ; num bytes that were read
	mov QWORD PTR [rsp + 20h], 0 ; no overlap
	call ReadFile

	; Write to destination
	mov rcx, destFD ; destination file
	lea rdx, buffer ; buffer address
	mov r8, numBytesRead ; num bytes to write
	mov r9, 0 ; ignore num bytes written
	mov QWORD PTR [rsp + 20h], 0 ; no overlap
	call WriteFile

	; Stop looping if the number of bytes is less than the buffer length
	mov rbx, numBytesRead
	cmp rbx, bufferLen
	jae copy_contents

; Close both file handles
mov rcx, SourceFD
call CloseHandle
mov rcx, DestFD
call CloseHandle

; Show confirmation message box
mov rcx, 0 ; no owner
lea rdx, confirmationText
lea r8, confirmationWindowTitle
mov r9, 0 ; ok button
call MessageBoxA

xor rcx, rcx
call ExitProcess
_main ENDP
END