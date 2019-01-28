module part3 (SW, LEDR);
	input [9:0] SW;
	output [9:0] LEDR;
	
	wire [1:0] U;
	wire [1:0] V;
	wire [1:0] W;
	wire s0, s1;
	
	assign W[0] = SW[0];
	assign W[1] = SW[1];
	assign V[0] = SW[2];
	assign V[1] = SW[3];
	assign U[0] = SW[4];
	assign U[1] = SW[5];
	assign s0 = SW[8];
	assign s1 = SW[9];
	
	assign LEDR[0] = (s1&W[0])|(~s1&((~s0&U[0])|(s0&V[0])));
	assign LEDR[1] = (s1&W[1])|(~s1&((~s0&U[1])|(s0&V[1])));
	
	assign LEDR[2] = 0;
	assign LEDR[3] = 0;
	assign LEDR[4] = 0;
	assign LEDR[5] = 0;
	assign LEDR[6] = 0;
	assign LEDR[7] = 0;
	assign LEDR[8] = 0;
	assign LEDR[9] = 0;

endmodule 
	