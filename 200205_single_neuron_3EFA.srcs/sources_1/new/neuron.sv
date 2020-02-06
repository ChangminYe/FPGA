`timescale 1ns / 1ps

module neuron(
	input logic clk,
	input logic RESET,

	// fx3
	input logic SPIKE_IN,

	output logic END_FLAG,
	output logic [31:0] MEMBRANE_POTENTIAL,		//case1
	// output logic [15:0] MEMBRANE_POTENTIAL,		//case2
	
	// time address
	input logic [15:0] T_FIX,
	input logic EN_FIX,

	output logic TIME_RESET,

	// amplitue
	input logic [15:0] AMPL_RAM,

	output logic [15:0] AMPL_UPDATE,
	output logic wr_en_d
    );

// internal def
logic TIME_RESET_r, TIME_RESET_d;
logic [30:0] MEMBRANE_POTENTIAL_upsc;
logic [31:0] MEMBRANE_POTENTIAL_r;
assign SPIKE = 16'b0000001111011101;
logic wr_en;

// exp_fix_def
logic [15:0] Y_FIX;


// ---------------------------------------------------
// exp_fix_module
exp_fix exp_fix_module(
	.clk(clk),
	.RESET(RESET),
	.T_FIX(T_FIX),
	.EN_FIX(EN_FIX),
	
	.Y_FIX(Y_FIX),
	.END_FLAG(END_FLAG)
	);

// ---------------------------------------------------


// ---------------------------------------------------
always @(posedge clk) begin
	wr_en_d <= wr_en;
end
// ---------------------------------------------------


// state machine
typedef enum {IDLE, RANDOM_ACCESS, PERIODIC_UPDATE, MEMB_CAL} state_machine;
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
				TIME_RESET_r <= 0;
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
					MEMBRANE_POTENTIAL_upsc <= AMPL_RAM * Y_FIX;
					state <= MEMB_CAL;
				end

				else begin
					state <= PERIODIC_UPDATE;
				end
			end

			RANDOM_ACCESS : begin
				TIME_RESET_r <= 1;

				if(END_FLAG) begin
					MEMBRANE_POTENTIAL_upsc <= AMPL_RAM * Y_FIX;
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
				state <= IDLE;
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
		MEMBRANE_POTENTIAL_r <= 16'h8000;
	end

	else begin
		case(state)
			IDLE : begin
				MEMBRANE_POTENTIAL_r <= MEMBRANE_POTENTIAL_r;

				if(wr_en_d) begin
					AMPL_UPDATE <= MEMBRANE_POTENTIAL_r;
				end

				else begin
					AMPL_UPDATE <= AMPL_UPDATE;
				end
			end

			PERIODIC_UPDATE : begin
				MEMBRANE_POTENTIAL_r <= MEMBRANE_POTENTIAL_r;
			end

			RANDOM_ACCESS : begin
				MEMBRANE_POTENTIAL_r <= MEMBRANE_POTENTIAL_r;
			end

			MEMB_CAL : begin
				if(wr_en) begin
					MEMBRANE_POTENTIAL_r <= (MEMBRANE_POTENTIAL_upsc >> 15) + SPIKE;
				end

				else begin
					MEMBRANE_POTENTIAL_r <= MEMBRANE_POTENTIAL_upsc >> 15;
				end
				
			end

			default : begin
				MEMBRANE_POTENTIAL_r <= MEMBRANE_POTENTIAL_r;
			end
		endcase // state
	end
end


assign MEMBRANE_POTENTIAL = MEMBRANE_POTENTIAL_r;

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
	MEMBRANE_POTENTIAL_upsc = 16'h8000;
	// AMPL_UPDATE = 16'h8000;
	AMPL_UPDATE = 0;
	END_FLAG = 0;
	TIME_RESET_r = 0;
	TIME_RESET_d = 0;
	TIME_RESET = 0;
	wr_en = 0;
end
// ---------------------------------------------------
endmodule