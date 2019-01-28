module part3(SW, KEY, HEX0, HEX1);

	input[0:0] KEY;
	input[1:0] SW;

	output[0:6] HEX0, HEX1;

	wire [7:0]Q; 
	wire enable, clear;
	assign enable = SW[1];
	assign clear = SW[0];


	tflipflop t0 (KEY[0], enable, clear, Q[0]);
	tflipflop t1 (KEY[0], enable&Q[0], clear, Q[1]);
	tflipflop t2 (KEY[0], enable&Q[0]&Q[1], clear, Q[2]);
	tflipflop t3 (KEY[0], enable&Q[0]&Q[1]&Q[2], clear, Q[3]);
	tflipflop t4 (KEY[0], enable&Q[0]&Q[1]&Q[2]&Q[3], clear, Q[4]);
	tflipflop t5 (KEY[0], enable&Q[0]&Q[1]&Q[2]&Q[3]&Q[4], clear, Q[5]);
	tflipflop t6 (KEY[0], enable&Q[0]&Q[1]&Q[2]&Q[3]&Q[4]&Q[5], clear, Q[6]);
	tflipflop t7 (KEY[0], enable&Q[0]&Q[1]&Q[2]&Q[3]&Q[4]&Q[5]&Q[6], clear, Q[7]);


	//display
	hex7seg(HEX0, Q[3:0]);
	hex7seg(HEX1, Q[7:4]);
	
endmodule



module tflipflop (clock, en, clc, output1);

	input clock, en, clc;
	output reg output1;

	always @(posedge clock)
		//if clear is 0, clear everything (active low)
		if(~clc)
			output1 <= 1'b0;
		
		//if enable = 1, invert value at bit
		else if(en)
			output1 <= ~output1;

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