TITLE

; Name: Yumna Sumya
; Date: Sun, Oct 5, 2025
; ID: 110144390
; Description: code to compute the expression Z = (A - B) - (C - D)

INCLUDE Irvine32.inc
INCLUDELIB Irvine32.lib

; these two lines are only necessary if you're not using Visual Studio
INCLUDELIB kernel32.lib
INCLUDELIB user32.lib

.data
	; data declarations go here

A SDWORD -543210        ; 32-bit signed integer (initialized)
B SWORD  -3210          ; 16-bit signed integer (initialized)
C SDWORD ?              ; 32-bit signed integer (input from user)
D SBYTE  ?              ; 8-bit signed integer  (input from user)
Z SDWORD ?              ; 32-bit signed integer (result)

; Message strings (zero-terminated)

msgPromptC BYTE "What is the value of C? ",0
msgPromptD BYTE "What is the value of D? ",0
msgExpr    BYTE "Z = (A - B) - (C - D)",0
msgA       BYTE "A = ",0
msgB       BYTE "B = ",0
msgC       BYTE "C = ",0
msgD       BYTE "D = ",0
newline    BYTE 0Dh,0Ah,0    ; CR LF NUL

; Headings for outputs
msgBin  BYTE "Z in Binary: ",0
msgDec  BYTE "Z in Decimal: ",0
msgHex  BYTE "Z in Hexadecimal: ",0


.code
main PROC
	
 ; Read user input for C

    mov edx, OFFSET msgPromptC   ; EDX = address of prompt for C
    call WriteString             ; print "What is the value of C? "
    call ReadInt                 ; read a signed 32-bit integer into EAX
    mov C, eax					 ; store EAX into C (32-bit)

    ; echo the value just read
    mov edx, OFFSET msgC         ; EDX = address of "C = "
    call WriteString             ; print label
    mov eax, C                ; EAX = C
    call WriteInt                ; print integer in EAX
    mov edx, OFFSET newline
    call WriteString             ; print newline


    ; Read user input for D (8-bit)

    mov edx, OFFSET msgPromptD   ; EDX = address of prompt for D
    call WriteString             ; print "What is the value of D? "
    call ReadInt                 ; read a signed 32-bit integer into EAX
                                 ; (we will store only the low 8 bits into varD)
    mov D, al                 ; store AL (lowest 8 bits) into varD (SBYTE)
                                 ; note: this truncates to 8 bits intentionally

    ; echo the value of D with sign-extension
    mov edx, OFFSET msgD         ; EDX = address of "D = "
    call WriteString             ; print label
    movsx eax, D                 ; sign-extend D (8-bit) into EAX (32-bit)
    call WriteInt                ; print the extended integer
    mov edx, OFFSET newline
    call WriteString             ; print newline


    ; Display the expression heading

    mov edx, OFFSET msgExpr
    call WriteString
    mov edx, OFFSET newline
    call WriteString

    ; Display all variables A, B, C, D (each on its own line)

    ; Display A
    mov edx, OFFSET msgA
    call WriteString
    mov eax, A
    call WriteInt
    mov edx, OFFSET newline
    call WriteString

    ; Display B
    mov edx, OFFSET msgB
    call WriteString
    ; B is 16-bit (SWORD). Sign-extend to EAX before printing:
    movsx eax, B
    call WriteInt
    mov edx, OFFSET newline
    call WriteString

    ; Display C
    mov edx, OFFSET msgC
    call WriteString
    mov eax, C
    call WriteInt
    mov edx, OFFSET newline
    call WriteString

    ; Display D (already sign-extended when printed above, but show again)
    mov edx, OFFSET msgD
    call WriteString
    movsx eax, D
    call WriteInt
    mov edx, OFFSET newline
    call WriteString


    ; Compute Z = (A - B) - (C - D)

    mov eax, A           	; EAX = A
    movsx ebx, B            ; EBX = sign-extended B (16-bit -> 32-bit)
    sub eax, ebx            ; EAX = A - B

    mov ecx, C           	; ECX = C
    movsx edx, D         	; EDX = sign-extended D (8-bit -> 32-bit)
    sub ecx, edx            ; ECX = C - D

    sub eax, ecx            ; EAX = (A - B) - (C - D)
    mov Z, eax           	; store result in Z


    ; Display Z in Binary, Decimal, Hex

    mov edx, OFFSET msgBin
    call WriteString
    mov eax, Z
    call WriteBin            ; prints binary representation of EAX
    mov edx, OFFSET newline
    call WriteString

    mov edx, OFFSET msgDec
    call WriteString
    mov eax, Z
    call WriteInt            ; prints decimal representation of EAX
    mov edx, OFFSET newline
    call WriteString

    mov edx, OFFSET msgHex
    call WriteString
    mov eax, Z
    call WriteHex            ; prints hexadecimal representation of EAX
    mov edx, OFFSET newline
    call WriteString

    ; Exit program cleanly
    exit

main ENDP
END main
