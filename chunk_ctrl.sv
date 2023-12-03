module chunk_ctrl (clk, chunk_reset, x, y, r, g, b);
	input logic clk, chunk_reset;
	output logic [9:0] x;
	output logic [8:0] y;
	output logic [7:0] r, g, b;
	
	logic done, draw_done;
	logic [1:0] data_in, ctrl_out, draw_out;
	logic [5:0] write_x_chunk, ctrl_x_chunk, draw_x_chunk;
	logic [4:0] write_y_chunk, ctrl_y_chunk, draw_y_chunk;
	
	chunk_drawer #(.CHUNK_SIZE(16)) 
		draw (.clk(CLOCK_50), .reset(load_drawer), .data_in(draw_out),
			 .x_chunk(draw_x_chunk), .y_chunk(draw_y_chunk),
			 .x(x), .y(y), .r(r), .g(g), .b(b), .done(draw_done));
	
	chunk_memory #(.CHUNK_SIZE(16))
		mem (.clk(CLOCK_50), .reset(chunk_reset), .data_in, .write_x_chunk, .write_y_chunk, 
			 .ctrl_x_chunk, .ctrl_y_chunk, .draw_x_chunk(draw_x_chunk), .draw_y_chunk(draw_y_chunk), 
			 .draw_done(draw_done), .load_drawer(load_drawer), .ctrl_out, .draw_out(draw_out));
			 
	incrementor incr (.clk(CLOCK_50), .reset(chunk_reset), .incr(draw_done), .draw_x_chunk(draw_x_chunk), .draw_y_chunk(draw_y_chunk), .done(done));
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
		repeat (300) @(posedge clk);
		$stop;
	end
endmodule