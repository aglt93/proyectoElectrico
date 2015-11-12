`timescale 1ns/10ps

`include "decipher_dut.v"

`define w 32 // Cantidad de bits por palabra.
`define u 4 // Cantidad de bytes por palabra.
`define b 16 // Cantidad de bytes de la llave.
`define b_length $clog2(`b) // Bits para direccionar a todos los bytes b de la llave.
`define r 12 // Cantidad de rondas.
`define t 2*(`r+1) // Tamaño del vector S es igual a 2 (r+1) donde r es la cantidad de rondas.
`define t_length $clog2(`t) // Cantidad de bit para direccionar al vector S.
`define c 4 // Tamaño del vector L. Corresponde a b/u.
`define c_length 2 // Cantidad de bits para direccionar al vector L.
`define pW 32'hB7E15163 // Constantes
`define qW 32'h9E3779B9 //

module testbench;

	integer i;
	reg [127:0] key;
	reg clk;
	reg rst;

	wire done;
	reg [`w-1:0] A;
	reg [`w-1:0] B;
	wire [`w-1:0] A_cipher;
	wire [`w-1:0] B_cipher;


	parameter W = 32;
	parameter C = 4;
	parameter b = 16;
	parameter R = 12;
	parameter QW = `qW;


	decipher_dut 
	#(
		.W(W),
		.C(C),
		.B(b),
		.R(R),
		.QW(QW)		
	)
		dut
	(
		clk,
		rst,
		A,
		B,
		A_cipher,
		B_cipher,
		done
	);

	initial begin
		
		$dumpfile("decipher.vcd");
		$dumpvars;
		clk=0;
		rst = 0;
		key = 128'h915F4619BE41B2516355A50110A9CE91;

		for (i = 0; i < `c; i = i + 1) begin
			dut.L_RAM.ram[i]=0;
		end

		for (i = 0; i < `b; i = i + 1) begin
			dut.key_RAM.ram[i]=key[8*i+:8];
		end 	

		dut.S_RAM.ram[0]=`pW;

		A = 32'h21A5DBEE;
		B = 32'h154B8F6D;

		#2 rst = 1;
		#4 rst = 0;

		/*
		#1065
		$display("Valores de L:\n");
		for (i = 0; i < `c; i = i + 1) begin
			$display("%H", dut.L_RAM.ram[i]);
		end

		$display("\n\nValores de S:\n");
		for (i = 0; i < `t; i = i + 1) begin
			$display("%H",dut.S_RAM.ram[i]);
		end 
		*/
		#8900
		$display("\n\nValores de S:\n");
		for (i = 0; i < `t; i = i + 1) begin
			$display("%H",dut.S_RAM.ram[i]);
		end 
		#3000
		
		$display("%h",{dut.oA_cipher,dut.oB_cipher});
		
		#1 $finish;

	end

	always #5 clk=~clk;

endmodule