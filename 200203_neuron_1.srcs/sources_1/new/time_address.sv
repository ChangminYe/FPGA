`timescale 1ns / 1ps

module time_address(
	input logic clk,
	input logic RESET,

	input logic START_FLAG,
	input logic END_FLAG,
	input logic TIME_RESET,

	output logic [15:0] T_FIX,
	output logic EN_FIX
    );

logic [7:0] TEMPLATE_T, SCALING_T;

assign T_FIX [7:0] = TEMPLATE_T;
assign T_FIX [15:8] = SCALING_T;


// time table address
always @(posedge clk) begin
	if(RESET) begin
		TEMPLATE_T <= 0;
		SCALING_T <= 0;
	end

	else begin
		if(TIME_RESET) begin
			TEMPLATE_T <= 0;
			SCALING_T <= 0;
		end

		else begin
			if(START_FLAG) begin
				EN_FIX <= 1;
				TEMPLATE_T <= TEMPLATE_T + 1;
				
				if(TEMPLATE_T == 8'hff) begin
					SCALING_T <= SCALING_T + 1;
				end

				else begin
					SCALING_T <= SCALING_T;
				end
			end

			else begin
				EN_FIX <= 0;
				TEMPLATE_T <= TEMPLATE_T;
				SCALING_T <= SCALING_T;
			end
		end
	end
end 


initial
begin
	EN_FIX = 0;
	TEMPLATE_T = 0;
	SCALING_T = 0;
end

endmodule