module game_of_life (clk, reset, enable, current_frame, next_frame, done);
	input logic clk, reset, enable;
	input logic current_frame [1199:0];
	output logic next_frame [1199:0];
	output logic done;
	
	logic alive_check, oc_done;
	logic [2:0] result;
	logic [7:0] adj_cells;
	logic [10:0] counter;
	logic [31:0] div_clk;
	logic buffer_frame [1199:0];
	
	clock_divider div (.clock(clk), .divided_clocks(div_clk));
	
	ones_counter oc (.clk, .reset, .s(alive_check), .A_val(adj_cells), .done(oc_done), .result);
	
	assign adj_cells = {current_frame[counter - 41], current_frame[counter - 40], current_frame[counter - 39],
							  current_frame[counter - 1], current_frame[counter + 1],
							  current_frame[counter + 39], current_frame[counter + 40], current_frame[counter + 41]};
	
	always_ff @(posedge div_clk[0]) begin
		if (reset) begin
			next_frame <= current_frame;
			alive_check <= 1'b0;
			counter <= 11'b0;
			done <= 1'b0;
		end else if (enable) begin
			if (~oc_done) alive_check <= 1'b1;
			else begin
				alive_check <= 1'b0;
				if (counter < 11'b10010110000) begin
					counter <= counter + 1'b1;
					done <= 1'b0;
				end
				else begin
					done <= 1'b1;
				end
				
				if (current_frame[counter]) begin
					if (result < 3'b010 | result > 3'b011) next_frame[counter] <= 1'b0;
					else next_frame[counter] <= 1'b1;
				end else begin
					if (result == 3'b011) next_frame[counter] <= 1'b1;
				end
			end
		end else begin
			next_frame <= current_frame;
			alive_check <= 1'b0;
			counter <= 11'b0;
			done <= 1'b0;
		end
	end
endmodule

module gom_testbench ();
	logic clk, reset, enable;
	logic current_frame [1199:0];
	logic next_frame [1199:0];
	logic done;
	
	logic stored_pattern [1199:0];
	
	// instantiate module
	game_of_life dut (.*);
	
	// create simulated clock
	parameter CLOCK_PERIOD = 100;
	initial begin
		$readmemb("pixel_memory.mif", stored_pattern);
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end  // clock initial
	
	// simulated inputs
	initial begin
		current_frame <= stored_pattern; @(posedge clk);
		reset <= 1'b1; repeat (3) @(posedge clk);
		enable <= 1'b0; reset <= 1'b0; @(posedge clk);
		repeat (10) @(posedge clk);
		enable <= 1'b1; repeat (10000) @(posedge clk);
		$stop();
	end  // inputs initial
	
endmodule  // DE1_SoC_testbench