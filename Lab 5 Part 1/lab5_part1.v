module part1(SW, LEDR);

    input [1:0]SW;
	 output [2:0]LEDR;
	 
	 //SW[0] is D, SW[1] is clk, LEDR[0] = Q0, LEDR[1] = Q1, LEDR[2] = Q2
	 wire[2:0] out;
	 
	 D_latch dtest(SW[0], SW[1], out[0]);
	 pos_FF posff(SW[0], SW[1], out[1]);
	 neg_FF negff(SW[0], SW[1], out[2]);
	 
	 assign LEDR[0] = out[0];
	 assign LEDR[1] = out[1];
	 assign LEDR[2] = out[2];
	 
endmodule 
	 

module D_latch (D,clk,Q0);
	input D, clk;
	output reg Q0;
	always @(D,clk)
	begin
		if (clk == 1'b1)
			Q0 = D;
	end 
endmodule 

module pos_FF (D, clk, Q1);
	input D,clk;
	output reg Q1;
	always @(posedge clk)
		Q1<=D;
endmodule 

module neg_FF (D, clk, Q2);
	input D, clk;
	output reg Q2;
	always @(negedge clk)
		Q2<=D;
endmodule 