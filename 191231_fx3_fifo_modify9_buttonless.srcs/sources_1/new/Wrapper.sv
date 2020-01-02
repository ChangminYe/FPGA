`timescale 1ns / 1ps


module Wrapper(
	// clock
	input logic USRCLK_P, USRCLK_N,
	output logic PCLK,

	// button
	input logic RESET,

	// fx3
	input logic FLAGA, FLAGB, FLAGC, FLAGD,

	inout logic [31:0] DQ,

	output logic SLCS_N, SLWR_N, SLRD_N, SLOE_N, PKTEND_N,
	output logic [1:0] A,

	// LED
	output logic [7:0] LED
    );

// definition
logic [7:0] address;
logic [15:0] wr_data, rd_data;
logic wr_en;
logic [15:0] mem;


assign LED[0] = mem[0];
assign LED[1] = mem[1];
assign LED[2] = mem[2];
assign LED[3] = mem[3];
assign LED[4] = mem[4];
assign LED[5] = mem[5];
assign LED[6] = mem[6];
assign LED[7] = mem[7];

// clock module
clk_wiz_0 clk_module(
	.clk_in1_p(USRCLK_P),											
	.clk_in1_n(USRCLK_N),
	.clk_out1(clk)
);

// synchronous output clock module
oddr_0 oddr_module(
	.clk_in(clk),
	.clk_out(PCLK)
	);


// fx3 controller
fx3_controller fx3_controller_module(
	.clk,
	.RESET,

	.FLAGC,
	.DQ,

	.SLCS_N,
	.SLRD_N,
	.SLOE_N,
	.SLWR_N,
	.PKTEND_N,
	.A,

	.rd_data,

	.address,
	.wr_data,
	.wr_en
    );

// bram
bram_mem bram_module(
	.clk,
	.RESET,
		
	.wr_en,
	.address,		
	.wr_data,

	.rd_data,
	.mem
	);

endmodule
