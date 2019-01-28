.text
.global _start 
_start: LDR R4, =TESTNUMS
		LDR R3, [R4] //load the number of elements into R3, the main counter
        ADD R4, #4 //increment to next test number
        MOV R0, #1
       	
MAIN:

		//CMP R0,#0
        //BEQ MAIN_END
        
        MOV R0, R4 //load address of first element into R0
        LDR R4, =TESTNUMS
        ADD R4, #4
        
        CMP	R3,#0 		//check if main counter done, exit if it is
        BEQ MAIN_END
         
        
        //R6 will be inner loop counter, set it each time before calling inner loop
        SUB R6, R3, #0x1
        B SWAP //inner loop 
        
        //SUB R3,#0x1 //decrement main counter by 1
        
        
SWAP:
				MOV R0, #0 //set R0 to 0 for now
				CMP R6,#0 //check if inner counter is done, exit if it is
                SUBEQ R3,#0x1 //decrement main counter by 1
                BEQ MAIN
                
                //B SWAP
                LDR R1, [R4] //first element
				LDR R2, [R4,#4] //next element
       		    
        
				CMP R2, R1 //if next element bigger than prev element, swap
        		MOVPL R0, #1 //store 1 as a swap has occured
        		STRPL R2,[R4]
        		STRPL R1,[R4,#4]
                
                SUB R6,#0x1 //decrement inner counter by 1
				ADD R4, #4 //increment to next test number
                B SWAP
        
MAIN_END: B MAIN_END //finished sorting

//subroutine to determine if need to swap, return 1 if swap performed, 0 if not
//SWAP: 	LDR R1, [R0] //first element
		//LDR R2, [R0,#4] //next element
        //MOV R0, #0 //set R0 to 0 for now
        
		//CMP R2, R1 //if next element bigger than prev element, swap
        //MOVPL R0, #1 //store 1 as a swap has occured
        //STRPL R2,[R4]
        //STRPL R1,[R4,#4]
       	  
        //MOV PC, LR //return to inner loop  

//subroutine for swapping itself
//SWAPPER: 	STR R2, [R4]
			//STR R1, [R4,#4] //swap contents of R1 and R2
            //MOV R0, #1 //store 1 as a swap has occured
			//MOV PC, LR //return to SWAP 
        

TESTNUMS:
			//.word 3, 45, 1400, 58
			.word 10, 1400, 45, 23, 5, 3, 8, 17, 4, 20, 3
            .end 

	