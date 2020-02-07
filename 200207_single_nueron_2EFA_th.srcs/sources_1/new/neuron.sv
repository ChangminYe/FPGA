`timescale 1ns / 1ps

module neuron(
	input logic clk,
	input logic RESET,

	// fx3
	input logic SPIKE_IN,

	output logic MEMB_CAL_END,
	output logic [31:0] MEMBRANE_POTENTIAL,		//case1
	// output logic [15:0] MEMBRANE_POTENTIAL,		//case2
	
	// time address
	input logic [15:0] T_FIX,
	input logic EN_FIX,

	output logic TIME_RESET,

	// amplitue
	input logic [15:0] AMPL_RAM_1,
	input logic [15:0] AMPL_RAM_2,

	output logic [15:0] AMPL_UPDATE_1,
	output logic [15:0] AMPL_UPDATE_2,
	output logic SPIKE_OUT_d
    );

// internal def
logic TIME_RESET_r, TIME_RESET_d;
logic [30:0] MEMBRANE_POTENTIAL_upsc_1, MEMBRANE_POTENTIAL_upsc_2;
logic [31:0] MEMBRANE_POTENTIAL_r_1, MEMBRANE_POTENTIAL_r_2;
logic [31:0] MEMBRANE_POTENTIAL_d;
logic [15:0] SPIKE;
logic wr_en, wr_en_d, wr_en_d2;
logic [15:0] MEMB_THRESHOLD;
logic SPIKE_OUT;
logic END_FLAG;

// exp_fix_def
logic [15:0] Y_FIX_1, Y_FIX_2;
logic END_FLAG_1, END_FLAG_2;
logic Y_FIX;


assign SPIKE = 16'b0000001111011101;
assign MEMB_THRESHOLD = 16'b0000110011001100;

assign END_FLAG = (END_FLAG_1 | END_FLAG_2);

// ---------------------------------------------------
// e^(-x) module
exp_fix_1 exp_fix_1_module(
	.clk(clk),
	.RESET(RESET),
	.T_FIX(T_FIX),
	.EN_FIX(EN_FIX),
	
	.Y_FIX_1(Y_FIX_1),
	.END_FLAG_1(END_FLAG_1)
	);

// ---------------------------------------------------


// ---------------------------------------------------
// e^(-0.6x) module
exp_fix_2 exp_fix_2_module(
	.clk(clk),
	.RESET(RESET),
	.T_FIX(T_FIX),
	.EN_FIX(EN_FIX),
	
	.Y_FIX_2(Y_FIX_2),
	.END_FLAG_2(END_FLAG_2)
	);
// ---------------------------------------------------


// ---------------------------------------------------
always @(posedge clk) begin
	wr_en_d <= wr_en;
	wr_en_d2 <= wr_en_d;
	SPIKE_OUT_d <= SPIKE_OUT;
end
// ---------------------------------------------------


// state machine
typedef enum {IDLE, RANDOM_ACCESS, PERIODIC_UPDATE, MEMB_CAL, TH_CHECK} state_machine;
state_machine state;


// ---------------------------------------------------
// state control
always @(posedge clk) begin
	if(RESET) begin
		state <= IDLE;
	end

	else begin
		case(state)
			IDLE : begin
				MEMBRANE_POTENTIAL <= MEMBRANE_POTENTIAL;
				MEMB_CAL_END <= 0;
				TIME_RESET_r <= 0;
				SPIKE_OUT <= 0;
				wr_en <= 0;

				if(SPIKE_IN && EN_FIX) begin
					state <= RANDOM_ACCESS;
				end

				else if(~SPIKE_IN && EN_FIX) begin
					state <= PERIODIC_UPDATE;
				end

				else begin
					state <= IDLE;
				end
			end

			PERIODIC_UPDATE : begin
				TIME_RESET_r <= 0;
				wr_en <= 0;

				if(END_FLAG) begin
					MEMBRANE_POTENTIAL_upsc_1 <= AMPL_RAM_1 * Y_FIX_1;
					MEMBRANE_POTENTIAL_upsc_2 <= AMPL_RAM_2 * Y_FIX_2;
					state <= MEMB_CAL;
				end

				else begin
					state <= PERIODIC_UPDATE;
				end
			end

			RANDOM_ACCESS : begin
				TIME_RESET_r <= 1;

				if(END_FLAG) begin
					MEMBRANE_POTENTIAL_upsc_1 <= AMPL_RAM_1 * Y_FIX_1;
					MEMBRANE_POTENTIAL_upsc_2 <= AMPL_RAM_2 * Y_FIX_2;
					state <= MEMB_CAL;
					wr_en <= 1;
				end


				else begin
					state <= RANDOM_ACCESS;
				end
			end

			MEMB_CAL : begin
				TIME_RESET_r <= 0;
				wr_en <= 0;
				state <= TH_CHECK;
			end

			TH_CHECK : begin
				MEMB_CAL_END <= 1;

				if(MEMBRANE_POTENTIAL_d >= MEMB_THRESHOLD) begin	// spike out
					TIME_RESET_r <= 1;
					SPIKE_OUT <= 1;
					state <= IDLE;
				end

				else begin											// spike not out
					TIME_RESET_r <= 0;
					SPIKE_OUT <= 0;
					state <= IDLE;
				end
			end

			default : begin
				state <= IDLE;
			end
		endcase // state
	end
end
// ---------------------------------------------------

// ---------------------------------------------------
// memebrane potential control
always @(posedge clk) begin
	if(RESET) begin
		MEMBRANE_POTENTIAL_r_1 <= 16'h8000;
		MEMBRANE_POTENTIAL_r_2 <= 16'h8000;
	end

	else begin
		case(state)
			IDLE : begin
				MEMBRANE_POTENTIAL_r_1 <= MEMBRANE_POTENTIAL_r_1;
				MEMBRANE_POTENTIAL_r_2 <= MEMBRANE_POTENTIAL_r_2;

				if(wr_en_d2) begin
					AMPL_UPDATE_1 <= MEMBRANE_POTENTIAL_r_1;
					AMPL_UPDATE_2 <= MEMBRANE_POTENTIAL_r_2;
				end

				else if(SPIKE_OUT_d) begin
					AMPL_UPDATE_1 <= 0;
					AMPL_UPDATE_2 <= 0;
				end

				else begin
					AMPL_UPDATE_1 <= AMPL_UPDATE_1;
					AMPL_UPDATE_2 <= AMPL_UPDATE_2;
				end
			end

			PERIODIC_UPDATE : begin
				MEMBRANE_POTENTIAL_r_1 <= MEMBRANE_POTENTIAL_r_1;
				MEMBRANE_POTENTIAL_r_2 <= MEMBRANE_POTENTIAL_r_2;
			end

			RANDOM_ACCESS : begin
				MEMBRANE_POTENTIAL_r_1 <= MEMBRANE_POTENTIAL_r_1;
				MEMBRANE_POTENTIAL_r_2 <= MEMBRANE_POTENTIAL_r_2;
			end

			MEMB_CAL : begin
				if(wr_en) begin
					MEMBRANE_POTENTIAL_r_1 <= (MEMBRANE_POTENTIAL_upsc_1 >> 15) + SPIKE;
					MEMBRANE_POTENTIAL_r_2 <= (MEMBRANE_POTENTIAL_upsc_2 >> 15) + SPIKE;
				end

				else begin
					MEMBRANE_POTENTIAL_r_1 <= MEMBRANE_POTENTIAL_upsc_1 >> 15;
					MEMBRANE_POTENTIAL_r_2 <= MEMBRANE_POTENTIAL_upsc_2 >> 15;
				end
			end

			TH_CHECK : begin
				MEMBRANE_POTENTIAL_r_1 <= MEMBRANE_POTENTIAL_r_1;
				MEMBRANE_POTENTIAL_r_2 <= MEMBRANE_POTENTIAL_r_2;
			end

			default : begin
				MEMBRANE_POTENTIAL_r_1 <= MEMBRANE_POTENTIAL_r_1;
				MEMBRANE_POTENTIAL_r_2 <= MEMBRANE_POTENTIAL_r_2;
			end
		endcase // state
	end
end

assign MEMBRANE_POTENTIAL_d = (MEMBRANE_POTENTIAL_r_2 - MEMBRANE_POTENTIAL_r_1);
assign MEMBRANE_POTENTIAL = MEMBRANE_POTENTIAL_d;

// ---------------------------------------------------

// ---------------------------------------------------
// Time reset control
always @(posedge clk) begin
	TIME_RESET_d <= TIME_RESET_r;
end

always @(posedge clk) begin
	if(RESET) begin
		TIME_RESET <= 0;
	end

	else begin
		if(TIME_RESET_d && !(TIME_RESET_r)) begin
			TIME_RESET <= 1;
		end

		else begin
			TIME_RESET <= 0;
		end
	end
end
// ---------------------------------------------------



// ---------------------------------------------------
// initial value
initial
begin
	MEMBRANE_POTENTIAL = 16'h8000;
	MEMBRANE_POTENTIAL_upsc_1 = 16'h8000;
	MEMBRANE_POTENTIAL_upsc_2 = 16'h8000;
	AMPL_UPDATE_1 = 0;
	AMPL_UPDATE_2 = 0;
	MEMB_CAL_END = 0;
	SPIKE_OUT = 0;
	TIME_RESET_r = 0;
	TIME_RESET_d = 0;
	TIME_RESET = 0;
	wr_en = 0;
end
// ---------------------------------------------------
endmodule