				.include "address_map_arm.s"
				.extern	LEDR_DIRECTION
				.extern	LEDR_PATTERN

/*****************************************************************************
 * MPCORE Private Timer - Interrupt Service Routine                                
 *                                                                          
 * Shifts the pattern being displayed on the LEDR
 * 
******************************************************************************/
				.global PRIV_TIMER_ISR
PRIV_TIMER_ISR:	
				LDR		R0, =MPCORE_PRIV_TIMER	// base address of timer
				MOV		R1, #1
				STR		R1, [R0, #0xC]				// write 1 to F bit to reset it
															// and clear the interrupt

/* Rotate the LEDR bits either to the left or right. Reverses direction when hitting 
	position 9 on the left, or position 0 on the right */
SWEEP:		LDR		R0, =LEDR_DIRECTION	// put shifting direction into R2
				LDR		R2, [R0]
				LDR		R1, =LEDR_PATTERN		// put LEDR pattern into R3
				LDR		R3, [R1]

				CMP R2,#0 //check if shift direction 
				BNE SHIFTR //shift right if R2 is not 0 

SHIFTL:		LSL	R3, R3, #1 //shift left by 1 
			CMP	R3, #0b1000000000   //check if at end of rotation
			BEQ L_R //if at left end, start moving right 
			BNE	DONE_SWEEP

L_R:			MOV		R2, #1					// change direction to right
				B DONE_SWEEP
				
SHIFTR:		LSR	R3, R3, #1 //shift right by 1 
			CMP	R3, #0b0000000001   //check if at end of rotation
			BEQ R_L //if at right end, start moving left 
			BNE	DONE_SWEEP

R_L:			MOV		R2, #0					// change direction to left
				B DONE_SWEEP

DONE_SWEEP:
				STR		R2, [R0]					// put shifting direction back into memory
				STR		R3, [R1]					// put LEDR pattern back onto stack
	
END_TIMER_ISR:
				MOV		PC, LR
