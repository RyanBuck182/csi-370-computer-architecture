; Assignment 4.4
; Ryan Buck
; Multiplies each element of a WORD array by 8 and stores the results in a DWORD array

extrn ExitProcess : proc ; Prototype for ExitProcess, needed to exit the program later

.data ; Section for variable definition and initialization
array1 WORD 5, 10, 15, 20 ; The array to be processed
array2 DWORD 4 DUP (?) ; The array to store the results
arraySize QWORD 4 ; The number of elements in both arrays

.code ; Section for instructions
_main PROC ; Entry point of the program
sub rsp, 28h ; Reserve shadow space

mov rsi, OFFSET array1 ; Load address of array1 into rsi
mov rdi, OFFSET array2 ; Load address of array2 into rdi
mov rcx, arraySize ; Set loop counter to the number of elements in both arrays

arrayLoop: ; Label for the start of the loop
	; Calculate the current index
	mov rdx, arraySize ; Set rdx to the number of elements in both arrays
	sub rdx, rcx; Subtract the counter (rcx) from the number of elements (rdx) to get the current index
	
	; Take the current element from array1, multiply it by 8, and store it in array2
	movsx eax, WORD PTR [rsi+rdx*2] ; Load the current element of array1 into eax, extending the sign to fill 32 bits
	imul eax, 8 ; Multiply the value in eax by 8
	mov DWORD PTR [rdi+rdx*4], eax ; Store the value from eax into the corresponding element of array2
	
	loop arrayLoop ; Decrement rcx and return to the arrayLoop label unless rcx is 0

xor rcx, rcx ; Set exit code to 0 to indicate success
call ExitProcess ; Exit the program
_main ENDP ; End of _main
END ; End of file
