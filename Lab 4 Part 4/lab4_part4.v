module part4(SW, LEDR, HEX5, HEX3, HEX1, HEX0);

    input [9:0]SW;
    output [9:0]LEDR;
    output [0:6]HEX5;
    output [0:6]HEX3;
    output [0:6]HEX1;
    output [0:6]HEX0;
    
    //adder setup
    wire [3:0]A = SW[7:4];
    wire [3:0]B = SW[3:0];
    wire [3:0]carry;
    assign carry[0] = SW[8];
	 
	 
    wire [4:0]S;
	 
	 
	//error check
	wire error1, error2;
	smallcomparator check(A, error1);
	smallcomparator check(B, error2);
	 
	assign LEDR[9] = error1|error2;
	 
	 
	 //use the 4 bit adder
    
    fulladder a1(A[0], B[0], carry[0], carry[1], S[0]);
    fulladder a2(A[1], B[1], carry[1], carry[2], S[1]);
    fulladder a3(A[2], B[2], carry[2], carry[3], S[2]);
    fulladder a4(A[3], B[3], carry[3], S[4], S[3]);
    
    //display 
    wire greater9;
    wire [3:0]greater9_4b;
    wire [3:0]circuitA;
    wire [3:0]muxout;
    
    comparator c(S, greater9);
    
    assign greater9_4b[0] = greater9;
    assign greater9_4b[1] = 1'b0;
    assign greater9_4b[2] = 1'b0;
    assign greater9_4b[3] = 1'b0;
    
    //circuit A output
    cir_A c1(S, circuitA);
    
    mux_4_b2to1 m0(S[3:0], circuitA[3:0], greater9, muxout);
    
    //assign binary led output
    assign LEDR[4:0] = S;
    
    //output the original numbers
    seg7num h5(A, HEX5);
    seg7num h3(B, HEX3);
    
    //assign sum
    seg7num h1(greater9_4b,HEX1);
    seg7num h0(muxout, HEX0);
    
endmodule

module fulladder(a, b, c_in, c_out, s);
    input a,b,c_in;
    output c_out,s;
    
    assign c_out = b&a | a&c_in | b&c_in;
    assign s = ~b&~a&c_in | ~b&a&~c_in | b&a&c_in | b&~a&~c_in;
endmodule



module smallcomparator(V, O);
    input [3:0]V;
    output O;
    assign O = V[3]&V[2] | V[3]&V[1];
endmodule




module comparator(V, O);
    input [4:0]V;
    output O;
    
    assign O = V[3]&V[2] | V[3]&V[1] | V[4];
	 
endmodule



module mux_4_b2to1 (U, V, S, O);
    input [3:0] U, V;
    input S;
    output [3:0] O;
    
    assign O[0] = (~S & U[0]) | (S & V[0]);
    assign O[1] = (~S & U[1]) | (S & V[1]);
    assign O[2] = (~S & U[2]) | (S & V[2]);
    assign O[3] = (~S & U[3]) | (S & V[3]);
    
endmodule

module cir_A (V, O);
    input [4:0]V;
    output [3:0]O;
    
    assign O[0] = V[0];
    assign O[1] = ~V[1];
    assign O[2] = V[2]&V[1] | ~V[3]&~V[1];
    assign O[3] = V[4]&V[1];
    
endmodule

module seg7num (V,O);
	input [3:0]V;
    output [0:6]O;
	
	wire t0, t1, t2, t3, t4, t5, t6;
    
    assign t0 = (V[2] & ~V[1] & V[0]) | (V[2] & V[1] & ~V[0]);
    assign t1 = ~V[2] & V[1] & ~V[0];
    assign t2 = (~V[3] & ~V[2] & ~V[1] & V[0]) | (V[2] & ~V[1] & ~V[0]) | (V[2] & V[1] & V[0]);
    assign t3 = V[0] | (V[2] & ~V[1]);
    assign t4 = (~V[3] & ~V[2] & V[0]) | (V[1] & V[0]) | (~V[2] & V[1]);
    assign t5 = (~V[3] & ~V[2] & ~V[1] & V[0]) | (V[2] & ~V[1] & ~V[0]);
    assign t6 = (~V[3] & ~V[2] & ~V[1]) | (V[2] & V[1] & V[0]);
	
	O[0] = t6;
	O[1] = t0;
	O[2] = t1;
	O[3] = t2;
	O[4] = t3;
	O[5] = t4;
	O[6] = t5;
    
endmodule
