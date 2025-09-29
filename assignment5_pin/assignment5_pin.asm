; Assignment 5 Pin
; Ryan Buck
; Determines if a pin is valid or not based on the minimum and maximum for each digit.

extrn ExitProcess : proc ; Prototype for ExitProcess, needed to exit the program later

.data ; Section for variable definition and initialization
pinLen BYTE 4 ; Stores the number of digits in the pin (each digit is a byte)
pinMinimums BYTE 3, 1, 7, 2 ; Array of minimum valid values for each digit
pinMaximums BYTE 6, 4, 9, 5 ; Array of maximum valid values for each digit
result BYTE ? ; Stores the result: 1 is valid, 0 is invalid

; Test Cases
pinDigits BYTE 4, 2, 8, 5 ; Array of pin digits (valid)
; pinDigits BYTE 1, 2, 3, 4 ; Array of pin digits (invalid)
; pinDigits BYTE 6, 4, 9, 5 ; Array of pin digits (valid, maximums)
; pinDigits BYTE 7, 5, 10, 6 ; Array of pin digits (invalid, 1 above maximums)
; pinDigits BYTE 3, 1, 7, 2 ; Array of pin digits (valid, minimums)
; pinDigits BYTE 2, 0, 6, 1 ; Array of pin digits (invalid, 1 below minimums)
; pinDigits BYTE 7, 4, 9, 5 ; Array of pin digits (invalid at the first digit)
; pinDigits BYTE 6, 4, 9, 6 ; Array of pin digits (invalid at the last digit)

.code ; Section for instructions
_main PROC ; Entry point of the program
sub rsp, 28h ; Reserve shadow space

mov result, 1 ; Assume pin is valid until proven otherwise
mov rdx, 0 ; Index of the digit to be checked
validate: ; Label for the start of the pin validation loop
	lea rsi, pinMaximums ; Load address of pin maximums array
	mov al, [rsi + rdx] ; Load maximum value for current digit

	lea rsi, pinMinimums ; Load address of pin minimums array
	mov bl, [rsi + rdx] ; Load minimum value for current digit

	lea rsi, pinDigits ; Load address of pin digits array
	mov cl, [rsi + rdx] ; Load current digit

	cmp cl, al ; Compare maximum value with digit
	jg invalid ; If digit is greater than maximum, pin is invalid
	
	cmp cl, bl ; Compare minimum value with digit
	jl invalid ; If digit is less than minimum, pin is invalid
	
	inc rdx ; Increment digit index
	cmp dl, pinLen  ; Compare digit index with pin length
	jge done ; If index is past the end of the pin digits, exit loop
	jmp validate ; Repeat validation for next digit
invalid: ; Label for invalid pin
	mov result, 0 ; Set result to 0 (invalid)
done: ; Label for end of pin validation

xor rcx, rcx ; Set exit code to 0 to indicate success
call ExitProcess ; Exit the program
_main ENDP ; End of _main
END ; End of file
