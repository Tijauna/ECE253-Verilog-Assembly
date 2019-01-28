module part1 (SW, HEX0, HEX1);
	input [7:0] SW; // slide switches
	output [0:6] HEX0; // 7-seg display
	output [0:6] HEX1;


	//SW7-4 as hex1, SW3-0 as hex0
	
	wire s0,s1,s2,s3,s4,s5,s6;
	s0 = SW[0];
	s1 = SW[1];
	s2 = SW[2];
	s3 = SW[3];
	s4 = SW[4];
	s5 = SW[5];
	s6 = SW[6];
	s7 = SW[7];
		
	assign HEX0[0] = (s0&~s1&~s2&~s3)|(s2&~s1&~s0);
	assign HEX0[1] = (~s0&s1&s2)|(s0&~s1&s2);
	assign HEX0[2] = ~s0&s1&~s2;
	assign HEX0[3] = (s0&~s1&~s2)|(~s0&~s1&s2)|(s0&s1&s2);
	assign HEX0[4] = s0|(~s1&s2);
	assign HEX0[5] = (s1&~s2)|(s0&s1)|(s0&~s2&~s3);
	assign HEX0[6] = (~s1&~s2&~s3)|(s0&s1&s2);
	
	assign HEX1[0] = (s4&~s5&~s6&~s7)|(s6&~s5&~s4);
	assign HEX1[1] = (~s4&s5&s6)|(s4&~s5&s6);
	assign HEX1[2] = ~s4&s5&~s6;
	assign HEX1[3] = (s4&~s5&~s6)|(~s4&~s5&s6)|(s4&s5&s6);
	assign HEX1[4] = s4|(~s5&s6);
	assign HEX1[5] = (s5&~s6)|(s4&s5)|(s4&~s6&~s7);
	assign HEX1[6] = (~s5&~s6&~s7)|(s4&s5&s6);
	
end module 