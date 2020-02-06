// Module for calculating exp(-t/tau) function values based on prestored exp values in ROM.
// Implementation based on dividing exp into bins end encoding it in two LUTs: one, storing max value for each bin, and second - storing exp template for all bins.
// Important: This circuit is for FIXED tau value (programmed into LUTs).
`timescale 1ns / 1ps
module exp_fix // #(parameter wA_BIN=8, wA_IND=8, vMAX=2**16-1)
// wT - numenator width
	(
	input logic clk, RESET,
	input logic [15:0] T_FIX,
	input logic EN_FIX,
	
	output logic [15:0] Y_FIX,
	output logic END_FLAG
	);


(*ram_style = "distributed"*) logic [15:0] bin_lut[255:0];			// bin LUT
(*ram_style = "distributed"*) logic [15:0] exp_lut[255:0];			// exp LUT
logic [7:0] bin_addr;												// bin LUT address
logic [7:0] exp_addr;												// exp LUT address
logic [15:0] bin_val, exp_val;										// bin and exp LUT values
logic [15:0] bin_val_d, exp_val_d;									// bin and exp LUT values
logic EN_FIX_r2, EN_FIX_r, END_FLAG_r;
logic [7:0] pc_template_t, pc_scaling_t;

assign pc_template_t = T_FIX [7:0];
assign pc_scaling_t = T_FIX [15:8];

// results after bin and exp LUT value mupltiplication
(*use_dsp = "yes"*) logic [31:0] result_upsc;
(*use_dsp = "yes"*) logic [15:0] result;

// initializing LUTs
initial begin
	$readmemb("template_lut_15_2_e_x.mem", bin_lut);
	$readmemb("scaling_lut_15_2_e_x.mem", exp_lut);
end

// LUT address
always @(posedge clk) begin
	if(RESET) begin
		bin_addr <= 8'hff;
		exp_addr <= 8'hff;
	end

	else begin
		if(EN_FIX) begin
			bin_addr <= pc_template_t;
			exp_addr <= pc_scaling_t;
		end

		else begin
			bin_addr <= bin_addr;
			exp_addr <= exp_addr;
		end
	end
end

// extracting LUT value
assign bin_val = bin_lut[bin_addr];
assign exp_val = exp_lut[exp_addr];

// delay & calculate
always @(posedge clk) begin
	if (RESET) begin
		bin_val_d <= 0;
		exp_val_d <= 0;
	end

	else begin
		bin_val_d <= bin_val;
		exp_val_d <= exp_val;
	end
end

always @(posedge clk) begin
	if (RESET) begin
		result_upsc <= 0;
		result <= 0;
	end

	else begin
		result_upsc <= bin_val_d*exp_val_d;
		result <= result_upsc >> 15;
	end
end

assign Y_FIX = result;



// END_FLAG -----------------------------------------------
always @(posedge clk) begin
	if(RESET) begin
		END_FLAG <= 0;
	end

	else begin
		END_FLAG <= END_FLAG_r;
	end
end

always @(posedge clk) begin
	EN_FIX_r <= EN_FIX;
	EN_FIX_r2 <= EN_FIX_r;
	END_FLAG_r <= EN_FIX_r2;
end


//----------------------------------------------------
// assign END_FLAG = ~END_FLAG_n;

// Initialization
initial begin
	bin_addr = 0;
	exp_addr = 0;
	bin_val_d = 0;
	exp_val_d = 0;
	result_upsc = 0;
	result = 0;
	EN_FIX_r = 0;
	EN_FIX_r2 = 0;
	END_FLAG_r = 0;
	END_FLAG = 0;
end

endmodule