module chunk_drawer #(parameter CHUNK_SIZE=5'b10000) (clk, reset, data_in, x_chunk, y_chunk, x, y, r, g, b, done);
	input logic clk, reset;
	input logic [1:0] data_in;
	input logic [5:0] x_chunk; // change if chunk_size is changed
	input logic [4:0] y_chunk;
	output logic [9:0] x;
	output logic [8:0] y;
	output logic [7:0] r, g, b;
	output logic done;
	
	always_ff @(posedge clk) begin
		if (reset) begin
			done <= 1'b0;
			x <= x_chunk * CHUNK_SIZE;
			y <= y_chunk * CHUNK_SIZE;
		end else begin
			if ((x == (x_chunk * CHUNK_SIZE) + (CHUNK_SIZE - 1)) && (y == (y_chunk * CHUNK_SIZE) + (CHUNK_SIZE - 1))) begin
				done <= 1'b1;
			end else begin
				case (data_in)
					2'b00: begin
						r <= 8'h00;
						g <= 8'h00;
						b <= 8'h00;
						for (int i = 0; i < CHUNK_SIZE; i++) begin
							x <= x_chunk * CHUNK_SIZE;
							y <= (y_chunk * CHUNK_SIZE) + i;
							for (int j = 0; j < CHUNK_SIZE; j++) begin
								x <= (x_chunk * CHUNK_SIZE) + j;
							end
						end
					end
					2'b01: begin
						r <= 8'hB2;
						g <= 8'hE1;
						b <= 8'hF2;
						for (int i = 0; i < CHUNK_SIZE; i++) begin
							x <= x_chunk * CHUNK_SIZE;
							y <= (y_chunk * CHUNK_SIZE) + i;
							for (int j = 0; j < CHUNK_SIZE; j++) begin
								x <= (x_chunk * CHUNK_SIZE) + j;
							end
						end
					end
					2'b10: begin
						for (int i = 0; i < CHUNK_SIZE; i++) begin
							x <= x_chunk * CHUNK_SIZE;
							y <= (y_chunk * CHUNK_SIZE) + i;
							for (int j = 0; j < CHUNK_SIZE; j++) begin
								if (i < 2 || j < 2 || i > 13 || i > 13) begin
									r <= 8'hC7;
									g <= 8'hB8;
									b <= 8'hE4;
								end else begin
									r <= 8'h00;
									g <= 8'h00;
									b <= 8'h00;
								end
								x <= (x_chunk * CHUNK_SIZE) + j;
							end
						end
					end
					2'b11: begin
						for (int i = 0; i < CHUNK_SIZE; i++) begin
							x <= x_chunk * CHUNK_SIZE;
							y <= (y_chunk * CHUNK_SIZE) + i;
							for (int j = 0; j < CHUNK_SIZE; j++) begin
								if (i < 2 || j < 2 || i > 13 || i > 13) begin
									r <= 8'hC7;
									g <= 8'hB8;
									b <= 8'hE4;
								end else begin
									r <= 8'hFF;
									g <= 8'hFF;
									b <= 8'hFF;
								end
								x <= (x_chunk * CHUNK_SIZE) + j;
							end
						end
					end
				endcase
			end
			
		end
	end
endmodule