`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:23:15 05/24/2015 
// Design Name: 
// Module Name:    Prop 
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
module Prop #(parameter N=19)(
	input wire clk,rst,
	input wire signed [N-1:0] yk_act,
	output wire signed [N-1:0] out_Prop
    );

wire signed [N-1:0] out_Prop_reg;
	 
Multip #(.N(N))mult_D (
    .A(19'd18), 
    .B(yk_act), 
    .ResulMult(out_Prop_reg)
    );

RegOpe #(.N(N))Reg4 (
    .clk(clk), 
    .rst(rst), 
    .entrada(out_Prop_reg), 
    .salida(out_Prop)
    );
	 
	 
endmodule
