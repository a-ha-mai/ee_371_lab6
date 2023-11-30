module chunk_memory (clk, reset, data_in, write_x_chunk, write_y_chunk, 
							ctrl_x_chunk, ctrl_y_chunk, draw_x_chunk, draw_y_chunk, 
							draw_done, load_val, ctrl_out, draw_out);
	input logic clk, reset, draw_done;
	input logic [1:0] data_in;
	input logic [5:0] write_x_chunk, ctrl_x_chunk, draw_x_chunk;
	input logic [4:0] write_y_chunk, ctrl_y_chunk, draw_y_chunk;
	output logic load_val;
	output logic [1:0] ctrl_out, draw_out;
	
	logic [1:0] ram [10:0];
	parameter CHUNK_SIZE = 16;
	
	assign ctrl_out = ram[(ctrl_y_chunk * CHUNK_SIZE) + ctrl_x_chunk];
	assign draw_out = ram[(draw_y_chunk * CHUNK_SIZE) + draw_x_chunk];

endmodule