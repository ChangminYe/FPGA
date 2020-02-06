`timescale 1ns / 1ps

module neuron(
	input logic clk,
	input logic RESET,

	// fx3
	input logic SPIKE_IN,

	output logic [31:0] MEMBRANE_POTENTIAL,		//case1
	// output logic [15:0] MEMBRANE_POTENTIAL,		//case2
	
	// time address
	input logic [15:0] T_FIX,
	input logic EN_FIX,

	output logic END_FLAG,
	output logic TIME_RESET
    );

// internal def
logic [31:0] AMPL_RAM;	//case1
// logic [15:0] AMPL_RAM;	//case2
logic [15:0] SPIKE;
logic TIME_RESET_r, TIME_RESET_d;
logic [31:0] MEMBRANE_POTENTIAL_r;
// assign SPIKE = 16'b0000001111011101; // use when case2 begin

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


// state machine
typedef enum {IDLE, RANDOM_ACCESS, PERIODIC_UPDATE} state_machine;
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
				AMPL_RAM <= AMPL_RAM;
				TIME_RESET_r <= 0;

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
				if(END_FLAG) begin
					MEMBRANE_POTENTIAL_r <= (AMPL_RAM * Y_FIX) >> 15;
					MEMBRANE_POTENTIAL <= MEMBRANE_POTENTIAL_r;
					AMPL_RAM <= AMPL_RAM;
					state <= IDLE;
				end

				else begin
					state <= PERIODIC_UPDATE;
				end
			end

			RANDOM_ACCESS : begin
				TIME_RESET_r <= 1;

				if(END_FLAG) begin
					// case 1 -> A(i+1) <= A(i) + U(i) --------------------------
					MEMBRANE_POTENTIAL_r <= ((AMPL_RAM * Y_FIX) >> 15) + AMPL_RAM;
					// MEMBRANE_POTENTIAL <= MEMBRANE_POTENTIAL_r;
					AMPL_RAM <= MEMBRANE_POTENTIAL;
					state <= IDLE;
					// ----------------------------------------------------------


					// // case 2 -> A(i+1) <= A(i) + any constant ----
					// AMPL_RAM <= MEMBRANE_POTENTIAL + SPIKE;
					// state <= IDLE;
					// // --------------------------------------------
				end

				else begin
					state <= RANDOM_ACCESS;
				end
			end

			default : begin
				state <= IDLE;
			end
		endcase // state
	end
end
// ---------------------------------------------------

assign MEMBRANE_POTENTIAL = MEMBRANE_POTENTIAL_r;

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
	MEMBRANE_POTENTIAL_r = 16'h8000;
	END_FLAG = 0;
	TIME_RESET_r = 0;
	TIME_RESET_d = 0;
	TIME_RESET = 0;
	AMPL_RAM = 16'b1000000000000000;
end
// ---------------------------------------------------
endmodule