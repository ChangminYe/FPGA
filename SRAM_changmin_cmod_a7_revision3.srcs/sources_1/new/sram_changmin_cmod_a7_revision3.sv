`timescale 1ns / 1ps

module sram_changmin_cmod_a7_revision3(
	input logic sysclk,
	input logic rx_data_in,

	output logic [1:0] led,
	output logic tx_data_out,
	output logic [18:0] MemAdr,
	output logic [7:0] MemDB,
	output logic RamOEn,
	output logic RamWEn,
	output logic RamCEn
    );


logic clk;
logic rx_data_flag;
logic [7:0] data_in_byte;
logic [1:0] count;

//   data from PC   //
logic [1:0] comment;
logic [$clog2(18):0] adress;
logic [7:0] database;

//   tx   //
logic [7:0] tx_data_in;
logic tx_data_flag;
reg o_tx_active;
reg o_tx_done;


//   clock module   //
clk_wiz_0 clk_module(
  .clk_in1(sysclk),
  .clk_out1(clk)
 );


//   uart_rx   //
uart_rx #(.CLKS_PER_BIT(868)) uart_rx_module(
   .i_Clock(clk),
   .i_RX_Serial(rx_data_in),
   .o_RX_DV(rx_data_flag),
   .o_RX_Byte(data_in_byte)
   );


//   data_discrimination   //
data_discrimination data_discrimination_module(
	.clk(clk),
	.data_in(data_in_byte),
	.flag(rx_data_flag),

	.comment_r(comment),
	.adress_r(adress),
	.database_r(database),
	.flag_count(count)
    );


//   leds   //
leds led_module(
	.clk(clk),
	.info_type(comment),

	.led(led)
    );



//   sram_act   //
sram_act sram_act_module(
	.clk(clk),
	.info_type(comment),
	.adress_r(adress),
	.database_r(database),
	.flag_count(count),

	.sram_adress(MemAdr),
	.sram_database(MemDB),
	.sram_data_read(tx_data_in),
	.sram_data_flag(tx_data_flag),
	.oe(RamOEn),
	.we(RamWEn),
	.ce(RamCEn)
    );



//   uart_tx   //
uart_tx #(.CLKS_PER_BIT(868)) uart_tx_module(
   .i_Clock(clk),
   .i_TX_DV(tx_data_flag),
   .i_TX_Byte(tx_data_in),

   .o_TX_Active(o_tx_active),
   .o_TX_Serial(tx_data_out),
   .o_TX_Done(o_tx_done)
   );


endmodule
