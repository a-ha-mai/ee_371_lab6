module controller #(parameter N=8)
						 (clk, reset, s, A, load_A, shift_A, incr_result, clr_result, done);
	
	// port definitions
	input  logic clk, reset, s; // external
	input logic [N-1:0] A; // status signals
	output logic load_A, shift_A, incr_result, clr_result; // control signals
	output logic done; // external output
	
	// define state names and variables
	enum {S1, S2, S3} ps, ns;
	
	// controller logic w/synchronous reset
	always_ff @(posedge clk)
		if (reset) ps <= S1;
		else ps <= ns;
		
	// next state logic
	always_comb
		case (ps)
			S1: ns = s ? S2 : S1;
			S2: ns = A == 0 ? S3 : S2;
			S3: ns = s ? S3 : S1;
		endcase
	
	// output assignments (mealy)
	assign load_A = (ps == S1) & (s == 0);
	assign incr_result = (ps == S2) & (A != 0) & A[0];
	
	// output assignments (moore)
	assign shift_A = (ps == S2);
	assign clr_result = (ps == S1);
	assign done = (ps == S3);
	
endmodule // controller