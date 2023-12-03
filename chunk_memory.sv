module chunk_memory #(parameter CHUNK_SIZE=16)
							(clk, reset, data_in, write_x_chunk, write_y_chunk, 
							ctrl_x_chunk, ctrl_y_chunk, draw_x_chunk, draw_y_chunk, 
							draw_done, load_drawer, ctrl_out, draw_out);
	input logic clk, reset, draw_done;
	input logic [1:0] data_in;
	input logic [5:0] write_x_chunk, ctrl_x_chunk, draw_x_chunk;
	input logic [4:0] write_y_chunk, ctrl_y_chunk, draw_y_chunk;
	output logic load_drawer;
	output logic [1:0] ctrl_out, draw_out;
	
	logic ram [1200:0];
	logic stored_pattern [1200:0];
	
	initial begin
		$readmemb("chunk_memory.mif", stored_pattern);
	end
	
	always_ff @(posedge clk) begin
		if (reset) begin
			ram <= stored_pattern;
			load_drawer <= 1'b0;
		end
		else begin
			ram[(write_y_chunk * CHUNK_SIZE) + write_x_chunk] <= data_in[1];
			if (draw_done) load_drawer <= 1'b1;
			else if (load_drawer == 1'b1) load_drawer <= 1'b0;
		end
	end
	
	assign ctrl_out = {1'b0, ram[(ctrl_y_chunk * CHUNK_SIZE) + ctrl_x_chunk]};
	assign draw_out = {1'b0, ram[(draw_y_chunk * CHUNK_SIZE) + draw_x_chunk]};

endmodule

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