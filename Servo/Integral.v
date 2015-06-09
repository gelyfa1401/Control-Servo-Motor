`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:22:06 05/24/2015 
// Design Name: 
// Module Name:    Integral 
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
module Integ #(parameter N=19)(
	input wire clk,rst,en_reg,
	input wire signed [N-1:0] error,
	output wire signed [N-1:0] ik_actual
    );

wire signed [N-1:0] ResulMult_I,ik_ant,ResulMult_I_reg,error_reg;


RegOpe #(.N(N))Reg6 (
    .clk(clk), 
    .rst(rst), 
    .entrada(error), 
    .salida(error_reg)
    );
	 
Multip #(.N(N))mult_I (
    .A(19'd7), 
    .B(error_reg), 
    .ResulMult(ResulMult_I)
    );
	 
RegOpe #(.N(N))Reg3 (
    .clk(clk), 
    .rst(rst), 
    .entrada(ResulMult_I), 
    .salida(ResulMult_I_reg)
    );
	 
Sumador #(.N(N)) resta_I (
    .DataA(ResulMult_I_reg), 
    .DataB(ik_ant), 
    .Suma(ik_actual)
    );
	 
Registro_Pipeline #(.N(N)) regist_I (
    .clk(clk), 
    .reset(rst), 
    .enable(en_reg), 
    .dato_entrada(ik_actual), 
    .salida(ik_ant)
    );


endmodule
