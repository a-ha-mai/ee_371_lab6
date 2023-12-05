module ones_counter_datapath #(parameter N=8, logN=3)
					  (clk, A_val, load_A, shift_A, incr_result, clr_result, A, result);

	// port definitions
	input logic clk; // external inputs
	input logic [N-1:0] A_val;
	input logic load_A, shift_A, incr_result, clr_result; // control signals
	output logic [N-1:0] A; // status signal
	output logic [logN-1:0] result; // external output
	
	// datapath logic
	always_ff @(posedge clk) begin
		if (load_A) A <= A_val;
		else if (shift_A) A <= A >> 1;
		
		if (clr_result) result <= 0;
		else if (incr_result) result <= result + 1;
	end
endmodule // ones_counter_datapath