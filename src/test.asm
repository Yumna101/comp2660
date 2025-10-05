INCLUDE Irvine32.inc       ; Include Irvine32 library (provides I/O functions)

.data                       ; === Data Segment ===
; Step 1: Declare and initialize variables
A SDWORD -543210            ; 32-bit signed integer
B SWORD  -3210              ; 16-bit signed integer
C SDWORD ?                  ; 32-bit signed integer (will be read from user)
D SBYTE  ?                  ; 8-bit signed integer (will be read from user)
Z SDWORD ?                  ; 32-bit signed integer result

; Step 2a: Declare message strings
msgC   BYTE "What is the value of C? ",0
msgD   BYTE "What is the value of D? ",0
expr   BYTE "Z = (A - B) - (C - D)",0
labels BYTE "A = ",0
        BYTE "   ;   B = ",0
        BYTE "   ;   C = ",0
        BYTE "   ;   D = ",0
newline BYTE 0Dh,0Ah,0       ; Carriage return + newline

; Headings for displaying results
msgBin BYTE "Z in Binary: ",0
msgDec BYTE "Z in Decimal: ",0
msgHex BYTE "Z in Hexadecimal: ",0

.code                       ; === Code Segment ===
main PROC

;---------------------------------------------------------------
; Step 2b: Read value for variable C
;---------------------------------------------------------------
    mov edx, OFFSET msgC     ; Load address of "What is the value of C?" message
    call WriteString         ; Display the message
    call ReadInt             ; Read a 32-bit signed integer from the keyboard
    mov C, eax               ; Store it into variable C
    mov edx, OFFSET msgC     ; Display the message again
    call WriteString
    call WriteInt            ; Display the value of C
    call Crlf                ; Move to next line

;---------------------------------------------------------------
; Step 2c: Read value for variable D
;---------------------------------------------------------------
    mov edx, OFFSET msgD     ; Display message for D
    call WriteString
    call ReadInt             ; Read integer from keyboard
    mov D, al                ; Store only the lower 8 bits (SBYTE)
    mov edx, OFFSET msgD     ; Display message again
    call WriteString
    movsx eax, D             ; Sign-extend 8-bit D to 32 bits
    call WriteInt            ; Display value of D
    call Crlf                ; New line

;---------------------------------------------------------------
; Step 4: Display the expression "Z = (A - B) - (C - D)"
;---------------------------------------------------------------
    call Crlf
    mov edx, OFFSET expr
    call WriteString
    call Crlf

;---------------------------------------------------------------
; Step 5: Display all variables (A, B, C, D)
;---------------------------------------------------------------
    mov edx, OFFSET labels
    call WriteString

    ; Display A
    mov eax, A
    call WriteInt
    mov edx, OFFSET newline
    call Crlf

    ; Display B, C, D in same line with spacing
    mov edx, OFFSET newline
    call Crlf
    mov edx, OFFSET labels
    call WriteString

    mov eax, A
    call WriteInt
    mov edx, OFFSET newline
    call Crlf

; Simpler and clear display
    mov edx, OFFSET newline
    call Crlf
    mov edx, OFFSET newline
    call Crlf

;---------------------------------------------------------------
; Step 6: Calculate Z = (A - B) - (C - D)
;---------------------------------------------------------------
    mov eax, A               ; EAX = A
    movsx ebx, B             ; EBX = B (sign-extend 16-bit)
    sub eax, ebx             ; EAX = A - B

    mov ecx, C               ; ECX = C
    movsx edx, D             ; EDX = D (sign-extend 8-bit)
    sub ecx, edx             ; ECX = C - D

    sub eax, ecx             ; EAX = (A - B) - (C - D)
    mov Z, eax               ; Store result in Z

;---------------------------------------------------------------
; Step 7: Display results in Binary, Decimal, and Hexadecimal
;---------------------------------------------------------------
    call Crlf

    mov edx, OFFSET msgBin
    call WriteString
    mov eax, Z
    call WriteBin
    call Crlf

    mov edx, OFFSET msgDec
    call WriteString
    mov eax, Z
    call WriteInt
    call Crlf

    mov edx, OFFSET msgHex
    call WriteString
    mov eax, Z
    call WriteHex
    call Crlf

    exit                     ; Exit to operating system
main ENDP

END main