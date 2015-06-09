`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:26:24 05/24/2015 
// Design Name: 
// Module Name:    Error 
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
module Error#(parameter N=19)(

	input signed [N-1:0] ref,yk,
	output signed [N-1:0] error
    );

wire signed [N-1:0] resta_e;

	 
Sumador #(.N(N)) resta_error (
    .DataA(ref), 
    .DataB(-(yk)), 
    .Suma(error)
    );

endmodule
