; Assignment 6.4
; Ryan Buck
; Sorts an array using merge sort.

extrn ExitProcess : proc

.data
; Test Arrays
array BYTE 3, 2, 4, 5, 1
; array BYTE 1, 2, 3, 4, 5
; array BYTE 5, 4, 3, 2, 1
; array BYTE 5 DUP (0)
; array BYTE -4, 3, -1, 1, 5, 2, -5, -2, -3, 4
; array BYTE -5, -4, -3, -2, -1, 1, 2, 3, 4, 5
; array BYTE 5, 4, 3, 2, 1, -1, -2, -3, -4, -5
; array BYTE 10 DUP (0)
; array BYTE 28, 3, 93, 49, 91, 59, 51, 61, 75, 78, 55, 61, 13, 43, 64, 6, 82,
             80, 3, 54, -57, 99, 33, 48, 45, 12, 95, -15, 10, 9, 67, 36, 9, 75

len EQU ($ - array)

.code
_main PROC
sub rsp, 28h

lea rcx, array
mov rdx, len
call _sort

xor rcx, rcx
call ExitProcess
_main ENDP

; Sorts a byte array
; Arguments:
;   The address of the byte array
;   The length of the array
_sort PROC
push rbp
mov rbp, rsp
sub rsp, 28h

; Call mergesort with 0 as start index and length as stop index
mov r8, rdx
mov rdx, 0
call _mergesort

mov rsp, rbp
pop rbp
ret
_sort ENDP

; Sorts a byte array using merge sort
; Arguments:
;   The address of the byte array
;   The start index
;   The stop index (exclusive)
_mergesort PROC
push rbp
mov rbp, rsp
sub rsp, 28h

; Get the length of the range
mov r10, r8
sub r10, rdx

; If length is 1, there's nothing to sort
cmp r10, 1
je mergesort_done

; Divide length by 2
push rdx
mov rdx, 0
mov rax, r10
mov r11, 2
idiv r11
pop rdx

; Get midpoint of the range
mov r11, rax
add r11, rdx

; Mergesort left half
push rdx
push r8
push r10
push r11
mov r8, r11
call _mergesort
pop r11
pop r10
pop r8
pop rdx

; Mergesort right half
push rdx
push r8
push r10
push r11
mov rdx, r11
call _mergesort
pop r11
pop r10
pop r8
pop rdx

; Merge the two halves
mov r9, r8
push rdx
push r8
push r10
push r11
mov r8, r11
call _merge
pop r11
pop r10
pop r8
pop rdx

mergesort_done:
mov rsp, rbp
pop rbp
ret
_mergesort ENDP

; Merges two sorted ranges of elements in a byte array into a single sorted range
; Arguments:
;   The address of the byte array
;   The start index of the first range
;   The start index of the second range
;   The end index of the second range (exclusive)
_merge PROC
push rbp
push rbx
mov rbp, rsp
sub rsp, 28h

; Midpoint cursor
mov rbx, r8

merge:
    ; Load the current elements from left and right cursor
    mov r10b, [rcx + rdx]
    mov r11b, [rcx + r8]

    ; If the left element is greater than the right element, insert the right
    ; element where the left element is, otherwise move to the next left element
    cmp r10b, r11b
    jle no_insert
    
    ; Insert the element at the source index into the destination index, shifting
    ; everything in between to the right
    ; Also move every cursor right
    push r8
    push r9
    call _insert
    pop r9
    pop r8
    inc rbx
    inc r8

    ; Don't insert, simply move the left cursor to the next element
    no_insert:
    inc rdx

    ; If left cursor is past the midpoint or right cursor is past end, the range
    ; is merged
    cmp rdx, rbx
    jge merge_done
    cmp r8, r9
    jge merge_done
    jmp merge

merge_done:
mov rsp, rbp
pop rbx
pop rbp
ret
_merge ENDP

; Insert the element at the source index into the destination index, shifting
; everything in between to the right
; Arguments:
;   The address of the byte array
;   The destination index
;   The source index
_insert PROC
; Store	the value at the source index
mov r9b, [rcx + r8]

; Shift the elements to the right
shift:
    ; Move current index left
    dec r8

    ; Move element at current index to the right	
    mov al, [rcx + r8]
    mov [rcx + r8 + 1], al
    
    ; If current index is to the right of the destination index, keep shifting 
    cmp r8, rdx
    jg shift

; Insert source value into destination index
mov [rcx + rdx], r9b

ret
_insert ENDP

END