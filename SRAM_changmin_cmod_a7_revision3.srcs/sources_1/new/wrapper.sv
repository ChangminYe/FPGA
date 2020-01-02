// System wrapper. Contains UART controller and SRAM controller

`timescale 1ns / 1ps
module wrapper
	(input logic sysclk,

	 // SRAM interface
	 inout logic [7:0] sram_data,
	 output logic [18:0] sram_addr,
	 output logic ce_n,
	 output logic oe_n,
	 output logic we_n,

	 // UART interface
	 input i_RX_Serial,
	 output o_TX_Serial);

// UART internal signals
logic o_RX_DV, i_TX_DV, o_TX_Active;
logic [7:0] o_RX_Byte, i_TX_Byte;

logic reset;

assign reset = 0;
assign sram_addr[18:16] = 3'b000;

sram_controller sram_controller (
	.*,
	.sram_addr(sram_addr[15:0]));

//   clock module   //
clk_wiz_0 clk_module(
  .clk_in1(sysclk),
  .clk_out1(clk)
 );

//   uart_rx   //
uart_rx #(.CLKS_PER_BIT(868)) uart_rx_module(
   .i_Clock(clk),
   .i_RX_Serial,
   .o_RX_DV,
   .o_RX_Byte
   );

//   uart_tx   //
uart_tx #(.CLKS_PER_BIT(868)) uart_tx_module(
   .i_Clock(clk),
   .i_TX_DV,
   .i_TX_Byte,

   .o_TX_Active,
   .o_TX_Serial,
   .o_TX_Done()
   );

endmodule
