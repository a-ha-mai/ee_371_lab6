module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW,
					 CLOCK_50, VGA_R, VGA_G, VGA_B, VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS);
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;

	input CLOCK_50;
	output [7:0] VGA_R;
	output [7:0] VGA_G;
	output [7:0] VGA_B;
	output VGA_BLANK_N;
	output VGA_CLK;
	output VGA_HS;
	output VGA_SYNC_N;
	output VGA_VS;
	
	parameter CHUNK_SIZE = 16;
	
	logic data_out, enable;
	logic [9:0] x;
	logic [8:0] y;
	logic [7:0] r, g, b;
	logic [31:0] div_clk;
	
	clock_divider div (.clock(clk), .divided_clocks(div_clk));
	
	video_driver #(.WIDTH(40), .HEIGHT(30))
		vid (.CLOCK_50(CLOCK_50), .reset(1'b0), .x, .y, .r, .g, .b,
			 .VGA_R, .VGA_G, .VGA_B, .VGA_BLANK_N,
			 .VGA_CLK, .VGA_HS, .VGA_SYNC_N, .VGA_VS);
	
	pixel_memory pm (.clk(CLOCK_50), .reset(SW[9]), .enable(SW[8]), .x, .y, .data_out);
	
	
	always_comb begin
		case (data_out)
			1'b0: begin
				r = 8'h00;
				g = 8'h00;
				b = 8'h00;
			end
			1'b1: begin
				r = 8'hB2;
				g = 8'hE1;
				b = 8'hF2;
			end
			default: begin
				r = 8'h00;
				g = 8'h00;
				b = 8'h00;
			end
		endcase
	end
	
	assign HEX0 = '1;
	assign HEX1 = '1;
	assign HEX2 = '1;
	assign HEX3 = '1;
	assign HEX4 = '1;
	assign HEX5 = '1;

	
endmodule  // DE1_SoC


`timescale 1 ps / 1 ps
module DE1_SoC_testbench ();
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR, SW;
	logic [3:0] KEY;
	logic CLOCK_50;
	logic [7:0] VGA_R, VGA_G, VGA_B;
	logic VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS;
	
	// instantiate module
	DE1_SoC dut (.*);
	
	// create simulated clock
	parameter CLOCK_PERIOD = 100;
	initial begin
		CLOCK_50 <= 0;
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50;
	end  // clock initial
	
	// simulated inputs
	initial begin
		@(posedge CLOCK_50);
		SW[8] <= 1'b0; SW[9] <= 1'b1; repeat (3) @(posedge CLOCK_50);
		SW[8] <= 1'b1; SW[9] <= 1'b0; @(posedge CLOCK_50);
		repeat (100000) @(posedge CLOCK_50);
		$stop();
	end  // inputs initial
	
endmodule  // DE1_SoC_testbench