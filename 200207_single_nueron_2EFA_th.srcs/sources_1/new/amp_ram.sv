`timescale 1ns / 1ps

module amp_ram(
		input logic clk,
		input logic RESET,

		// neuron
		input logic MEMB_CAL_END,
		input logic SPIKE_OUT_d,
		input logic [15:0] AMPL_UPDATE_1,
		input logic [15:0] AMPL_UPDATE_2,

		output logic [15:0] AMPL_RAM_1,
		output logic [15:0] AMPL_RAM_2
		);

logic MEMB_CAL_END_d;
logic SPIKE_OUT_d2;

always @(posedge clk) begin
	MEMB_CAL_END_d <= MEMB_CAL_END;
	SPIKE_OUT_d2 <= SPIKE_OUT_d;
end

// BRAM
logic [15:0] amp_mem [1:0];
//operation
always @(posedge clk) begin
	if(RESET) begin
		amp_mem[0] <= 0;
		amp_mem[1] <= 0;
	end

	else begin
		if(MEMB_CAL_END_d | SPIKE_OUT_d2) begin
			amp_mem[0] <= AMPL_UPDATE_1;		// e^(-x)
			amp_mem[1] <= AMPL_UPDATE_2;		// e^(-0.6x)
		end

		else begin
			amp_mem[0] <= amp_mem[0];
			amp_mem[1] <= amp_mem[1];
		end
	end
end


assign AMPL_RAM_1 = amp_mem[0];
assign AMPL_RAM_2 = amp_mem[1];

// initial value
initial
begin
	amp_mem[0] = 0;
	amp_mem[1] = 0;
end


endmodule