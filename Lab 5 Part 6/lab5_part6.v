module part6 (SW, CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR);

	input CLOCK_50;
	input [9:0]SW;
	output [0:6]HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output[9:0]LEDR;
	
	
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
			if (A[2] & A[1] & ~A[0]) //reaches 4
				resetslow = 0;
			else
				resetslow = 1;
	end 

	//send to the slow counter
	tflipflop t0 (fastoutput, CLOCK_50, resetslow, A[0]);
	tflipflop t1 (fastoutput & A[0], CLOCK_50, resetslow, A[1]);
	tflipflop t2 (fastoutput & A[0] & A[1], CLOCK_50, resetslow, A[2]);
	tflipflop t3 (fastoutput & A[0] & A[1] & A[2], CLOCK_50, resetslow, A[3]);

	
	
	//now use the A0 A1 and A2 as selects for the multiplexer inputs
	wire [1:0] blank;
	assign blank[1] = 1;
	assign blank[0] = 1;
	
	//6 2 bit outputs for the multiplexers
	wire [11:0] M;
	
	mux_2bit_6to1 m1(A[2:0], SW[1:0], blank[1:0], blank[1:0], blank[1:0], SW[5:4], SW[3:2], M[1:0]);  
	char_7_seg_display h1(M[1:0], HEX0);
	
	mux_2bit_6to1 m2(A[2:0], SW[3:2],SW[1:0] , blank[1:0], blank[1:0], blank[1:0], SW[5:4],  M[3:2]);  
	char_7_seg_display h2(M[3:2], HEX1);
	
	mux_2bit_6to1 m3(A[2:0], SW[5:4], SW[3:2], SW[1:0], blank[1:0], blank[1:0], blank[1:0], M[5:4]);  
	char_7_seg_display h3(M[5:4], HEX2);
	
	mux_2bit_6to1 m4(A[2:0], blank[1:0], SW[5:4], SW[3:2],SW[1:0] , blank[1:0], blank[1:0], M[7:6]);  
	char_7_seg_display h4(M[7:6], HEX3);                                                                                                                                                  
	
	mux_2bit_6to1 m5(A[2:0], blank[1:0], blank[1:0], SW[5:4], SW[3:2], SW[1:0], blank[1:0], M[9:8]); 
	char_7_seg_display h5(M[9:8], HEX4);
	
	mux_2bit_6to1 m6(A[2:0], blank[1:0], blank[1:0], blank[1:0], SW[5:4], SW[3:2], SW[1:0], M[11:10]); 
	char_7_seg_display h6(M[11:10], HEX5);

	
endmodule 



module mux_2bit_6to1 (S, R, X, T, U, V, W, M);
	input [2:0] S;
	input [1:0] R, T, U, V, W, X; 
	output [1:0] M;
	
	assign M[1] = (~S[2]&~S[1]&~S[0]&R[1])|(~S[2]&~S[1]&S[0]&X[1])|(~S[2]&S[1]&~S[0]&T[1])|(~S[2]&S[1]&S[0]&U[1])|(S[2]&~S[1]&~S[0]&V[1])|(S[2]&~S[1]&S[0]&W[1]);
	assign M[0] = (~S[2]&~S[1]&~S[0]&R[0])|(~S[2]&~S[1]&S[0]&X[0])|(~S[2]&S[1]&~S[0]&T[0])|(~S[2]&S[1]&S[0]&U[0])|(S[2]&~S[1]&~S[0]&V[0])|(S[2]&~S[1]&S[0]&W[0]);
	
endmodule

	
module fastcounter (timerfast, clock, resetn);
	input clock, resetn;
	output reg [25:0] timerfast;

	//timerfast <= 0;
	
	//reset the fast timer (26 bit) if resetn is 0 
	//else add 1 
	always @ (posedge clock)
		if (resetn == 0)
			timerfast <= 0;
		else
			timerfast <= timerfast + 1;
			
endmodule 



module char_7_seg_display (C, Display);
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



module tflipflop (timer, clock, resetn, q);
	input timer, clock, resetn;
	output reg q;
	
	always @ (posedge clock)
		if (resetn == 0)
			q = 1'b0;
		else if (timer==1)
			q <= ~q;
			
endmodule
