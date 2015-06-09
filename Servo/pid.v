`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:14:36 05/26/2015 
// Design Name: 
// Module Name:    pid 
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
module pid(
	
	input wire clk,rst,enable,
	input wire signed [11:0] referencia,yk,
	output wire signed [11:0] I_PD
    );
	 
wire signed[11:0]er,yk_ant,ip,ik_ant,yk_reg,ref_reg;
wire signed [11:0] p,i,d;



reg [1:0] Val_Actual;
wire [1:0] Val_Next;
reg Clk_DActual;
wire Clk_DNext;

//Detector de flancos

always @(posedge clk, posedge rst)

  if (rst)
     begin 
	      Val_Actual <= 0;
			Clk_DActual <= 0;
	  end 
	  
  else 
     begin 
	      Val_Actual <= Val_Next;
			Clk_DActual <= Clk_DNext;
	  end 
	
	assign Val_Next =  {enable,Val_Actual[1]};
   assign Clk_DNext =  (Val_Actual==2'b11) ? 1'b1:
		                 (Val_Actual==2'b00) ? 1'b0:
								  Clk_DActual;
								  
	assign fall_edge = ~Clk_DActual&Clk_DNext; 

Registro_Pipeline #(.N(12)) yykk (
    .clk(clk), 
    .reset(rst), 
    .enable(fall_edge), 
    .dato_entrada(yk), 
    .salida(yk_reg)
    );
	 
Registro_Pipeline #(.N(12)) rf (
    .clk(clk), 
    .reset(rst), 
    .enable(fall_edge), 
    .dato_entrada(referencia), 
    .salida(ref_reg)
    );

Error error (
    .ref(ref_reg), 
    .yk(yk_reg), 
    .error(er)
    );
	 
Deriv deriva (
    .clk(clk), 
    .rst(rst), 
    .en_reg(fall_edge), 
    .yk_act(yk_reg), 
    .out_dk(d)
    );
	 
Integ integr (
    .clk(clk), 
    .rst(rst), 
    .en_reg(fall_edge), 
    .error(er), 
    .ik_actual(i)
    );

Prop propc (
    .yk_act(yk_reg), 
    .out_Prop(p)
    );

Sumador #(.N(12)) suma1 (
    .DataA(i), 
    .DataB(-(p)), 
    .Suma(ip)
    );

Sumador #(.N(12)) suma_total (
    .DataA(ip), 
    .DataB(-(d)), 
    .Suma(I_PD)
    );
	 

endmodule
