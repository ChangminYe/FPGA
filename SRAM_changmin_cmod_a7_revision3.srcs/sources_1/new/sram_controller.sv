`timescale 1ns / 1ps
module sram_controller
	(input logic clk, reset,

	 // UART interface
	 input logic o_RX_DV,
	 input logic [7:0] o_RX_Byte,
	 output logic i_TX_DV,
	 output logic [7:0] i_TX_Byte,
	 input logic o_TX_Active,

	 //SRAM interface
	 inout logic [7:0] sram_data,
	 output logic [15:0] sram_addr,
	 output logic ce_n,
	 output logic oe_n,
	 output logic we_n
	 );

// // SRAM parameters
// localparam DATA_WIDTH = 8;
// localparam ADDR_WIDTH = 16;

// UART COMMANDS
localparam SRAM_READ_CMD = 8'b0000_0001;
localparam SRAM_WRITE_CMD = 8'b0000_0010;

// Controller state definition
typedef enum {IDLE, ADDR_WAIT, SRAM_WRITE, SRAM_READ} state_t;
state_t controller_state;

// SRAM data definitions
logic [7:0] data_from_sram, data_to_sram;
logic data_dir;											// data direction: 0 - data is sent to SRAM; 1 - data is received from SRAM

logic [1:0] count;										// general purpose counter
logic [7:0] cmd;										// command to remember later

// SRAM data control
assign data_from_sram = data_dir ? sram_data : 0;
assign sram_data = data_dir ? 8'bz : data_to_sram;

always @(posedge clk)
	if (reset) begin
		controller_state <= IDLE;
		data_dir <= 1;
		count <= 0;
		oe_n <= 1;
		ce_n <= 1;
		we_n <= 1;
		i_TX_DV <= 0;
	end

	else begin
		case (controller_state)
			IDLE : begin
				oe_n <= 1;
				ce_n <= 1;
				we_n <= 1;
				i_TX_DV <= 0;

				if (o_RX_DV) begin
					cmd <= o_RX_Byte;

					case (o_RX_Byte)
						SRAM_READ_CMD : controller_state <= ADDR_WAIT;
						SRAM_WRITE_CMD : controller_state <= ADDR_WAIT;
						default : controller_state <= IDLE;
					endcase
				end
			end

			ADDR_WAIT : begin
				if (o_RX_DV) begin
					if (count < 1) begin
						count <= count + 1;
						sram_addr[15:8] <= o_RX_Byte;
					end
					else begin
						count <= 0;
						sram_addr[7:0] <= o_RX_Byte;
						 case (cmd)
						 	SRAM_READ_CMD : begin
						 		controller_state <= SRAM_READ;
						 		data_dir <= 1;
						 		ce_n <= 0;
						 		oe_n <= 0;
						 	end
						 	SRAM_WRITE_CMD : begin
						 		controller_state <= SRAM_WRITE;
						 		data_dir <= 0;
						 	end
						 	default : controller_state <= IDLE;
						 endcase
					end
				end
			end

			SRAM_WRITE : begin
				if (o_RX_DV) begin
					data_to_sram <= o_RX_Byte;
					ce_n <= 0;
					we_n <= 0;
					controller_state <= IDLE;
				end
			end

			SRAM_READ : begin
				if (~o_TX_Active) begin
					i_TX_DV <= 1;
					controller_state <= IDLE;
				end
				else begin
					i_TX_DV <= 0;
					controller_state <= SRAM_READ;
				end
			end

		endcase // controller_state
	end

assign i_TX_Byte = data_from_sram;

initial begin
	controller_state = IDLE;
	count = 0;
	ce_n = 1;
	oe_n = 1;
	we_n = 1;
	data_dir = 1;
	i_TX_DV = 0;
end

endmodule
