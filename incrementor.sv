module incrementor (clk, reset, incr, draw_x_chunk, draw_y_chunk, done);
	input logic clk, reset, incr;
	output logic done;
	output logic [5:0] draw_x_chunk;
	output logic [4:0] draw_y_chunk;
	
	always_ff @(posedge clk) begin
		if (reset) begin
			draw_x_chunk <= 6'b0;
			draw_y_chunk <= 5'b0;
			done <= 1'b0;
		end else begin
			if (incr) begin
				if (draw_x_chunk < 6'b101000 & draw_y_chunk < 5'b11110) draw_x_chunk <= draw_x_chunk + 1;
				else if (draw_x_chunk == 6'b101000 & draw_y_chunk < 5'b11110) begin
					draw_y_chunk <= draw_y_chunk + 1;
					draw_x_chunk <= 6'b0;
				end else begin 
					draw_x_chunk <= 6'b0;
					draw_y_chunk <= 5'b0;
				end
			end
		end
	end
endmodule

module incrementor_tb ();
	parameter CHUNK_SIZE = 16;
	
	logic clk, reset, incr;
	logic done;
	logic [5:0] draw_x_chunk;
	logic [4:0] draw_y_chunk;
	
	chunk_ctrl dut (
    .clk(clk),
    .reset(reset),
    .x(x),
    .y(y),
    .r(r),
    .g(g),
    .b(b)
);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		reset <= 1'b1; @(posedge clk);
		incr <= 1'b1; reset <= 1'b0; @(posedge clk);
		repeat (12) @(posedge clk);
		incr <= 1'b0; @(posedge clk);
		repeat (3) @(posedge clk);
		incr <= 1'b1; @(posedge clk);
		repeat (300) @(posedge clk);
		$stop;
	end
endmodule