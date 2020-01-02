`timescale 1ns / 1ps


module fx3_controller(
	input logic clk,
	input logic RESET,

	// fx3
	input logic FLAGC,
	inout logic [31:0] DQ,

	output logic SLCS_N, SLRD_N, SLOE_N, SLWR_N, PKTEND_N,
	output logic [1:0] A,

	// bram
	input logic [15:0] rd_data,

	output logic [7:0] address,
	output logic [15:0] wr_data,
	output logic wr_en
    );

// internal definition
logic data_cmd;
logic [7:0] pc_cmd;
logic [31:0] data_from_pc, data_to_pc;
logic start, start_r;
logic cnt, cnt2;

// combinational definition
logic SLCS_N_r, SLRD_N_r, SLOE_N_r, SLWR_N_r, PKTEND_N_r;
logic [1:0] A_r;
logic wr_en_r;

// DQ
assign data_from_pc = data_cmd ? DQ : 0;
assign DQ = data_cmd ? 32'bz : data_to_pc;

// state machine
typedef enum {IDLE, DATA_IN, READ_DEALY, BRAM_WRITE, BRAM_READ} state_machine;
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
wr_en_r = 0;

	if(RESET) begin
		SLCS_N_r = 0;
		SLRD_N_r = 1;
		SLOE_N_r = 0;
		SLWR_N_r = 1;
		PKTEND_N_r = 1;
		A_r = 2'b11;
		wr_en_r = 0;
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
				wr_en_r = 0;
			end

			DATA_IN : begin
				SLCS_N_r = 0;
				SLRD_N_r = 0;
				SLOE_N_r = 0;
				SLWR_N_r = 1;
				PKTEND_N_r = 1;
				A_r = 2'b11;
				wr_en_r = 0;
			end

			READ_DEALY : begin
				SLCS_N_r = 0;
				SLRD_N_r = 1;
				SLOE_N_r = 0;
				SLWR_N_r = 1;
				PKTEND_N_r = 1;
				A_r = 2'b11;
				wr_en_r = 0;
			end

			BRAM_WRITE : begin
				SLCS_N_r = 0;
				SLRD_N_r = 1;
				SLOE_N_r = 0;
				SLWR_N_r = 1;
				PKTEND_N_r = 1;
				A_r = 2'b11;
				wr_en_r = 1;
			end

			BRAM_READ : begin
				SLCS_N_r = 0;
				SLRD_N_r = 1;
				SLOE_N_r = 1;
				SLWR_N_r = 0;
				PKTEND_N_r = 0;
				A_r = 2'b00;
				wr_en_r = 0;
			end

			default : begin
				SLCS_N_r = 0;
				SLRD_N_r = 1;
				SLOE_N_r = 0;
				SLWR_N_r = 1;
				PKTEND_N_r = 1;
				A_r = 2'b11;
				wr_en_r = 0;
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
	wr_en <= wr_en_r;
	start <= start_r;
end

// state control
always @(posedge clk) begin
pc_cmd <= data_from_pc [7:0];
address <= data_from_pc [15:8];
wr_data <= data_from_pc [31:16];

	if(RESET) begin
		data_cmd <= 1;
		state <= IDLE;
	end

	else begin
		case(state)
			IDLE : begin
				data_cmd <= 1;

				if(start) begin
					state <= DATA_IN;
				end

				else begin
					state <= IDLE;
				end
			end

			DATA_IN : begin		// fx3 -> fifo_read
				data_cmd <= 1;
				state <= READ_DEALY;
			end

			READ_DEALY : begin  // fx3 -> fifo_read (read until empty)
				data_cmd <= 1;

				if(!FLAGC) begin
					case(pc_cmd)
						8'hff : begin
							state <= BRAM_WRITE;
						end

						8'hfe : begin
							state <= BRAM_READ;
						end

						default : begin
							state <= IDLE;
						end
					endcase // pc_cmd
				end

				else begin
					state <= READ_DEALY;
				end
			end

			BRAM_WRITE : begin	// fx3 -> fifo_read
				data_cmd <= 1;
				cnt <= cnt - 1;

				if(cnt == 0) begin
					state <= IDLE;
					cnt <= 1;
				end

				else begin
					state <= BRAM_WRITE;
				end
			end

			BRAM_READ : begin	// fx3 -> fifo_write
				data_cmd <= 0;
				cnt2 <= cnt2 - 1;

				if(cnt2 == 0) begin
					state <= IDLE;
				end

				else begin
					state <= BRAM_READ;
				end
			end

			default : begin
				state <= IDLE;
			end
		endcase // state
	end
end

assign data_to_pc [31:16] = rd_data;
assign data_to_pc [15:0] = 0;

// ---------------------------------------------------


// initial value
initial
begin
	data_cmd = 1;
	cnt = 1;
	cnt2 = 1;
end


endmodule
