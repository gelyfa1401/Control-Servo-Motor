`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:22:44 05/24/2015 
// Design Name: 
// Module Name:    Deriv 
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
module Deriv#(parameter N=19)(
	input wire clk,rst,en_reg,
	input wire signed [N-1:0] yk_act,
	output wire signed [N-1:0] out_dk_reg
    );

wire signed [N-1:0] resta_deriv,yk_ant,resta_deriv_reg,out_dk;


Sumador #(.N(N)) resta_D (
    .DataA(yk_act), 
    .DataB(-(yk_ant)), 
    .Suma(resta_deriv)
    );


RegOpe #(.N(N))Reg1 (
    .clk(clk), 
    .rst(rst), 
    .entrada(resta_deriv), 
    .salida(resta_deriv_reg)
    );

	 
Multip #(.N(N)) mult_D (
    .A(19'd150), 
    .B(resta_deriv_reg), 
    .ResulMult(out_dk)
    );
	 

RegOpe #(.N(N))Reg2 (
    .clk(clk), 
    .rst(rst), 
    .entrada(out_dk), 
    .salida(out_dk_reg)
    );
	 
Registro_Pipeline #(.N(N))regist_D (
    .clk(clk), 
    .reset(rst), 
    .enable(en_reg), 
    .dato_entrada(yk_act), 
    .salida(yk_ant)
    );

endmodule	 
