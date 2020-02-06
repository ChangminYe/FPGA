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

	// exp_fix
	input logic END_FLAG,
	input logic [15:0] Y_FIX,

	// time_address
	output logic START_FLAG,
	output logic WAIT
    );

// internal definition
logic data_cmd;
logic [31:0] pc_cmd;
logic [31:0] data_from_pc, data_to_pc;
logic start, start_r;
logic [5:0] cnt;
logic [$clog2(2047):0] cnt2;
logic [$clog2(2000000):0] cnt3;		// for python minimum time sleep //

// combinational definition
logic SLCS_N_r, SLRD_N_r, SLOE_N_r, SLWR_N_r, PKTEND_N_r;
logic [1:0] A_r;

// DQ
assign data_from_pc = data_cmd ? DQ : 0;
assign DQ = data_cmd ? 32'bz : data_to_pc;

// state machine
typedef enum {IDLE, DATA_IN, READ_DEALY, CALC_READY, DATA_OUT_READY, DATA_OUT, PYTHON_READY} state_machine;
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
WAIT = 0;

	if(RESET) begin
		SLCS_N_r = 0;
		SLRD_N_r = 1;
		SLOE_N_r = 0;
		SLWR_N_r = 1;
		PKTEND_N_r = 1;
		A_r = 2'b11;
		WAIT = 0;
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
				WAIT = 0;
			end

			DATA_IN : begin
				SLCS_N_r = 0;
				SLRD_N_r = 0;
				SLOE_N_r = 0;
				SLWR_N_r = 1;
				PKTEND_N_r = 1;
				A_r = 2'b11;
				WAIT = 0;
			end

			READ_DEALY : begin
				SLCS_N_r = 0;
				SLRD_N_r = 1;
				SLOE_N_r = 0;
				SLWR_N_r = 1;
				PKTEND_N_r = 1;
				A_r = 2'b11;
				WAIT = 0;
			end

			CALC_READY : begin
				SLCS_N_r = 0;
				SLRD_N_r = 1;
				SLOE_N_r = 1;
				SLWR_N_r = 1;
				PKTEND_N_r = 1;
				A_r = 2'b11;
				WAIT = 0;
			end

			DATA_OUT_READY : begin
				SLCS_N_r = 0;
				SLRD_N_r = 1;
				SLOE_N_r = 1;
				SLWR_N_r = 0;
				PKTEND_N_r = 1;
				A_r = 2'b00;
				WAIT = 0;
			end

			DATA_OUT : begin
				SLCS_N_r = 0;
				SLRD_N_r = 1;
				SLOE_N_r = 1;
				SLWR_N_r = 0;
				PKTEND_N_r = 0;
				A_r = 2'b00;
				WAIT = 0;
			end

			PYTHON_READY : begin
				SLCS_N_r = 0;
				SLRD_N_r = 1;
				SLOE_N_r = 1;
				SLWR_N_r = 1;
				PKTEND_N_r = 1;
				A_r = 2'b11;
				WAIT = 1;
			end

			default : begin
				SLCS_N_r = 0;
				SLRD_N_r = 1;
				SLOE_N_r = 0;
				SLWR_N_r = 1;
				PKTEND_N_r = 1;
				A_r = 2'b11;
				WAIT = 0;
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
					state <= DATA_IN;
				end

				else begin
					state <= IDLE;
				end
			end

			DATA_IN : begin		// fx3 -> fifo_read
				LED_S <= 2;
				data_cmd <= 1;
				state <= READ_DEALY;
			end

			READ_DEALY : begin  // fx3 -> fifo_read (read until empty)
				LED_S <= 3;
				data_cmd <= 1;

				if(!FLAGC) begin
					case(pc_cmd)
						32'hffff : begin
							START_FLAG <= 1;
							state <= CALC_READY;
						end

						default : begin
							START_FLAG <= 0;
							state <= IDLE;
						end
					endcase // pc_cmd
				end

				else begin
					state <= READ_DEALY;
				end
			end

			CALC_READY : begin	// exp_fix dealy_cnt
				LED_S <= 4;
				data_cmd <= 1;
				START_FLAG <= 0;
				
				if(END_FLAG | START_FLAG) begin

					if(cnt == 31) begin
						state <= DATA_OUT;
						cnt <= 0;
					end

					else begin
						cnt <= cnt + 1;
						state <= DATA_OUT_READY;
					end
				end

				else begin
					state <= CALC_READY;
				end
			end

			DATA_OUT_READY : begin	// fx3 -> fifo_write
				LED_S <= 5;
				data_cmd <= 0;
				START_FLAG <= 0;
				state <= CALC_READY;
			end

			DATA_OUT : begin
				LED_S <= 6;
				data_cmd <= 0;
				START_FLAG <= 0;

				if(cnt2 == 0) begin
					state <= IDLE;
					cnt2 <= 2047;
				end

				else begin
					state <= PYTHON_READY;
					cnt2 <= cnt2 - 1;
				end
			end

			PYTHON_READY : begin
				data_cmd <= 1;
				cnt <= 1;

				if(cnt3 == 0) begin
					cnt3 <= 2000000;
					state <= DATA_OUT_READY;
					START_FLAG <= 1;
				end

				else begin
					cnt3 <= cnt3 - 1;
					state <= PYTHON_READY;
					START_FLAG <= 0;
				end
			end

			default : begin
				state <= IDLE;
			end
		endcase // state
	end
end

assign data_to_pc [15:0] = Y_FIX;
assign data_to_pc [31:16] = 0;

// ---------------------------------------------------


// initial value
initial
begin
	data_cmd = 1;
	START_FLAG = 0;
	cnt = 0;
	cnt2 = 2047;
	cnt3 = 2000000;
end


endmodule
