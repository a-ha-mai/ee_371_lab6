module chunk_drawer #(parameter CHUNK_SIZE=16) (clk, reset, data_in, x_chunk, y_chunk, x, y, r, g, b, done);
	input logic clk, reset;
	input logic [1:0] data_in;
	input logic [5:0] x_chunk; // change if chunk_size is changed
	input logic [4:0] y_chunk;
	output logic [9:0] x;
	output logic [8:0] y;
	output logic [7:0] r, g, b;
	output logic done;
	
	logic [3:0] count_x, count_y;
	
	always_ff @(posedge clk) begin
		if (reset) begin
			done <= 1'b0;
			count_x <= 4'b0000;
			count_y <= 4'b0000;
			x <= 0;
			y <= 0;
		end else begin
			x <= (x_chunk * CHUNK_SIZE) + count_x;
			y <= (y_chunk * CHUNK_SIZE) + count_y;
		
			if (count_x < 4'b1111 & count_y <= 4'b1111) count_x <= count_x + 1;
			else if (count_x == 4'b1111 & count_y < 4'b1111) begin
				count_y <= count_y + 1;
				count_x <= 4'b0000;
			end else done <= 1'b1;
			
			case (data_in)
				2'b00: begin
					r <= 8'hb7;
					g <= 8'hb7;
					b <= 8'hb7;
				end
				2'b01: begin
					r <= 8'hB2;
					g <= 8'hE1;
					b <= 8'hF2;
				end
				2'b10: begin
					if (count_x < 4 | count_y < 4 | count_x > 11 | count_y > 11) begin
						r <= 8'hC7;
						g <= 8'hB8;
						b <= 8'hE4;
					end else begin
						r <= 8'hb7;
						g <= 8'hb7;
						b <= 8'hb7;
					end
				end
				2'b11: begin
					if (count_x < 4 | count_y < 4 | count_x > 11 | count_y > 11) begin
						r <= 8'hC7;
						g <= 8'hB8;
						b <= 8'hE4;
					end else begin
						r <= 8'hB2;
						g <= 8'hE1;
						b <= 8'hF2;
					end
				end
			endcase
		end
	end
endmodule

module chunk_drawer_tb ();
	parameter CHUNK_SIZE = 16;
	
	logic clk, reset;
	logic [1:0] data_in;
	logic [5:0] x_chunk; // change if chunk_size is changed
	logic [4:0] y_chunk;
	logic [9:0] x;
	logic [8:0] y;
	logic [7:0] r, g, b;
	logic done;
	
	chunk_drawer dut (.*);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		x_chunk <= 6'b000100; y_chunk <= 5'b00100;
		data_in <= 2'b00; reset <= 1'b1; @(posedge clk);
		data_in <= 2'b10; reset <= 1'b0; @(posedge clk);
		repeat (300) @(posedge clk);
		$stop;
	end
endmodule