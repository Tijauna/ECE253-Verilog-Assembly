module part4(SW, KEY, HEX0, HEX1, HEX2, HEX3);

	input[0:0] KEY;
	input[1:0] SW;

	output[0:6] HEX0, HEX1, HEX2, HEX3;

	wire [15:0]Q; 
	wire enable, clear;
	assign enable = SW[1];
	assign clear = SW[0];


	tflipflop t0 (KEY[0], enable, clear, Q);


	//display
	hex7seg(HEX0, Q[3:0]);
	hex7seg(HEX1, Q[7:4]);
	hex7seg(HEX2, Q[11:8]);
	hex7seg(HEX3, Q[15:12]);
	
endmodule



module tflipflop (clock, en, clc, output1);

	input clock, en, clc;
	output reg [0:15] output1;

	always @(posedge clock)
		//if clear is 0, clear all
		if(~clc)
			output1 <= 0;
		
		//if enable = 1, add 1 
		else if(en)
			output1 <= output1 + 1;

endmodule





module hex7seg (output [0:6] hex, input [3:0] s);
	
	assign hex[0]=(~s[3]&~s[2]&~s[1]& s[0]) | (~s[3]& s[2]&~s[1]&~s[0]) | ( s[3]&~s[2]& s[1]& s[0]) | ( s[3]& s[2]&~s[1]& s[0]);
	assign hex[1]=(~s[3]& s[2]&~s[1]& s[0]) | (~s[3]& s[2]& s[1]&~s[0]) | ( s[3]&~s[2]& s[1]& s[0]) | ( s[3]& s[2]&~s[1]&~s[0]) | ( s[3]& s[2]& s[1]);
	assign hex[2]=(~s[3]&~s[2]& s[1]&~s[0]) | ( s[3]& s[2]&~s[1]&~s[0]) | ( s[3]& s[2]& s[1]);
	assign hex[3]=(~s[3]&~s[2]&~s[1]& s[0]) | (~s[3]& s[2]&~s[1]&~s[0]) | (~s[3]& s[2]& s[1]& s[0]) | ( s[3]&~s[2]& s[1]&~s[0]) | ( s[3]& s[2]& s[1]& s[0]);
	assign hex[4]=(~s[3]&~s[2]&~s[1]& s[0]) | (~s[3]&~s[2]& s[1]& s[0]) | (~s[3]& s[2]&~s[1]&~s[0]) | ( s[3]&~s[2]&~s[1]& s[0]) | (~s[3]& s[2]& s[0]);
	assign hex[5]=(~s[3]&~s[2]&~s[1]& s[0]) | (~s[3]& s[2]& s[1]& s[0]) | ( s[3]& s[2]&~s[1]& s[0]) | (~s[3]&~s[2]& s[1]);
	assign hex[6]=(~s[3]& s[2]& s[1]& s[0]) | ( s[3]& s[2]&~s[1]&~s[0]) | (~s[3]&~s[2]&~s[1]);

endmodule	