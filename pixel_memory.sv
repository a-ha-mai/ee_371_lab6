module pixel_memory (clk, reset, x, y, r, g, b);
	input logic clk, reset;
	input logic [9:0] x;
	input logic [8:0] y;
	output logic [7:0] r, g, b;
	
	logic ram [1199:0];
	logic stored_pattern [1199:0];
	
	initial begin
		$readmemb("pixel_memory.mif", stored_pattern);
	end
	
	always_ff @(posedge clk) begin
		if (reset) begin
			ram <= stored_pattern;
		end else begin
			case (ram[(y * 40) + x])
				1'b0: begin
					r <= 8'h00;
					g <= 8'h00;
					b <= 8'h00;
				end
				1'b1: begin
					r <= 8'hB2;
					g <= 8'hE1;
					b <= 8'hF2;
				end
			endcase
		end
	end
endmodule

/*
module chunk_memory_tb ();
	parameter CHUNK_SIZE = 16;
	
	logic clk, reset, draw_done;
	logic [1:0] data_in;
	logic [5:0] write_x_chunk, ctrl_x_chunk, draw_x_chunk;
	logic [4:0] write_y_chunk, ctrl_y_chunk, draw_y_chunk;
	logic load_drawer;
	logic [1:0] ctrl_out, draw_out;
	
	chunk_memory #(CHUNK_SIZE) dut (.*);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		draw_x_chunk <= 6'b0; draw_y_chunk <= 5'b0;
		reset <= 1'b1; @(posedge clk);
		reset <= 1'b0; @(posedge clk);
		
		draw_x_chunk <= 6'b010100; draw_y_chunk <= 5'b00011; @(posedge clk);
		draw_x_chunk <= 6'b010101; draw_y_chunk <= 5'b00011; @(posedge clk);
		draw_x_chunk <= 6'b010110; draw_y_chunk <= 5'b00011; @(posedge clk);
		draw_x_chunk <= 6'b010111; draw_y_chunk <= 5'b00011; @(posedge clk);
		draw_x_chunk <= 6'b011000; draw_y_chunk <= 5'b00011; @(posedge clk);
		draw_x_chunk <= 6'b011001; draw_y_chunk <= 5'b00011; @(posedge clk);
		draw_x_chunk <= 6'b011010; draw_y_chunk <= 5'b00011; @(posedge clk);
		draw_x_chunk <= 6'b011011; draw_y_chunk <= 5'b00011; @(posedge clk);
		
		draw_x_chunk <= 6'b010100; draw_y_chunk <= 5'b00100; @(posedge clk);
		draw_x_chunk <= 6'b010101; draw_y_chunk <= 5'b00100; @(posedge clk);
		draw_x_chunk <= 6'b010110; draw_y_chunk <= 5'b00100; @(posedge clk);
		draw_x_chunk <= 6'b010111; draw_y_chunk <= 5'b00100; @(posedge clk);
		draw_x_chunk <= 6'b011000; draw_y_chunk <= 5'b00100; @(posedge clk);
		draw_x_chunk <= 6'b011001; draw_y_chunk <= 5'b00100; @(posedge clk);
		draw_x_chunk <= 6'b011010; draw_y_chunk <= 5'b00100; @(posedge clk);
		draw_x_chunk <= 6'b011011; draw_y_chunk <= 5'b00100; @(posedge clk);
		
		draw_x_chunk <= 6'b010100; draw_y_chunk <= 5'b00101; @(posedge clk);
		draw_x_chunk <= 6'b010101; draw_y_chunk <= 5'b00101; @(posedge clk);
		draw_x_chunk <= 6'b010110; draw_y_chunk <= 5'b00101; @(posedge clk);
		draw_x_chunk <= 6'b010111; draw_y_chunk <= 5'b00101; @(posedge clk);
		draw_x_chunk <= 6'b011000; draw_y_chunk <= 5'b00101; @(posedge clk);
		draw_x_chunk <= 6'b011001; draw_y_chunk <= 5'b00101; @(posedge clk);
		draw_x_chunk <= 6'b011010; draw_y_chunk <= 5'b00101; @(posedge clk);
		draw_x_chunk <= 6'b011011; draw_y_chunk <= 5'b00101; @(posedge clk);
		
		draw_x_chunk <= 6'b010100; draw_y_chunk <= 5'b00110; @(posedge clk);
		draw_x_chunk <= 6'b010101; draw_y_chunk <= 5'b00110; @(posedge clk);
		draw_x_chunk <= 6'b010110; draw_y_chunk <= 5'b00110; @(posedge clk);
		draw_x_chunk <= 6'b010111; draw_y_chunk <= 5'b00110; @(posedge clk);
		draw_x_chunk <= 6'b011000; draw_y_chunk <= 5'b00110; @(posedge clk);
		draw_x_chunk <= 6'b011001; draw_y_chunk <= 5'b00110; @(posedge clk);
		draw_x_chunk <= 6'b011010; draw_y_chunk <= 5'b00110; @(posedge clk);
		draw_x_chunk <= 6'b011011; draw_y_chunk <= 5'b00110; @(posedge clk);
		
		
		$stop;
	end
endmodule
*/