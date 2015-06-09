`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:15:31 06/07/2015 
// Design Name: 
// Module Name:    contador_ADC 
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
module contador_ADC(

 input wire clk_in,clk_rst,enable,
 output reg clk_out
 
 ); 
 
 
reg [17:0] contador ; 

 
always @(posedge clk_in,posedge clk_rst) 

 begin
      if (clk_rst)
		   begin
		   clk_out <= 0;
			contador <= 0;
			end 
      else if (enable)
        begin		
		    if (contador == 18'd249999)  
		        begin                    
			     contador <=18'd0;       
		        clk_out <= ~clk_out;
		        end 
		     else 
		        contador <= contador + 1'b1; 
          end 
		else 
			begin
				contador <= 0;       
		      clk_out <= 0;
			end
		
end 
 
 
endmodule 