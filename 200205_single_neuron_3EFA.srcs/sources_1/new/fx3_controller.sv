`timescale 1ns / 1ps

module fx3_controller(
	input logic clk,
	input logic RESET,

	output logic [3:0] LED_S,

	// fx3
	input logic FLAGC,
	inout logic [31:0] DQ,

	output logic SLCS_N, SLWR_N, SLRD_N, SLOE_N, PKTEND_N,
	output logic [1:0] A,

	// neuron
	input logic END_FLAG,
	input logic [31:0] MEMBRANE_POTENTIAL,	// case1
	// input logic [15:0] MEMBRANE_POTENTIAL,	// case2
	output logic SPIKE_IN,

	// time_address
	output logic START_FLAG
    );

// internal definition
logic data_cmd;
logic [31:0] pc_cmd;
logic [31:0] data_from_pc, data_to_pc;
logic start, start_r;

// combinational definition
logic SLCS_N_r, SLRD_N_r, SLOE_N_r, SLWR_N_r, PKTEND_N_r;
logic [1:0] A_r;

// DQ
assign data_from_pc = data_cmd ? DQ : 0;
assign DQ = data_cmd ? 32'bz : data_to_pc;

// state machine
typedef enum {IDLE, DATA_IN_1, READ_DEALY_1, CMD_CHECK, DATA_IN_2, READ_DEALY_2, DATA_OUT_READY, DATA_OUT} state_machine;
state_machine state;


// fx3 control ---------------------------------------
// start option
always_comb begin
	if(RESET) begin
		start_r = 0;
	end

	else begin
		if(FLAGC) begin
			start_r = 1;
		end

		else begin
			start_r = 0;
		end
	end
end

// comb logic
always_comb begin
SLCS_N_r = 0;
SLRD_N_r = 1;
SLOE_N_r = 0;
SLWR_N_r = 1;
PKTEND_N_r = 1;
A_r = 2'b11;

	if(RESET) begin
		SLCS_N_r = 0;
		SLRD_N_r = 1;
		SLOE_N_r = 0;
		SLWR_N_r = 1;
		PKTEND_N_r = 1;
		A_r = 2'b11;
	end

	else begin
		case(state)
			IDLE : begin
				SLCS_N_r = 0;
				SLRD_N_r = 1;
				SLOE_N_r = 0;
				SLWR_N_r = 1;
				PKTEND_N_r = 1;
				A_r = 2'b11;
			end

			DATA_IN_1 : begin
				SLCS_N_r = 0;
				SLRD_N_r = 0;
				SLOE_N_r = 0;
				SLWR_N_r = 1;
				PKTEND_N_r = 1;
				A_r = 2'b11;
			end

			READ_DEALY_1 : begin
				SLCS_N_r = 0;
				SLRD_N_r = 1;
				SLOE_N_r = 0;
				SLWR_N_r = 1;
				PKTEND_N_r = 1;
				A_r = 2'b11;
			end

			CMD_CHECK : begin
				SLCS_N_r = 0;
				SLRD_N_r = 1;
				SLOE_N_r = 0;
				SLWR_N_r = 1;
				PKTEND_N_r = 1;
				A_r = 2'b11;
			end

			DATA_IN_2 : begin
				SLCS_N_r = 0;
				SLRD_N_r = 0;
				SLOE_N_r = 0;
				SLWR_N_r = 1;
				PKTEND_N_r = 1;
				A_r = 2'b11;
			end

			READ_DEALY_2 : begin
				SLCS_N_r = 0;
				SLRD_N_r = 1;
				SLOE_N_r = 0;
				SLWR_N_r = 1;
				PKTEND_N_r = 1;
				A_r = 2'b11;
			end

			DATA_OUT_READY : begin
				SLCS_N_r = 0;
				SLRD_N_r = 1;
				SLOE_N_r = 1;
				SLWR_N_r = 1;
				PKTEND_N_r = 1;
				A_r = 2'b11;
			end

			DATA_OUT : begin
				SLCS_N_r = 0;
				SLRD_N_r = 1;
				SLOE_N_r = 1;
				SLWR_N_r = 0;
				PKTEND_N_r = 0;
				A_r = 2'b00;
			end

			default : begin
				SLCS_N_r = 0;
				SLRD_N_r = 1;
				SLOE_N_r = 0;
				SLWR_N_r = 1;
				PKTEND_N_r = 1;
				A_r = 2'b11;
			end
		endcase // state
	end
end

// flip_flop
always @(posedge clk) begin
	SLCS_N <= SLCS_N_r; 
	SLRD_N <= SLRD_N_r;
	SLOE_N <= SLOE_N_r;
	SLWR_N <= SLWR_N_r;
	PKTEND_N <= PKTEND_N_r;
	A <= A_r;
	start <= start_r;
end

// state control
always @(posedge clk) begin
pc_cmd <= data_from_pc [31:0];

	if(RESET) begin
		data_cmd <= 1;
		state <= IDLE;
	end

	else begin
		case(state)
			IDLE : begin
				LED_S <= 1;
				data_cmd <= 1;

				if(start) begin
					state <= DATA_IN_1;
				end

				else begin
					state <= IDLE;
				end
			end

			DATA_IN_1 : begin		// fx3 -> fifo_read
				LED_S <= 2;
				data_cmd <= 1;
				state <= READ_DEALY_1;
			end

			READ_DEALY_1 : begin  // fx3 -> fifo_read (read until empty)
				LED_S <= 3;
				data_cmd <= 1;

				if(!FLAGC) begin
					case(pc_cmd)
						32'hffff : begin
							state <= CMD_CHECK;
						end

						default : begin
							state <= IDLE;
						end
					endcase // pc_cmd
				end

				else begin
					state <= READ_DEALY_1;
				end
			end

			CMD_CHECK : begin	// check if spike occurred when satisfying start command
				LED_S <= 4;
				data_cmd <= 1;
				
				if(start) begin
					state <= DATA_IN_2;
				end

				else begin
					state <= CMD_CHECK;
				end
			end

			DATA_IN_2 : begin	// fx3 -> fifo_read
				LED_S <= 5;
				data_cmd <= 1;
				state <= READ_DEALY_2;
			end

			READ_DEALY_2 : begin	// fx3 -> fifo_read (read until empty)
				LED_S <= 6;
				data_cmd <= 1;

				if(!FLAGC) begin
					case(pc_cmd)
						32'hfcfd : begin
							START_FLAG <= 1;
							SPIKE_IN <= 1;
							state <= DATA_OUT_READY;
						end

						32'hfbfd : begin
							START_FLAG <= 1;
							SPIKE_IN <= 0;
							state <= DATA_OUT_READY;
						end

						default : begin
							SPIKE_IN <= 0;
							START_FLAG <= 0;
							state <= READ_DEALY_2;
						end
					endcase // pc_cmd
				end

				else begin
					state <= READ_DEALY_2;
				end
			end

			DATA_OUT_READY : begin	// calculating membrane potential
				LED_S <= 7;
				data_cmd <= 1;
				SPIKE_IN <= SPIKE_IN;
				START_FLAG <= 0;

				if(END_FLAG) begin
					state <= DATA_OUT;
				end

				else begin
					state <= DATA_OUT_READY;
				end
			end

			DATA_OUT : begin
				LED_S <= 8;
				data_cmd <= 0;
				SPIKE_IN <= 0;
				state <= CMD_CHECK;
			end

			default : begin
				state <= IDLE;
			end
		endcase // state
	end
end
// ---------------------------------------------------



// case 1 -----------------------------------
assign data_to_pc [15:0] = MEMBRANE_POTENTIAL;
assign data_to_pc [31:16] = 0;
// ------------------------------------------


// case 2 -----------------------------------
// assign data_to_pc [15:0] = MEMBRANE_POTENTIAL;
// assign data_to_pc [31:16] = 0;
// ------------------------------------------


// ---------------------------------------------------
//  initial value
initial
begin
	data_cmd = 1;
	START_FLAG = 0;
	SPIKE_IN = 0;
	state = IDLE;
end
// ---------------------------------------------------


endmodule