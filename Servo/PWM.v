`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:26:06 05/21/2015 
// Design Name: 
// Module Name:    PWM 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module PWM(
	input wire clock,rst,
	input wire [7:0] entradaPWM,
	output wire out_CAS
	);

localparam sd = 40;


reg Pwm;

reg [13:0] counter;

always @ (posedge clock)
begin 
	if(rst)
	begin 
	Pwm =0; 
	counter=0;
	end
	else
	begin
	counter = counter+ 1'b1;
	if (counter <= entradaPWM*sd)
		Pwm = 1;
	else 
		Pwm = 0;
	if (counter >= 10000)
		counter = 0;
	end
end
	assign out_CAS = Pwm;
	
endmodule
