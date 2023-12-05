module chunk_ctrl (clk, chunk_reset, x, y, r, g, b);
	input logic clk, chunk_reset;
	output logic [9:0] x;
	output logic [8:0] y;
	output logic [7:0] r, g, b;
	
	logic ld, load_drawer, incr_done, drawer_done, draw_done;
	logic [1:0] data_in, ctrl_out, draw_out;
	logic [5:0] write_x_chunk, ctrl_x_chunk, draw_x_chunk;
	logic [4:0] write_y_chunk, ctrl_y_chunk, draw_y_chunk;
	logic [31:0] div_clk;
	
	clock_divider div (.clock(clk), .divided_clocks(div_clk));
	
	chunk_drawer #(.CHUNK_SIZE(16)) 
		draw (.clk(clk), .reset(load_drawer | chunk_reset), .data_in(draw_out),
			 .x_chunk(draw_x_chunk), .y_chunk(draw_y_chunk),
			 .x(x), .y(y), .r(r), .g(g), .b(b), .done(drawer_done));
	
	chunk_memory #(.CHUNK_SIZE(16))
		mem (.clk(clk), .reset(chunk_reset), .data_in, .write_x_chunk, .write_y_chunk, 
			 .ctrl_x_chunk, .ctrl_y_chunk, .draw_x_chunk(draw_x_chunk), .draw_y_chunk(draw_y_chunk), 
			 .draw_done(draw_done), .load_drawer(ld), .ctrl_out, .draw_out(draw_out));
			 
	
	incrementor incr (.clk(div_clk[0]), .reset(chunk_reset), .incr(draw_done), .draw_x_chunk(draw_x_chunk), .draw_y_chunk(draw_y_chunk), .done(incr_done));
	
	pulse_flip_flop pff1 (.clk(clk), .reset(chunk_reset), .input_signal(drawer_done), .output_pulse(draw_done));
	pulse_flip_flop pff2 (.clk(clk), .reset(chunk_reset), .input_signal(ld), .output_pulse(load_drawer));
endmodule

module chunk_ctrl_tb ();
	logic clk, chunk_reset;
	logic [9:0] x;
	logic [8:0] y;
	logic [7:0] r, g, b;
	
	chunk_ctrl dut (.*);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		chunk_reset <= 1'b1; @(posedge clk);
		chunk_reset <= 1'b0; @(posedge clk);
		repeat (1000) @(posedge clk);
		$stop;
	end
endmodule