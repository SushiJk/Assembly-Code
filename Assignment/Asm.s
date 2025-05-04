	EXPORT __main
    AREA PROG_1, CODE, READONLY 
__main 
    ; Main program flow — call each subroutine in sequence
    BL find_min_A		 			; Call subroutine to find minimum value in array A
    BL find_min_B       			; Call subroutine to find minimum value in array B
    BL convert_B_10s_complement 	; Convert negative values in B to 10's complement
    BL add_sub_lists				; Add and subtract elements from A and CompB
	
stop
    B stop

;================= Subroutines ===================

find_min_A
    LDR R0, =A                 	; Load address of array A into R0
    MOV R1, #5                 	; Set loop counter to 5
    LDR R2, [R0], #4           	; Load first value from A into R2, increment R0
    MOV R3, R2                 	; Set initial minimum (R3) to first element

find_min_A_loop
    SUBS R1, R1, #1            	; counter
    BEQ store_min_A            	; If counter is 0, jump to store_min_A
    LDR R2, [R0], #4           	; Load next element from A
    CMP R2, R3                 	; Compare with current minimum
    MOVLT R3, R2               	; If R2 < R3, update minimum
    B find_min_A_loop          	; Repeat loop

store_min_A
    LDR R0, =MinA              	; Load address of MinA variable
    STR R3, [R0]               	; Store minimum value
    BX LR                      	; Return from subroutine


find_min_B
    LDR R0, =B                 	; Load address of B 
    MOV R1, #5                 	; Set loop counter to 5
    LDR R2, [R0], #4           	; Load first value from B into R2
    MOV R4, R2                 	; Set initial minimum (R4)

find_min_B_loop
    SUBS R1, R1, #1            	; Decrement counter
    BEQ store_min_B            	; If done, store result
    LDR R2, [R0], #4           	; Load next value
    CMP R2, R4                 	; Compare with current minimum
    MOVLT R4, R2               	; Update if new value is smaller
    B find_min_B_loop          	; Repeat loop

store_min_B
    LDR R0, =MinB              	; Load address to store MinB
    STR R4, [R0]               	; Store minimum value

    ; Sum MinA + 150
    LDR R1, =MinA              	; Load address of MinA
    LDR R2, [R1]               	; Load MinA value
    ADD R2, R2, #150           	; Add 150
    LDR R1, =SumMinA          	; Load address of SumMinA
    STR R2, [R1]               	; Store result

    ; Sum MinB + 150
    ADD R3, R4, #150          	; Add 150 to MinB
    LDR R1, =SumMinB           	; Load address of SumMinB
    STR R3, [R1]               	; Store result
    BX LR                      	; Return from subroutine

convert_B_10s_complement
    LDR R0, = B     			;Load address of B
    LDR R1, =CompB				;Load address of CompB
    MOV R2, #5					;Set loop counter to 5

convert_loop
    LDR R3, [R0], #4			;Load value from B
    CMP R3, #0					;Check if value is negative 
    BGE store_positive			;if positive go to store_positive
	
    ; 10's complement for negative number
    RSBS R4, R3, #0				;R4 = -R3
    MVN  R5, R4					;inverse bits of R4 and store in R5
    ADD  R5, R5, #1				;add 1 to R5
    STR  R5, [R1], #4			;Store converted value to R1
    B next_convert				;next iteration

store_positive
    STR R3, [R1], #4			;store positive number directly

next_convert
    SUBS R2, R2, #1            ; Decrement counter
    BNE convert_loop           ; If not zero, continue loop

    BX LR                      ; Return from subroutine

add_sub_lists
    LDR R0, =A                 ; Load address of array A
    LDR R1, =CompB             ; Load address of converted B
    LDR R2, =SumAB             ; Load address to store sums
    LDR R3, =DiffAB            ; Load address to store differences
    LDR R4, =CarryAB           ; Load address to store carry info
    MOV R5, #5                 ; Set loop counter

add_sub_loop
    LDR R6, [R0], #4           ; Load value from A
    LDR R7, [R1], #4           ; Load value from CompB

    ADDS R8, R6, R7            ; Add with carry update
    STR R8, [R2], #4           ; Store sum in SumAB

    MOV R9, #0                 ; Clear R9 for carry
    ADC R9, R9, #0             ; Add carry flag to R9
    STR R9, [R4], #4           ; Store carry in CarryAB

    SUB R8, R6, R7             ; Subtract CompB from A
    STR R8, [R3], #4           ; Store result in DiffAB

    SUBS R5, R5, #1            ; Decrement loop counter
    BNE add_sub_loop           ; Continue if not zero

    BX LR                      ; Return from subroutine

;================= Data Section ===================

    AREA Data1, DATA, READWRITE
A               DCD 3521, 379, 5611, 919, 1318
B               DCD 8141, 2615, 53, 951, 217
CompB           DCD 0, 0, 0, 0, 0
SumAB           DCD 0, 0, 0, 0, 0
DiffAB          DCD 0, 0, 0, 0, 0
CarryAB         DCD 0, 0, 0, 0, 0
MinA            DCD 0
MinB            DCD 0
SumMinA         DCD 0
SumMinB         DCD 0

    END