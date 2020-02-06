`timescale 1ns / 1ps

module amp_ram #(	localparam WIDTH = 16,
					localparam DEPTH = 1)
	(	input logic clk,
		input logic RESET,

		// neuron
		input logic wr_en_d,
		input logic [15:0] AMPL_UPDATE,

		output logic [15:0] AMPL_RAM
		);

// BRAM
(*ram_style="block"*) logic [DEPTH-1:0][WIDTH-1:0] amp_mem;
always @(posedge clk) begin
	if(RESET) begin
		// amp_mem <= 16'b1000000000000000;
		amp_mem <= 0;
	end

	else begin
		if(wr_en_d) begin
			amp_mem <= AMPL_UPDATE;
			// rd_data <= wr_data;
		end

		else begin
			AMPL_RAM <= amp_mem;
		end
	end
end


// initial value
initial
begin
	// amp_mem = 16'b1000000000000000;
	amp_mem = 0;
end


endmodule