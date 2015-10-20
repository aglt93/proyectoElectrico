`include "keyExpansion.v"
`timescale 1ns/10ps

`define w 32
`define b 16
`define t 26
`define c 4

// PROBADOR DEL PIPELINE IF_ID LISTOS.
module probador (clk,rst,pW,qW,key);
  
  
	// Salidas
  output reg [`w-1:0] pW;
  output reg [`w-1:0] qW;
  output reg [8*`b-1:0] key;
  output reg rst,clk;
 
	// Entradas.
	

	initial begin
	
    	$dumpfile("prueba.vcd");
		$dumpvars;
		//$monitor("%d", pegado.);
		
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
	
endmodule


module tester;

  wire [`w-1:0] pW,Qw;
  wire [8*`b-1:0] key;
  wire [`w-1:0] out0,out1,out2,out3;

  probador test(clk,rst,pW,Qw,key);
  keyBytesToWords pegado (clk,rst,pW,Qw,key,out0,out1,out2,out3);

endmodule