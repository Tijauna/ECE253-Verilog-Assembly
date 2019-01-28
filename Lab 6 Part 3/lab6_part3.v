module part3(CLOCK_50, SW, KEY, LEDR);
	input CLOCK_50;
	input [3:0] KEY;
	input [9:0] SW; //[2:0]
	output [0:0] LEDR;
	
	wire f, Enable, Load, z, bit0;
	wire [0:3] D;
	
	
	half_sec_counter f0 (CLOCK_50, f, KEY[0]);
	
	convert3to4 f1 (SW[2:0], D);
	
	shiftregister f2 (D, Load, f, bit0, KEY[0]);
	
	lengthcounter f3 (D, Enable, Load, f, z, KEY[0]);
	
	fsm f4 (KEY[1:0], z, bit0, CLOCK_50, LEDR[0], Enable, Load, f);
	
endmodule
	
	
module half_sec_counter(Clock, f, ResetN);
	input Clock, ResetN;
	output reg f;
	reg [0:24] z;

	always @ (posedge Clock, negedge ResetN)
	begin
		if (!ResetN)
			z <= 25'b0;
			
		//if z reaches 25000000
		else if (z == 1)  
			begin
				//put output to 1
				f <= 1'b1;
				//reset the counter
				z <= 25'b0;
			end
		
		else 
			begin	
				//increment counter
				f <= 1'b0;
				z <= z + 1;
			end
	end
endmodule

//shift register
module shiftregister(D, L, Clock, bit0, K); 
	//D represents #of elements in morse code
	input L, Clock, K;
	input [0:3] D;
	output bit0;
	
	reg [0:3] Q;
	
	always@(posedge Clock)
		if (L)
			Q <= D;
		else
		begin
			Q[0] <= Q[1];
			Q[1] <= Q[2];
			Q[2] <= Q[3];
			Q[3] <= 1'b0;
		end 
			
	//bit that is shifted out
	assign bit0 = Q[3];
	
endmodule 


//convert 3 to 4 bit 
module convert3to4 (S, D);
	input [2:0] S;
	output reg [0:3] D;
	
	//pulse is 0, dash is 1
	always @ (S[2:0])
		if (S[2:0] == 3'b000)
			D = 4'b0010;
		else if (S[2:0] == 3'b001)
			D = 4'b0001;
		else if (S[2:0] == 3'b010)
			D = 4'b0101;
		else if (S[2:0] == 3'b011)
			D = 4'b0001;
		else if (S[2:0] == 3'b100)
			D = 4'b0000;
		else if (S[2:0] == 3'b101)
			D = 4'b0100;
		else if (S[2:0] == 3'b110)
			D = 4'b0011;
		else if (S[2:0] == 3'b111)
			D = 4'b0000;	
	
endmodule



//morse code length counter
module lengthcounter (S, Enable, Ln, Clock, z, ResetN); 
	input [2:0] S;
	input Enable, Ln, Clock,ResetN;
	output reg z;
	reg [2:0] D, Q;
	
	//give number of elements in the morse code (how many dashes, dots)
	always @ (S[2:0])
	begin
		if (S[2:0] == 3'b000)
			D = 2;
		else if (S[2:0] == 3'b001)
			D = 4;
		else if (S[2:0] == 3'b010)
			D = 4;
		else if (S[2:0] == 3'b011)
			D = 3;
		else if (S[2:0] == 3'b100)
			D = 1;
		else if (S[2:0] == 3'b101)
			D = 4;
		else if (S[2:0] == 3'b110)
			D = 3;
		else if (S[2:0] == 3'b111)
			D = 4;
	end
	
	//upcount shifts out the G bits 
	always @ (posedge Clock, negedge ResetN)
	begin
		//z represents if shift done
		z = (Q == D);
		if (!ResetN)
			Q <= 1'b0;
		else if (Enable & Ln)
			Q <= Q + 1;
	end


endmodule 


module fsm(K, z, bit0, clk, LEDR, Enable, Ln, f);
	input [1:0] K;
	input z, bit0, clk;
	output [0:0] LEDR;
	output Enable, Ln;

	reg [2:0] y, Y;
	
	//states
	parameter A = 3'b000; //idle
	parameter B = 3'b001; //load
	parameter C = 3'b010; //1 dot
	parameter D = 3'b011; //1 dash
	parameter E = 3'b100; //2 dash
	parameter F = 3'b101; //3 dash
	parameter G = 3'b110; //Blank
	parameter H = 3'b111; //Finish

	always @ (z, bit0, K[1],y)
	begin
		case(y)
			//list states
			
			//idle state, not doing anything
			A: if (!K[1]) Y = B;
				else Y = A;
				
			//load state
			B: if (z) Y = H;
				else if (bit0 == 1'b0) Y = C;
				else Y = D;
				
			//1 dot
			C: Y = G;
			
			//1 dash
			D: Y = E;
			//2 dash
			E: Y = F;
			//3 dash, 1.5 seconds
			F: Y = G;
			
			//Blank 
			G: if (z) Y = H;
				else if (bit0 == 1'b0) Y = C;
				else Y = D;
				
			//Finish processing
			H: Y = H;
		endcase
	end

	always @ (posedge half_second, negedge K[0])
	begin
		if (f == 1)
		begin 
			if (!K[0])
			begin			
				y <= A;
			end 
			else
			begin 
				y <= Y;
			end 
		end 
	end
	
	//generate enable and load val
	assign Enable = (y == C | y == A | y == F);
	//assign load value to NOT idle
	assign Ln = ~(y == A);
	
	//output LED
	assign LEDR[0] = ( y== C | y== D | y== E | y== F);

endmodule 
