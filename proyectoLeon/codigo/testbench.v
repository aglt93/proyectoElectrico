`include "keyExpansion.v"
`timescale 1ns/10ps

`define w 32
`define b 16
`define t 26
`define c 4

// PROBADOR DEL PIPELINE IF_ID LISTOS.
module probador (clk,rst,key,L_sub_i);
  
  
	// Salidas
  output reg [8*`b-1:0] key;
  output reg rst,clk;
 
	// Entradas.
	

	initial begin
	
    	$dumpfile("prueba.vcd");
		$dumpvars;
		
		clk = 0;
    	pW = 10;
    	qW = 5;
    	key = 128'hFFFEEEE58684FFF05FFE493853000434;
    	rst = 0;
    	#2 rst = 1;
    	#2 rst = 0;
		#170 $finish;
		
	end

	always #5 clk = ~clk;
	
	always @(posedge clk) begin
		L_sub_i = L[]
	end


endmodule


module tester;

  wire [8*`b-1:0] key_sub_i;
  wire [`w-1:0] L_sub_i,L_sub_i_prima;

  probador test(clk,rst,key_sub_i,L_sub_i,L_sub_i_prima);
  keyBytesToWords pegado (clk,rst,key_sub_i,L_sub_i,L_sub_i_prima);

endmodule