.text
.global _start 
_start: LDR R4, =TESTNUMS
        MOV R5,#0 //result for counting 1s
        MOV R6,#0 //result for counting zeros
        MOV R7,#0 //result for counting alternating 1 and 0 
       
MAIN: 	LDR R1, [R4] //R1 holds test numbers
		LDR R3, [R4] //hold test numbers for zeros
        LDR R10, [R4] //hold test numbers for alternating
        LDR R11, = 0xAAAAAAAA
        
		ADD R4, #4
 		CMP R1, #0     
        BEQ MAIN_END
             
        BL ONES
        CMP R5, R0 //R5 holds final count for 1s
        MOVLT R5, R0 //replace R5 with new

        BL ZEROS
        CMP R6, R0 //R6 holds final count for zeros
        MOVLT R6, R0 //replace R6 with new
        
        BL ALTERNATE
        CMP R7, R12 //R7 holds final count for alternate
        MOVLT R7, R12 //replace R7 with new
               
        B MAIN
MAIN_END: B MAIN_END

//subroutine for shift/&
ONES:	MOV R0,#0 //reset R0 (current counter)
L_LOOP: CMP R1,#0
		BEQ L_END
		LSR R2,R1,#1
		AND R1,R2,R1
        ADD R0,#1
        B	L_LOOP
L_END:	MOV	PC, LR //return to BEQ

ZEROS:	MOV R0,#0 //reset R0 (current counter)
L_LOOP2:CMP R3,#0xFFFFFFFF //end condition with all 1s
		BEQ L_END2
		LSR R2,R3,#1
        ADD R2, #0x80000000
		ORR R3,R2,R3 
        ADD R0,#1
        B	L_LOOP2
L_END2:	MOV	PC, LR //return to BEQ




ALTERNATE:	MOV R0,#0 //reset R0 (current counter)
        //run XOR, alternating section should be sequence of 0s or 1s
        EOR R1, R10, R11
        EOR R3, R10, R11
		
		MOV R0,#0 //reset R0 (current counter)
A_L_LOOP: CMP R1,#0 //run ones check 
		BEQ A_L_END
		LSR R2,R1,#1
		AND R1,R2,R1
        ADD R0,#1
        B	A_L_LOOP
A_L_END:	MOV	R12,R0 //return to BEQ

		MOV R0,#0 //reset R0 (current counter)
A_L_LOOP2:	CMP R3, #0xFFFFFFFF //run zeros check
		BEQ A_L_END2
		LSR R2,R3,#1
        ADD R2, #0x80000000
		ORR R3,R2,R3 
        ADD R0,#1
        B	A_L_LOOP2
        
A_L_END2:	CMP R12, R0 //compare ones vs zeros sequences, pick longest
			MOVLT R12, R0//return to BEQ

		MOV	PC, LR //return to BEQ
        

TESTNUMS:
			.word 0x103fe00f // 0001 0000 0011 1111 1110 0000 0000 1111 
			.word 0x12345678 // 0001 0010 0011 0100 0101 0110 0111 1000 
			.word 0x89ABCDEF // 1000 1001 1010 1011 1100 1101 1110 1111 
			.word 0x122d9561 // 0001 0010 0010 1101 1001 0101 0110 0001 
			.word 0xca526d2a // 1100 1010 0101 0010 0110 1101 0010 1010 
			.word 0x9f0cb7f4 // 1001 1111 0000 1100 1011 0111 1111 0100 
			.word 0xbb437342 // 1011 1011 0100 0011 0111 0011 0100 0010 
            .word 0xbb437342 // 1011 1011 0100 0011 0111 0011 0100 0010 
            .word 0xFFFFFFF0 // 1111 1111 1111 1111 1111 1111 1111 0000
            .word 0x00000000 // 0000 
            .end 
