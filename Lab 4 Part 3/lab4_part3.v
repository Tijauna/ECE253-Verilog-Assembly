module part3 (SW, LEDR);
    input [9:0] SW;
    output [4:0] LEDR;
    
    wire [3:0]A = SW[7:4];
    wire [3:0]B = SW[3:0];
	 
    wire [3:0]carry;
    assign carry[0] = SW[8];
    
    wire [3:0]S;
    wire c_out;
  
    
    fulladder a1(A[0], B[0], carry[0], carry[1], S[0]);
    fulladder a2(A[1], B[1], carry[1], carry[2], S[1]);
    fulladder a3(A[2], B[2], carry[2], carry[3], S[2]);
    fulladder a4(A[3], B[3], carry[3], c_out, S[3]);
    
    assign LEDR[3:0] = S;
    assign LEDR[4] = c_out;
    
endmodule


module fulladder(a, b, c_in, c_out, s);
    input a,b,c_in;
    output s,c_out;
    
    assign c_out = b&a | a&c_in | b&c_in;
    assign s = ~b&~a&c_in | ~b&a&~c_in | b&a&c_in | b&~a&~c_in;
endmodule
