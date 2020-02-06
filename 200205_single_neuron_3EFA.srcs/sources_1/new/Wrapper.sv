`timescale 1ns / 1ps

module Wrapper(
	// clock
	input logic USRCLK_P, USRCLK_N,
	output logic PCLK,

	// button
	input logic RESET,

	// LEDs
	output logic [7:0] LED,

	// fx3_interface
	input logic FLAGA, FLAGB, FLAGC, FLAGD,

	inout logic [31:0] DQ,

	output logic SLCS_N, SLWR_N, SLRD_N, SLOE_N, PKTEND_N,
	output logic [1:0] A
    );

// clock def
logic clk;


// fx3 controller def
logic [3:0] LED_S;
logic START_FLAG;
logic SPIKE_IN;


// time address def
logic [15:0] T_FIX;
logic EN_FIX;


// amplitude ram def
logic [15:0] AMPL_RAM;


// neuron def
logic [31:0] MEMBRANE_POTENTIAL;	//case1
// logic [15:0] MEMBRANE_POTENTIAL;	//case2
logic END_FLAG;
logic TIME_RESET;
logic [31:0] AMPL_UPDATE;
logic wr_en_d;



// clock module
clk_wiz_0 clk_module(
    .clk_in1_p(USRCLK_P),
	.clk_in1_n(USRCLK_N),

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

	// fx3
	.FLAGC(FLAGC),
	.DQ(DQ),

	.SLCS_N(SLCS_N),
	.SLWR_N(SLWR_N),
	.SLRD_N(SLRD_N),
	.SLOE_N(SLOE_N),
	.PKTEND_N(PKTEND_N),
	.A(A),

	// neuron
	.END_FLAG(END_FLAG),
	.MEMBRANE_POTENTIAL(MEMBRANE_POTENTIAL),
	.SPIKE_IN(SPIKE_IN),

	// time_address
	.START_FLAG(START_FLAG)
	);

// time stamp module
time_address time_address_module(
	.clk(clk),
	.RESET(RESET),

	.START_FLAG(START_FLAG),
	.TIME_RESET(TIME_RESET),

	.T_FIX(T_FIX),
	.EN_FIX(EN_FIX)
    );


// amplitude ram module
amp_ram amp_ram_module(
	.clk(clk),
	.RESET(RESET),

	.wr_en_d(wr_en_d),
	.AMPL_UPDATE(AMPL_UPDATE),

	.AMPL_RAM(AMPL_RAM)
	);


// neuron module
neuron neuron_module(
	.clk(clk),
	.RESET(RESET),

	// fx3
	.SPIKE_IN(SPIKE_IN),

	.END_FLAG(END_FLAG),
	.MEMBRANE_POTENTIAL(MEMBRANE_POTENTIAL),
	
	// time address
	.T_FIX(T_FIX),
	.EN_FIX(EN_FIX),
	

	.TIME_RESET(TIME_RESET),

	// amplitude
	.AMPL_RAM(AMPL_RAM),

	.AMPL_UPDATE(AMPL_UPDATE),
	.wr_en_d(wr_en_d)
	);


assign LED[3:0] = LED_S;
assign LED[4] = FLAGA;
assign LED[5] = FLAGB;
// assign LED[6] = FLAGC;
assign LED[7] = FLAGD;

endmodule
