	.include "address_map_arm.s"
/* 
 * This program demonstrates the use of interrupts using the KEY and timer ports. It
 * 	1. displays a sweeping red light on LEDR, which moves left and right
 * 	2. stops/starts the sweeping motion if KEY3 is pressed
 * Both the timer and KEYs are handled via interrupts
*/
			.text
			.global	_start
_start:		
			//each mode has SP, LR, and status reg...need SP for each mode you use
			//... initialize the IRQ stack pointer ... hardware interupt
			MOV R0, #0b10010 //IRQ mode
			MSR CPSR, R0 //switching to IRQ mode 
			LDR SP, =0x20000 //set SP
		
			//... initialize the SVC stack pointer ... software interrupt 
			MOV R0, #0b10011  //SVC mode 
			MSR CPSR, R0 //switching to SVC 
			LDR SP,=0x3FFFFFFC //set SP			
			
			BL			CONFIG_GIC				// configure the ARM generic interrupt controller
			BL			CONFIG_PRIV_TIMER		// configure the MPCore private timer
			BL			CONFIG_KEYS				// configure the pushbutton KEYs
			
			//enable ARM interrupts 
			MSR			CPSR, #0b00010011		// change bit 7 of CPSR to 0 to enable interrupts, SVC mode

			LDR		R6, =0xFF200000 		// red LED base address
MAIN:
			LDR		R4, LEDR_PATTERN		// LEDR pattern; modified by timer ISR
			STR 		R4, [R6] 				// write to red LEDs
			B 			MAIN

/* Configure the MPCore private timer to create interrupts every 1/10 second */
CONFIG PRIV TIMER:
			LDR		R0, =0xFFFEC600 		// Timer base address
			LDR R1, =200000000 //timer duration 
			STR R1, [R0] //put timer length into LOAD VALUE for timer
			MOV R1, =0b111 //Set I = 1, A = 1, E = 1 
			STR R1, [R0, #8] //store these to the control register 
			
			MOV 		PC, LR 					// return

/* Configure the KEYS to generate an interrupt */
CONFIG KEYS:
			LDR 		R0, =0xFF200050 		// KEYs base address
			MOV         R1,=0b0111				//want 0 on KEY 3 to enable interrupts
			STR 		R1,[R0,#8]  			//write to the interrupt mask of the KEY
			MOV 		PC, LR 					// return

			.global	LEDR_DIRECTION
LEDR_DIRECTION:
			.word 	0							// 0 means left, 1 means right

			.global	LEDR_PATTERN
LEDR_PATTERN:
			.word 	0x1
