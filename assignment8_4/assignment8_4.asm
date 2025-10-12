; Assignment 8.4
; Ryan Buck
; Normalizes a 2d and a 3d vector.

extrn ExitProcess : proc

.data
ALIGN 16
; Vectors
; vector2d should normalize to 0.81, 0.58
; vector3d Should normalize to 0.89, 0.43, 0.13
vector2d REAL8 4.3, 3.1
vector3d REAL8 10.2, 4.9, 1.5, 0.0 ; extra 0 was appended to make it a full 256 bits

; Results
result2d REAL8 2 DUP(?)
result3d REAL8 4 DUP(?)

.code
_main PROC
sub rsp, 28h

; Load vector2d
movapd xmm0, [vector2d]

; Calculate length of vector2d
movapd xmm1, xmm0
mulpd xmm1, xmm1 ; x^2, y^2
haddpd xmm1, xmm1 ; x^2 + y^2, x^2 + y^2
sqrtpd xmm1, xmm1 ; sqrt(x^2 + y^2), sqrt(x^2 + y^2)

; Normalize vector2d
divpd xmm0, xmm1
movapd [result2d], xmm0

; Load vector3d
vmovupd ymm0, [vector3d]

; Calculate length of vector3d
vmovapd ymm1, ymm0
vmulpd ymm1, ymm1, ymm1 ; x^2, y^2, z^2, 0
vhaddpd ymm1, ymm1, ymm1 ; x^2 + y^2, x^2 + y^2, z^2 + 0, z^2 + 0
vperm2f128 ymm2, ymm1, ymm1, 1 ; z^2 + 0, z^2 + 0, x^2 + y^2, x^2 + y^2 in ymm2
vaddpd ymm1, ymm1, ymm2 ; x^2 + y^2 + z^2 + 0 in each slot of ymm1
vsqrtpd ymm1, ymm1 ; sqrt(x^2 + y^2 + z^2 + 0) in each slot of ymm1

; Normalize vector3d
vdivpd ymm0, ymm0, ymm1
vmovapd [result3d], ymm0

xor rcx, rcx
call ExitProcess
_main ENDP
END
