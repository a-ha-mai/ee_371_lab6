module ones_counter (clk, reset, s, A_val, done, result);

	parameter N = 8;
	parameter logN = 3;

	// port definitions
	input logic clk, reset, s;
	input logic [N-1:0] A_val;
	output logic done;
	output logic [logN-1:0] result;

	// internal signals
	logic load_A, shift_A, incr_result, clr_result;
	logic [N-1:0] A;
	
	// instantiate controller and datapath
	ones_counter_controller #(N) c_unit (.*);
	ones_counter_datapath #(N, logN) d_unit (.*);

endmodule // ones_counter

module ones_counter_tb ();
	parameter N = 8;
	parameter logN = 3;
	
	// inputs
	logic clk, reset, s;
	logic [N-1:0] A_val;
	
	// outputs
	logic done;
	logic [logN-1:0] result;
	
	ones_counter dut (.*);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		s <= 0; A_val <= 8'b01101010;
		reset <= 1; @(posedge clk);
		reset <= 0; @(posedge clk);
		
		repeat (2) @(posedge clk);
		
		s <= 1; repeat (12) @(posedge clk);
		
		A_val <= 8'b11100101;
		s <= 0; repeat (3) @(posedge clk);
		s <= 1; repeat (12) @(posedge clk);
		$stop;
	end
	
endmodule