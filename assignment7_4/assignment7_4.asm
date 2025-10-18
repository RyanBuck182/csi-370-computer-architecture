; Assignment 7.4
; Ryan Buck
; Implements a simple four-character Caeser shift.

extrn ExitProcess : proc

.data
password BYTE "20AssemblyRules20",0
passwordLen EQU ($ - password)
encodedPassword BYTE passwordLen DUP(?)

.code
_main PROC
sub rsp, 28h

lea rsi, password
lea rdi, encodedPassword
mov rcx, passwordLen - 1 ; loop counter, -1 to stop before null terminator
shifting:
	; Load character from password, add 4, and store in encodedPassword
	lodsb
	add al, 4
	stosb

	; Repeats for the length of the password, stops before the null terminator
	dec rcx ; sets zero flag, so no need for cmp
	jnz shifting

mov BYTE PTR [rdi], 0 ; Append null terminator

xor rcx, rcx
call ExitProcess
_main ENDP
END
