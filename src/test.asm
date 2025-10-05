; =============================================================
; COMP-2660 – Assignment #1 – Fall 2025
; Cleaned & commented version
; This program computes Z = (A - B) - (C - D)
; It initializes A and B, reads C and D from the user,
; displays all variables, and prints Z in binary, decimal, and hex.
; =============================================================

INCLUDE Irvine32.inc       ; Irvine32 macros and procedure prototypes
INCLUDELIB Irvine32.lib    ; Link with Irvine32 library

.data                      ; -------- Data segment --------
; Use descriptive variable names to avoid parsing ambiguity
varA SDWORD -543210        ; 32-bit signed integer (initialized)
varB SWORD  -3210          ; 16-bit signed integer (initialized)
varC SDWORD ?              ; 32-bit signed integer (input from user)
varD SBYTE  ?              ; 8-bit signed integer  (input from user)
varZ SDWORD ?              ; 32-bit signed integer (result)

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

.code                      ; -------- Code segment --------
main PROC

    ; ---------------------------
    ; Read user input for varC
    ; ---------------------------
    mov edx, OFFSET msgPromptC   ; EDX = address of prompt for C
    call WriteString             ; print "What is the value of C? "
    call ReadInt                 ; read a signed 32-bit integer into EAX
    mov varC, eax                ; store EAX into varC (32-bit)

    ; echo the value just read
    mov edx, OFFSET msgC         ; EDX = address of "C = "
    call WriteString             ; print label
    mov eax, varC                ; EAX = varC
    call WriteInt                ; print integer in EAX
    mov edx, OFFSET newline
    call WriteString             ; print newline

    ; ---------------------------
    ; Read user input for varD (8-bit)
    ; ---------------------------
    mov edx, OFFSET msgPromptD   ; EDX = address of prompt for D
    call WriteString             ; print "What is the value of D? "
    call ReadInt                 ; read a signed 32-bit integer into EAX
                                 ; (we will store only the low 8 bits into varD)
    mov varD, al                 ; store AL (lowest 8 bits) into varD (SBYTE)
                                 ; note: this truncates to 8 bits intentionally

    ; echo the value of varD with sign-extension
    mov edx, OFFSET msgD         ; EDX = address of "D = "
    call WriteString             ; print label
    movsx eax, varD              ; sign-extend varD (8-bit) into EAX (32-bit)
    call WriteInt                ; print the extended integer
    mov edx, OFFSET newline
    call WriteString             ; print newline

    ; ---------------------------
    ; Display the expression heading
    ; ---------------------------
    mov edx, OFFSET msgExpr
    call WriteString
    mov edx, OFFSET newline
    call WriteString

    ; ---------------------------
    ; Display all variables A, B, C, D (each on its own line)
    ; ---------------------------
    ; Display A
    mov edx, OFFSET msgA
    call WriteString
    mov eax, varA
    call WriteInt
    mov edx, OFFSET newline
    call WriteString

    ; Display B
    mov edx, OFFSET msgB
    call WriteString
    ; B is 16-bit (SWORD). Sign-extend to EAX before printing:
    movsx eax, varB
    call WriteInt
    mov edx, OFFSET newline
    call WriteString

    ; Display C
    mov edx, OFFSET msgC
    call WriteString
    mov eax, varC
    call WriteInt
    mov edx, OFFSET newline
    call WriteString

    ; Display D (already sign-extended when printed above, but show again)
    mov edx, OFFSET msgD
    call WriteString
    movsx eax, varD
    call WriteInt
    mov edx, OFFSET newline
    call WriteString

    ; ---------------------------
    ; Compute Z = (A - B) - (C - D)
    ; ---------------------------
    mov eax, varA           ; EAX = varA
    movsx ebx, varB         ; EBX = sign-extended varB (16-bit -> 32-bit)
    sub eax, ebx            ; EAX = A - B

    mov ecx, varC           ; ECX = varC
    movsx edx, varD         ; EDX = sign-extended varD (8-bit -> 32-bit)
    sub ecx, edx            ; ECX = C - D

    sub eax, ecx            ; EAX = (A - B) - (C - D)
    mov varZ, eax           ; store result in varZ

    ; ---------------------------
    ; Display Z in Binary, Decimal, Hex
    ; ---------------------------
    mov edx, OFFSET msgBin
    call WriteString
    mov eax, varZ
    call WriteBin            ; prints binary representation of EAX
    mov edx, OFFSET newline
    call WriteString

    mov edx, OFFSET msgDec
    call WriteString
    mov eax, varZ
    call WriteInt            ; prints decimal representation of EAX
    mov edx, OFFSET newline
    call WriteString

    mov edx, OFFSET msgHex
    call WriteString
    mov eax, varZ
    call WriteHex            ; prints hexadecimal representation of EAX
    mov edx, OFFSET newline
    call WriteString

    ; Exit program cleanly
    exit

main ENDP
END main