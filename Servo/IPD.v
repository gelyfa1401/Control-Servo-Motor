`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:19:36 05/24/2015 
// Design Name: 
// Module Name:    IPD 
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
module TOP #(parameter N=19)(
	
	input wire clk,rst,inicio_rx,dato,
	//input wire signed [7:0] referencia,
	input wire signed [7:0] referencia1,
	output wire rx_listo,CS,clk_captura,out_CAS,
	output wire [3:0] bits_warning, bits_basuraADC

    );
	 
	 	 
wire signed [N-1:0] ref, I_PD,er,yk_ant,ref_reg,ip,ik_ant,yk,yk_reg,sum_offset,p,i,d,I_PD_reg;
wire [11:0] dato_ADC;
wire signed [7:0] out_dato_ADC;
wire [7:0] entrada_PWM;
wire cont_list,Clk_DNext,enable,enable_cont;
wire [1:0] Val_Next;
reg [1:0] Val_Actual;
reg Clk_DActual;


///////----Detector de flancos----////////

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
assign Clk_DNext =  (Val_Actual==2'b11) ? 1'b1:(Val_Actual==2'b00) ? 1'b0:Clk_DActual;					  
assign fall_edge = ~Clk_DActual&Clk_DNext; 

////////////////////////////////////////////////////////////////////////////////////////

Divisor_Frec ADC_Div (
    .clk_in(clk), 
    .clk_rst(rst), 
    .clk_out(clk_captura)
    );

Registro_Pipeline #(.N(N)) yykk (
    .clk(clk), 
    .reset(rst), 
    .enable(fall_edge), 
    .dato_entrada(yk), 
    .salida(yk_reg)
    );
	 
Registro_Pipeline #(.N(N)) rf (
    .clk(clk), 
    .reset(rst), 
    .enable(fall_edge), 
    .dato_entrada(ref), 
    .salida(ref_reg)
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

assign out_dato_ADC = dato_ADC[11:4];
assign bits_basuraADC  = dato_ADC[3:0];

Sumador #(.N(N)) resta_yk (
    .DataA({11'd0,out_dato_ADC}), 
    .DataB(-(19'd128)), 
    .Suma(yk)
    );
	 
Sumador #(.N(N)) offset_ref (
   .DataA({11'd0,referencia1}), 
   .DataB(-(19'd128)), 
   .Suma(ref)
   );	 
	 
contador_ADC cont_ADC (
    .clk_in(clk), 
    .clk_rst(rst), 
    .enable(enable_cont), 
    .clk_out(cont_list)
    );
	 

Error #(.N(N)) error (
    .ref(ref_reg), 
    .yk(yk_reg), 
    .error(er)
    );
	 
Deriv #(.N(N)) deriva (
    .clk(clk), 
    .rst(rst), 
    .en_reg(fall_edge), 
    .yk_act(yk_reg), 
    .out_dk_reg(d)
    );
	 
Integ #(.N(N)) integr (
    .clk(clk), 
    .rst(rst), 
    .en_reg(fall_edge), 
    .error(er), 
    .ik_actual(i)
    );

Prop #(.N(N)) propc (
	 .clk(clk), 
    .rst(rst), 
    .yk_act(yk_reg), 
    .out_Prop(p)
    );
	 

Sumador #(.N(N)) suma1 (
    .DataA(i), 
    .DataB(-(p)), 
    .Suma(ip)
    );

Sumador #(.N(N)) suma_total (
    .DataA(ip), 
    .DataB(-(d)), 
    .Suma(I_PD)
    );


Sumador #(.N(N)) suma_acond (
    .DataA(I_PD), 
    .DataB(19'd131072), 
    .Suma(sum_offset)
    );

assign entrada_PWM = sum_offset [17:10]; 

PWM pwm_mod (
    .clock(clk), 
	 .rst(rst),
    .entradaPWM(entrada_PWM), 
    .out_CAS(out_CAS)
    );



endmodule
