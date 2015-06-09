`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:13:57 04/11/2015 
// Design Name: 
// Module Name:    Divisor_Frec 
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
module Divisor_Frec(

 input wire clk_in,
 input wire clk_rst,
 output reg clk_out
 
 ); 
 
 
 reg [12:0] contador ; 

 
always @(posedge clk_in,posedge clk_rst) 

 begin
      if (clk_rst)
		   begin
		   clk_out <= 0;
			contador <= 0;
			end 
      else
          begin		
		    if (contador == 13'd4999)  
		        begin                    
			     contador <=13'd0;       
		        clk_out <= ~clk_out;
		        end 
		     else 
		        contador <= contador + 1'b1; 
          end 
 end 
 
 
endmodule 




