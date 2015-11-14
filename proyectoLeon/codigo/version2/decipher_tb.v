`timescale 1ns/10ps


`define w 64 // Cantidad de bits por palabra.
`define u (`w/8)
`define b 16 // Cantidad de bytes de la llave.
`define r 12 // Cantidad de rondas.
`define c (`b/`u) // Tamaño del vector L. Corresponde a b/u.
`define pW 32'hB7E15163 // Constantes
`define qW 32'h9E3779B9 //
`define barrel64

`include "decipher_dut.v"

module testbench;

	integer i;
	reg [127:0] key;
	reg clk;
	reg rst;

	wire done;
	reg [`w-1:0] A;
	reg [`w-1:0] B;
	wire [`w-1:0] A_decipher;
	wire [`w-1:0] B_decipher;


	parameter W = `w;
	parameter C = `c;
	parameter b = `b;
	parameter R = `r;
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
		A_decipher,
		B_decipher,
		done
	);

	initial begin

		$dumpfile("decipher.vcd");
		$dumpvars;
		clk=0;
		rst = 0;
		key = 128'h91CEA91001A5556351B241BE19465F91;

		for (i = 0; i < `c; i = i + 1) begin
			dut.L_RAM.ram[i]=0;
		end

		for (i = 0; i < `b; i = i + 1) begin
			dut.key_RAM.ram[i]=key[8*i+:8];
		end 	

		dut.S_RAM.ram[0]=`pW;

		A = 32'heedba521;
		B = 32'h6d8f4b15;

		#2 rst = 1;
		#4 rst = 0;


		/*
		#1100
		$display("Valores de L:\n");
		for (i = 0; i < `c; i = i + 1) begin
			$display("L[%d] = %H", i,dut.L_RAM.ram[i]);
		end
		
		$display("\n\nValores de S:\n");
		
		for (i = 0; i <= `t; i = i + 1) begin
			$display("%H",dut.S_RAM.ram[i]);
		end 
		*/
		#11900
		/*
		$display("\n\nValores de S:\n");
		
		for (i = 0; i < `t; i = i + 1) begin
			$display("%H",dut.S_RAM.ram[i]);
		end
		
		$display("Valores de L:\n");
		for (i = 0; i < `c; i = i + 1) begin
			$display("L[%d] = %H", i,dut.L_RAM.ram[i]);
		end
		
		#3000
		*/		
		$display("Plain text = %X",{A,B});
		$display("Cipher text = %X",{dut.oA_cipher,dut.oB_cipher});
		$display("Decipher text = %X",{A_decipher, B_decipher});
		
		#1 $finish;

	end

	always #5 clk=~clk;

endmodule