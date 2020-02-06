`timescale 1ns / 1ps

module Wrapper(
	input logic USRCLK_N, USRCLK_P,
	output logic PCLK,

	// button
	input logic RESET,

	// LEDs
	output logic [7:0] LED,

	// fx3_interface
	input logic FLAGA, FLAGB, FLAGC, FLAGD,

	inout logic [31:0] DQ,							// T_FIX, EN_FIX, Y_FIX

	output logic SLCS_N, SLWR_N, SLRD_N, SLOE_N, PKTEND_N,
	output logic [1:0] A
    );

// clock
logic clk;

// exp_fix interface
logic [15:0] T_FIX, Y_FIX;
logic END_FLAG;

// fx3 controller interface
logic START_FLAG;
logic [3:0] LED_S;
logic WAIT;

// time address interface
logic start;

// clock module
clk_wiz_0 clock_module(
	.clk_in1_n(USRCLK_N),
	.clk_in1_p(USRCLK_P),
	
	.clk_out1(clk)
	);

// oddr module
oddr_0 oddr_module(
	.clk_in(clk),
	
	.clk_out(PCLK)
	);

// fx3 controller module
fx3_controller fx3_controller_module(
	.clk(clk),
	.RESET(RESET),

	.LED_S(LED_S),

	.FLAGC(FLAGC),
	.DQ(DQ),

	.SLCS_N(SLCS_N),
	.SLWR_N(SLWR_N),
	.SLRD_N(SLRD_N),
	.SLOE_N(SLOE_N),
	.PKTEND_N(PKTEND_N),
	.A(A),

	.END_FLAG(END_FLAG),
	.Y_FIX(Y_FIX),

	.START_FLAG(START_FLAG),
	.WAIT(WAIT)
	);

// time address module
time_address time_address_module(
	.clk(clk),
	.RESET(RESET),

	.START_FLAG(START_FLAG),
	.WAIT(WAIT),
	.END_FLAG(END_FLAG),

	.T_FIX(T_FIX),
	.start(start)
	);

// exp_fix_module
exp_fix exp_fix_module(
	.clk(clk),
	.RESET(RESET),

	.T_FIX(T_FIX),
	.EN_FIX(start),
	
	.Y_FIX(Y_FIX),
	.END_FLAG(END_FLAG)
	);

assign LED[7] = FLAGA;
assign LED[6] = FLAGB;
assign LED[5] = FLAGC;
assign LED[4] = FLAGD;
assign LED[3] = LED_S[3];
assign LED[2] = LED_S[2];
assign LED[1] = LED_S[1];
assign LED[0] = LED_S[0];


endmodule
