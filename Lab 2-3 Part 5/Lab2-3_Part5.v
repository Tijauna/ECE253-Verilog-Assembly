module part5 (SW, LEDR, HEX0, HEX1, HEX2);
	input [9:0] SW; // slide switches
	output [9:0] LEDR; // red lights
	output [0:6] HEX0; // 7-seg display
	output [0:6] HEX1;
	output [0:6] HEX2;
	
	wire [1:0] M0;
	wire [1:0] M1;
	wire [1:0] M2;
	
	assign LEDR[0] = SW[0];
	assign LEDR[1] = SW[1];
	assign LEDR[2] = SW[2];
	assign LEDR[3] = SW[3];
	assign LEDR[4] = SW[4];
	assign LEDR[5] = SW[5];
	assign LEDR[6] = SW[6];
	assign LEDR[7] = SW[7];
	assign LEDR[8] = SW[8];
	assign LEDR[9] = SW[9];
	
		
	mux_2bit_3to1 U0 (SW[9:8], SW[5:4], SW[3:2], SW[1:0], M0);
	char_7seg H0 (M0, HEX0);
	
	mux_2bit_3to1 U1 (SW[9:8], SW[3:2], SW[1:0], SW[5:4], M1);
	char_7seg H1 (M1, HEX1);
	
	mux_2bit_3to1 U2 (SW[9:8], SW[1:0], SW[5:4], SW[3:2], M2);
	char_7seg H2 (M2, HEX2);
	
	
endmodule

// implements a 2-bit wide 3-to-1 multiplexer
module mux_2bit_3to1 (S, U, V, W, Mss);
	input [1:0] S, U, V, W;
	output [1:0] M;

	wire s0, s1;
	
	assign s0 = S[0];
	assign s1 = S[1];
	
	assign M[0] = (s1&W[0])|(~s1&((~s0&U[0])|(s0&V[0])));
	assign M[1] = (s1&W[1])|(~s1&((~s0&U[1])|(s0&V[1])));

endmodule


// implements a 7-segment decoder for d, E, 1 and ‘blank’
module char_7seg (C, Display);
	input [1:0] C; // input code
	output [0:6] Display; // output 7-seg code
	
	wire c0, c1;

	assign c0 = C[0];
	assign c1 = C[1];
	
	assign Display[0] = c1|~c0;
	assign Display[1] = c0;
	assign Display[2] = c0;
	assign Display[3] = c1;
	assign Display[4] = c1;
	assign Display[5] = c1|~c0;
	assign Display[6] = c1;
	
endmodule