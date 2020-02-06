`timescale 1ns / 1ps

module amp_ram(
		input logic clk,
		input logic RESET,

		// neuron
		input logic MEMB_CAL_END,
		input logic SPIKE_OUT_d,
		input logic [15:0] AMPL_UPDATE,

		output logic [15:0] AMPL_RAM
		);

logic [15:0] amp_mem;
logic MEMB_CAL_END_d;
logic SPIKE_OUT_d2;

always @(posedge clk) begin
	MEMB_CAL_END_d <= MEMB_CAL_END;
	SPIKE_OUT_d2 <= SPIKE_OUT_d;
end

// BRAM
always @(posedge clk) begin
	if(RESET) begin
		// amp_mem <= 16'b1000000000000000;
		amp_mem <= 0;
	end

	else begin
		if(MEMB_CAL_END_d | SPIKE_OUT_d2) begin
			amp_mem <= AMPL_UPDATE;
			// rd_data <= wr_data;
		end

		else begin
			amp_mem <= amp_mem;
		end
	end
end


assign AMPL_RAM = amp_mem;

// initial value
initial
begin
	// amp_mem = 16'b1000000000000000;
	amp_mem = 0;
end


endmodule