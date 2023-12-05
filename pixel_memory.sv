module pixel_memory (clk, reset, enable, x, y, data_out);
	input logic clk, reset, enable;
	input logic [9:0] x;
	input logic [8:0] y;
	output logic data_out;
	
	logic done, load_frame;
	logic [31:0] div_clk;
	logic current_frame [1199:0];
	logic next_frame [1199:0];
	logic stored_pattern [1199:0];
	
	clock_divider div (.clock(clk), .divided_clocks(div_clk));
	
	game_of_life gol (.clk(clk), .reset(reset | load_frame), .enable, .current_frame, .next_frame, .done);
	
	initial begin
		$readmemb("pixel_memory.mif", stored_pattern);
	end
	
	assign data_out = next_frame[(y * 40) + x];
	
	always_ff @(posedge div_clk[20]) begin
		if (reset) begin
			current_frame <= stored_pattern;
			load_frame <= 1'b1;
		end else begin
			if (done) begin
				current_frame <= next_frame;
				load_frame <= 1'b1;
			end else load_frame <= 1'b0;
		end
	end
endmodule

/*
module pixel_memory_tb ();
	logic clk, reset, enable;
	logic [9:0] x;
	logic [8:0] y;
	logic [7:0] r, g, b;
	
	pixel_memory dut (.*);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		@(posedge clk);
		reset <= 1'b1; repeat (5) @(posedge clk);
		enable <= 1'b1; reset <= 1'b0; @(posedge clk);
		repeat (10000) @(posedge clk);
		$stop();
	end
endmodule
*/