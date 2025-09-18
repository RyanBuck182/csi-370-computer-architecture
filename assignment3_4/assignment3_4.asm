; Assignment 3
; Ryan Buck
; Calculates the expression: answer = (A + B) - (C + D)
; I use A = 2, B = 4, C = 1, and D = -4, so the answer should be 9

extrn ExitProcess : proc ; Prototype for ExitProcess, needed to exit the program later

.data ; Section for variable definition and initialization
answer DB ? ; Will store the answer to the expression
msg DB "The answer is ",0 ; String that could be used in an output statement

.code ; Section for instructions
_main PROC ; Entry point of the program
sub rsp, 28h ; Reserve shadow space

; Load expression values into registers
; A = 2, B = 4, C = 1, and D = -4
mov al, 2 ; Load value for A into the al register
mov bl, 4 ; Load value for B into the bl register
mov cl, 1 ; Load value for C into the cl register
mov dl, -4 ; Load value for D into the dl register

add al, bl ; Add A and B, storing the result in al, should be 6
add cl, dl ; Add C and D, storing the result in cl, should be -3
sub al, cl ; Subtract (A + B) and (C + D), storing the result in al, should be 9
mov answer, al ; Store the result from al in answer

xor rcx, rcx ; Set exit code to 0 to indicate success
call ExitProcess ; Exit the program
_main ENDP ; End of _main
END ; End of file
