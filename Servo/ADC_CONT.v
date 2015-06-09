`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:02:55 06/07/2015 
// Design Name: 
// Module Name:    ADC_CONT 
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
module ADC_CONT(

input wire clk,rst,inicio_rx,dato,
output wire [11:0] dato_ADC,
output wire clk_captura,CS,enable,
output wire [3:0] bits_warning
    );


Divisor_Frec ADC_Div (
    .clk_in(clk), 
    .clk_rst(rst), 
    .clk_out(clk_captura)
    );
	 
contador_ADC cont_ADC (
    .clk_in(clk), 
    .clk_rst(rst), 
    .enable(enable_cont), 
    .clk_out(cont_list)
    );	 
	 
ADC_Recep ADC (
    .clk(clk_captura), 
    .rst(rst), 
    .inicio_rx(inicio_rx), 
    .dato(dato), 
    .listo_cont(cont_list), 
    .CS(CS), 
    .en_cont(enable_cont), 
    .rx_listo(enable), 
    .paquete_bits(dato_ADC), 
    .bits_zero(bits_warning)
    );


endmodule
