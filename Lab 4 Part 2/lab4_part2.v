module part2 (SW, HEX0, HEX1);
	input [3:0] SW;
	output [0:6] HEX0; // 7-seg display
	output [0:6] HEX1;
	
	wire v0,v1,v2,v3;
	assign v0 = SW[0];
	assign v1 = SW[1];
	assign v2 = SW[2];
	assign v3 = SW[3];
	
	//comparator
	wire z0, z1, z2, z3;
	assign z0 = (v3&v2)| (v3&v1);
	assign z1 = 1'b0;
	assign z2 = 1'b0;
	assign z3 = 1'b0;
	
	assign HEX1[0] = (z2 & ~z1 & z0) | (z2 & z1 & ~z0);
	assign HEX1[1] = ~z2 & z1 & ~z0;
	assign HEX1[2] = (~z3 & ~z2 & ~z1 & z0) | (z2 & ~z1 & ~z0) | (z2 & z1 & z0);
	assign HEX1[3] = z0 | (z2 & ~z1);
   assign HEX1[4] = (~z3 & ~z2 & z0) | (z1 & z0) | (~z2 & z1);
	assign HEX1[5] = (~z3 & ~z2 & ~z1 & z0) | (z2 & ~z1 & ~z0);
	assign HEX1[6] = (~z3 & ~z2 & ~z1) | (z2 & z1 & z0);
	
	wire [3:0] A;

	//multiplexer
	
	//create circuit A
	assign A[0] = v0;
	assign A[1] = ~v1;
	assign A[2] = v2&v1;
	assign A[3] = 1'b0;
	
	wire s0, s1, s2, s3;
	
	assign s0 = (~z0&v0)|(z0&A[0]);
	assign s1 = (~z0&v1)|(z0&A[1]);
	assign s2 = (~z0&v2)|(z0&A[2]);
	assign s3 = (~z0&v3)|(z0&A[3]);
	
	wire t0, t1, t2, t3, t4, t5, t6;
	
	assign t0 = (s2 & ~s1 & s0) | (s2 & s1 & ~s0);
	assign t1 = ~s2 & s1 & ~s0;
	assign t2 = (~s3 & ~s2 & ~s1 & s0) | (s2 & ~s1 & ~s0) | (s2 & s1 & s0);
	assign t3 = s0 | (s2 & ~s1);
   assign t4 = (~s3 & ~s2 & s0) | (s1 & s0) | (~s2 & s1);
	assign t5 = (~s3 & ~s2 & ~s1 & s0) | (s2 & ~s1 & ~s0);
	assign t6 = (~s3 & ~s2 & ~s1) | (s2 & s1 & s0);
	
	assign HEX[0] = t6;
	assign HEX[1] = t0;
	assign HEX[2] = t1;
	assign HEX[3] = t2;
	assign HEX[4] = t3;
	assign HEX[5] = t4;
	assign HEX[5] = t5;

	
endmodule 
	