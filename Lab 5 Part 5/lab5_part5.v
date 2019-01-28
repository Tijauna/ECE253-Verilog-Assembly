module part5 (CLOCK_50, HEX0);

	input CLOCK_50;
	output[0:6] HEX0;
	
	//given 50 mhz clock, 50 million times a second up/down
	//thus use 50,000,000, which in binary has 26 bits
	
	//counter is the main counter 0 to 50,000,000
	wire [25:0] count;
	wire [3:0]A;
	
	//fast_output = final output of fast counter
	reg fastoutput,resetfast, resetslow;
	
	fastcounter fc(count, CLOCK_50, resetfast);
	
	//make sure that timer ticks every 1 second, check at every CLOCK_50 posedge
	always @ (posedge CLOCK_50)
	begin
		//check for reaching 50 mil
		if (count == 26'd50000000)
			begin
				resetfast <= 0;
				fastoutput <= 1;
			end
			else
			begin
				resetfast <= 1;
				fastoutput <= 0;
			end
			if (A[3] & ~A[2] & A[1] & ~A[0]) //reaches 10
				resetslow = 0;
			else
				resetslow = 1;
	end 

	//send to the slow counter
	tflipflop t0 (fastoutput, CLOCK_50, resetslow, A[0]);
	tflipflop t1 (fastoutput & A[0], CLOCK_50, resetslow, A[1]);
	tflipflop t2 (fastoutput & A[0] & A[1], CLOCK_50, resetslow, A[2]);
	tflipflop t3 (fastoutput & A[0] & A[1] & A[2], CLOCK_50, resetslow, A[3]);
	
	//display on the 7 segment display
	hex7seg display1 (A,HEX0);
	
	
endmodule 
	
	
module fastcounter (timerfast, clock, resetn);
	input clock, resetn;
	output reg [25:0] timerfast;
	initial
		timerfast = 0;
	
	//reset the fast timer (26 bit) if resetn is 0 
	//else add 1 
	always @ (posedge clock)
		if (resetn == 0)
			timerfast <= 0;
		else
			timerfast <= timerfast + 1'b1;
			
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



module tflipflop (timer, clock, resetn, q);
	input timer, clock, resetn;
	output reg q;
	
	always @ (posedge clock)
		if (resetn == 0)
			q = 1'b0;
		else if (timer==1)
			q <= ~q;
			
endmodule
