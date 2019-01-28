module part2(input [7:0]SW, input [1:0] KEY, output [0:6]HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, output [0:0]LEDR);
	
	//KEY0 is active low asynchronous reset
	//KEY1 is a clock input 

	//store values in register
   wire [7:0]Q;
	register8bit reg1(SW[7:0], KEY[0], KEY[1], Q[7:0]);

	//display A on HEX2, HEX3
	hex7seg A0(Q[3:0], HEX2);
	hex7seg A1(Q[7:4], HEX3);
	
	//display B on HEX0, HEX1
	hex7seg B0(SW[3:0], HEX0);
	hex7seg B1(SW[7:4], HEX1);
	
	//add the two 8 bit numbers
	//A is in register (Q), B is from switches 0 - 7
	wire [7:0] carry;
	wire [7:0] S;
	fulladder a1(Q[0], SW[0], 1'b0, carry[0], S[0]);
	fulladder a2(Q[1], SW[1], carry[0], carry[1], S[1]);
	fulladder a3(Q[2], SW[2], carry[1], carry[2], S[2]);
	fulladder a4(Q[3], SW[3], carry[2], carry[3], S[3]);
	fulladder a5(Q[4], SW[4], carry[3], carry[4], S[0]);
	fulladder a6(Q[5], SW[5], carry[4], carry[5], S[1]);
	fulladder a7(Q[6], SW[6], carry[5], carry[6], S[2]);
	fulladder a8(Q[7], SW[7], carry[6], LEDR[0], S[7]);
	
	//display sum
	//sum stored in S[]
	hex7seg sum0(S[3:0], HEX4);
	hex7seg sum1(S[7:4], HEX5);
	
endmodule 


module register8bit(input [7:0] in, input reset, input clock, output reg [7:0] output1);
	
	always @(posedge clock, negedge reset)
		if (~reset)
			output1 <= 8'b0;
		else
			output1 <= in;
			
endmodule 

module fulladder(input a, b, ci, co, output s);
	wire d;
	assign d = a^b; 
	mux2to1 U0(b, ci, d, co);
	assign s = ci^d;
	
endmodule 

module mux2to1(input a, b, s, output f);
	assign f = (~s&a)|(s&b);
	
endmodule
    

module hex7seg (output [0:6] hexdisplay, input [3:0] s);
	
	assign hexdisplay[0]=(~s[3]&~s[2]&~s[1]& s[0]) | (~s[3]& s[2]&~s[1]&~s[0]) | ( s[3]&~s[2]& s[1]& s[0]) | ( s[3]& s[2]&~s[1]& s[0]);
	assign hexdisplay[1]=(~s[3]& s[2]&~s[1]& s[0]) | (~s[3]& s[2]& s[1]&~s[0]) | ( s[3]&~s[2]& s[1]& s[0]) | ( s[3]& s[2]&~s[1]&~s[0]) | ( s[3]& s[2]& s[1]);
	assign hexdisplay[2]=(~s[3]&~s[2]& s[1]&~s[0]) | ( s[3]& s[2]&~s[1]&~s[0]) | ( s[3]& s[2]& s[1]);
	assign hexdisplay[3]=(~s[3]&~s[2]&~s[1]& s[0]) | (~s[3]& s[2]&~s[1]&~s[0]) | (~s[3]& s[2]& s[1]& s[0]) | ( s[3]&~s[2]& s[1]&~s[0]) | ( s[3]& s[2]& s[1]& s[0]);
	assign hexdisplay[4]=(~s[3]&~s[2]&~s[1]& s[0]) | (~s[3]&~s[2]& s[1]& s[0]) | (~s[3]& s[2]&~s[1]&~s[0]) | ( s[3]&~s[2]&~s[1]& s[0]) | (~s[3]& s[2]& s[0]);
	assign hexdisplay[5]=(~s[3]&~s[2]&~s[1]& s[0]) | (~s[3]& s[2]& s[1]& s[0]) | ( s[3]& s[2]&~s[1]& s[0]) | (~s[3]&~s[2]& s[1]);
	assign hexdisplay[6]=(~s[3]& s[2]& s[1]& s[0]) | ( s[3]& s[2]&~s[1]&~s[0]) | (~s[3]&~s[2]&~s[1]);

endmodule	
	
