`timescale 1ns / 1ps

module bram_mem #(	localparam WIDTH = 16,
					localparam DEPTH = 8)
	(	input logic clk,
		input logic RESET,
		
		// fx3_controller
		input logic wr_en,
		input logic [DEPTH-1:0] address,		
		input logic [WIDTH-1:0] wr_data,

		output logic [WIDTH-1:0] rd_data,
		output logic [15:0] mem
	);


// BRAM 
(*ram_style="block"*) logic [DEPTH-1:0][WIDTH-1:0] r_mem;
// operation
always @(posedge clk) begin
	if(RESET) begin
		r_mem <= 0;
	end

	else begin
		if(wr_en) begin
			r_mem[address] <= wr_data;
			// rd_data <= wr_data;
		end

		else begin
			rd_data <= r_mem[address];
		end
	end
end

assign mem[0] = r_mem[1][0];
assign mem[1] = r_mem[1][1];
assign mem[2] = r_mem[1][2];
assign mem[3] = r_mem[1][3];
assign mem[4] = r_mem[1][4];
assign mem[5] = r_mem[1][5];
assign mem[6] = r_mem[1][6];
assign mem[7] = r_mem[1][7];
assign mem[8] = r_mem[1][8];
assign mem[9] = r_mem[1][9];
assign mem[10] = r_mem[1][10];
assign mem[11] = r_mem[1][11];
assign mem[12] = r_mem[1][12];
assign mem[13] = r_mem[1][13];
assign mem[14] = r_mem[1][14];
assign mem[15] = r_mem[1][15];

endmodule
