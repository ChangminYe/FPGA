`timescale 1ns / 1ps

module leds(
	input logic clk,
	input logic [1:0] info_type,

	output logic [1:0] led
    );


always @(posedge clk)
	if(info_type == 0)	led <= 0;

	else if(info_type == 1)	led <= 1;

	else if(info_type == 2)	led <= 2;



initial led = 0;


endmodule
