`include "keyExpansion.v"
`timescale 1ns/10ps

`define w 32 // Cantidad de bits por palabra.
`define u 4 // Cantidad de bytes por palabra.
`define b 16 // Cantidad de bytes de la llave.
`define b_length 4 // Bits para direccionar a todos los bytes b de la llave.
`define t 26 // Cantidad de rondas.
`define c 4 // Tamaño del vector L. Corresponde a b/u.
`define c_length 2 // Cantidad de bits para direccionar al vector L.

module probador 
(
	output reg rst,
	output reg clk1,
	output reg clk2,
	output reg [8*`b-1:0] key,
	output reg [`w-1:0] L_sub_i,
	output reg [7:0] key_sub_i,
	input [`b_length-1:0] key_address,
	input [`c_length-1:0] L_address,
	input [`w-1:0] L_sub_i_prima
);

	integer i;

  	reg [`w-1:0] L [`c:0];
  	reg [7:0] keyInBytes [`b-1:0];

  	`include "driver.v"

	initial begin

    	$dumpfile("prueba.vcd");
		$dumpvars;
		
		key = 128'hFFFEEEE58684FFF05FFE493853000434;
		clk1 = 0;

		drv_init();

		repeat(20) begin
			fork 
				drv_write();
				drv_read();
			join
		end

		/*
		for (i=0;i<`c;i=i+1) begin
			L[i]=0;
		end

		key = 128'hFFFEEEE58684FFF05FFE493853000434;

		for (i=0;i<`b;i=i+1) begin
			keyInBytes[i]=5+i;
		end
		clk1 = 0;

    	rst = 0;
    	#3 rst = 1;
    	#1 rst = 0;
    	*/


		#2 $finish;
		
	end

	always #5 clk1 = ~clk1;	

	always @(*) begin
  		clk2 = #0.5 clk1;
  	end

  	/*
	always @(posedge clk2) begin
		L_sub_i = L[L_address];
		key_sub_i = keyInBytes[key_address];
	end

	always @(negedge clk2) begin
		L[L_address] = L_sub_i_prima;	
	end
	*/

endmodule


module tester;

  wire [7:0] key_sub_i;
  wire [`w-1:0] L_sub_i,L_sub_i_prima;
  wire [`b_length-1:0] key_address;
  wire [`c_length-1:0] L_address;
 
  probador test
  (
  	.clk1(clk1),
  	.clk2(clk2),
  	.rst(rst),
  	.key_sub_i(key_sub_i),
  	.L_sub_i(L_sub_i),
  	.L_sub_i_prima(L_sub_i_prima),
  	.key_address(key_address),
  	.L_address(L_address)
  );
  
  keyBytesToWords  
  #(
  	.b(`b),
  	.b_length(`b_length),
  	.w(`w),
  	.u(`u),
  	.c(`c),
  	.c_length(`c_length)
  )
  pegado 
  (
  	.clk1(clk1),
  	.clk2(clk2),
  	.rst(rst),
  	.key_sub_i(key_sub_i),
  	.L_sub_i(L_sub_i),
  	.L_sub_i_prima(L_sub_i_prima),
  	.key_address(key_address),
  	.L_address(L_address)
   );

endmodule