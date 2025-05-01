	EXPORT __main
    AREA PROG_1, CODE, READONLY 
__main 
    ; Main program flow — call each subroutine in sequence
    BL find_min_A
    BL find_min_B
    BL convert_B_neg_assumed_10s_complement
    BL add_sub_lists

stop
    B stop

;================= Subroutines ===================

find_min_A
    LDR R0, =A
    MOV R1, #5
    LDR R2, [R0], #4
    MOV R3, R2

find_min_A_loop
    SUBS R1, R1, #1
    BEQ store_min_A
    LDR R2, [R0], #4
    CMP R2, R3
    MOVLT R3, R2
    B find_min_A_loop

store_min_A
    LDR R0, =MinA
    STR R3, [R0]
    BX LR

find_min_B
    LDR R0, =B     ; Now using B_neg_assumed instead of B
    MOV R1, #5
    LDR R2, [R0], #4
    MOV R4, R2

find_min_B_loop
    SUBS R1, R1, #1
    BEQ store_min_B
    LDR R2, [R0], #4
    CMP R2, R4
    MOVLT R4, R2
    B find_min_B_loop

store_min_B
    LDR R0, =MinB
    STR R4, [R0]

    ; Sum MinA + 150
    LDR R1, =MinA
    LDR R2, [R1]
    ADD R2, R2, #150
    LDR R1, =SumMinA
    STR R2, [R1]

    ; Sum MinB + 150
    ADD R3, R4, #150
    LDR R1, =SumMinB
    STR R3, [R1]

    BX LR

convert_B_neg_assumed_10s_complement
    LDR R0, =B_neg_assumed     ; Use assumed negative list
    LDR R1, =CompB
    MOV R2, #5

convert_loop
    LDR R3, [R0], #4
    CMP R3, #0
    BGE store_positive

    ; 10's complement for negative number
    RSBS R4, R3, #0
    MVN  R5, R4
    ADD  R5, R5, #1
    STR  R5, [R1], #4
    B next_convert

store_positive
    STR R3, [R1], #4

next_convert
    SUBS R2, R2, #1
    BNE convert_loop

    BX LR

add_sub_lists
    LDR R0, =A
    LDR R1, =CompB
    LDR R2, =SumAB
    LDR R3, =DiffAB
    LDR R4, =CarryAB
    MOV R5, #5

add_sub_loop
    LDR R6, [R0], #4
    LDR R7, [R1], #4

    ADDS R8, R6, R7
    STR R8, [R2], #4

    MOV R9, #0
    ADC R9, R9, #0
    STR R9, [R4], #4

    SUB R8, R6, R7
    STR R8, [R3], #4

    SUBS R5, R5, #1
    BNE add_sub_loop

    BX LR

;================= Data Section ===================

    AREA Data1, DATA, READWRITE
A               DCD 3521, 379, 5611, 919, 1318
B               DCD 8141, 2615, 53, 951, 217
B_neg_assumed   DCD 8141, 2615, -53, 951, -217    ; <- Negative versions used in logic
CompB           DCD 0, 0, 0, 0, 0
SumAB           DCD 0, 0, 0, 0, 0
DiffAB          DCD 0, 0, 0, 0, 0
CarryAB         DCD 0, 0, 0, 0, 0
MinA            DCD 0
MinB            DCD 0
SumMinA         DCD 0
SumMinB         DCD 0

    END