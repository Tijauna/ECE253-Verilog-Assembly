module part2 (SW, LEDR, KEY);
	input[0:0] KEY;
	input[1:0] SW;
	output[9:0] LEDR;
	
	wire w, z, reset, clk;
	
	assign LEDR[9] = z;
	assign LEDR[3:0] = ps;
	assign reset = SW[0];
	assign w = SW[1];
	assign clk = KEY[0];
	
	
	parameter A = 4'b0000;
	parameter B = 4'b0001;
	parameter C = 4'b0010;
	parameter D = 4'b0011;
	parameter E = 4'b0100;
	parameter F = 4'b0101;
	parameter G = 4'b0110;
	parameter H = 4'b0111;
	parameter I = 4'b1000;
	
	//present state and next state
	reg [3:0] ps;
	reg [3:0] ns;
	
	//assign z output
	assign z = (ps == E)|(ps == I);
	
	always @(*)
		case(ps)
			A: if (~w) ns <= B; else ns <= F;
			B: if (~w) ns <= C; else ns <= F;
			C: if (~w) ns <= D; else ns <= F;
			D: if (~w) ns <= E; else ns <= F;
			E: if (~w) ns <= E; else ns <= F;
			F: if (~w) ns <= B; else ns <= G;
			G: if (~w) ns <= B; else ns <= H;
			H: if (~w) ns <= B; else ns <= I;
			I: if (~w) ns <= B; else ns <= I;
			
			default: ns = 4'bxx;
		endcase
		
	always @(posedge clk or negedge reset)
		if (~reset)
			ps <= A;
		else
			ps <= ns;
endmodule 
			
		