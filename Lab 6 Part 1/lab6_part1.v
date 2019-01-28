module part1 (SW, LEDR, KEY);

	input[0:0] KEY;
	input[1:0] SW;
	output[9:0] LEDR;
	
	wire[8:0] state, state_next;
	wire w, clear, clk, z;
	
	parameter E = 9'b000010000;
	parameter I = 9'b100000000;
	
	assign w = SW[1];
	assign clear = SW[0];
	assign clk = KEY[0];
	
	assign LEDR[9] = z;
	assign LEDR[8:0] = state;
		
	assign z = (state == E)|(state == I);
	
	//logic functions
	assign state_next[0] = 1'b0;
	assign state_next[1] = ~w & (state[0] | state[5] | state[6] | state[7] | state[8]);
	assign state_next[2] = ~w & state[1];
	assign state_next[3] = ~w & state[2];
	assign state_next[4] = ~w & (state[3] | state[4]);
	assign state_next[5] = w & (state[0] | state[1] | state[2] | state[3] | state[4]);
	assign state_next[6] = w & state[5];
	assign state_next[7] = w & state[6];
	assign state_next[8] = w & (state[7] | state[8]);
	
	flipflop f0 (clk, state_next[0], 1'b1, clear, state[0]);
	flipflop f1 (clk, state_next[1], 1'b0, clear, state[1]);
	flipflop f2 (clk, state_next[2], 1'b0, clear, state[2]);
	flipflop f3 (clk, state_next[3], 1'b0, clear, state[3]);
	flipflop f4 (clk, state_next[4], 1'b0, clear, state[4]);
	flipflop f5 (clk, state_next[5], 1'b0, clear, state[5]);
	flipflop f6 (clk, state_next[6], 1'b0, clear, state[6]);
	flipflop f7 (clk, state_next[7], 1'b0, clear, state[7]);
	flipflop f8 (clk, state_next[8], 1'b0, clear, state[8]);
	
	
endmodule 


module flipflop (clock, D, reset_value, clc, output1);

   input clock, D, clc, reset_value;
	output reg output1;

	always @(posedge clock or negedge clc)
		//if clear is 0, clear all
		if(~clc)
			output1 <= reset_value;
	
		else
			output1 <= D;

endmodule
