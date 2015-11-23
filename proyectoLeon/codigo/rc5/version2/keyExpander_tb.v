`timescale 1ns/10ps

`include "probando.v"

`define w 32 // Cantidad de bits por palabra.
`define u 4 // Cantidad de bytes por palabra.
`define b 16 // Cantidad de bytes de la llave.
`define b_length $clog2(`b) // Bits para direccionar a todos los bytes b de la llave.
`define r 12 // Cantidad de rondas.
`define t 2*(`r+1) // Tamaño del vector S es igual a 2 (r+1) donde r es la cantidad de rondas.
`define t_length $clog2(`t) // Cantidad de bit para direccionar al vector S.
`define c 4 // Tamaño del vector L. Corresponde a b/u.
`define c_length 2 // Cantidad de bits para direccionar al vector L.
`define qW 32'h9E3779B9 // Constantes
`define pW 32'hB7E15163 //

module testbench;

	integer i;
	reg [127:0] key;
	reg clk;
	reg rst;
	wire done;

	hola expander(clk,rst);

	initial begin
		
		$dumpfile("expander.vcd");
		$dumpvars;
		clk=0;
		rst = 0;
		key = 128'hFFFEEEE58684FFF05FFE493853000434;

		for (i = 0; i < `c; i = i + 1) begin
			expander.L_RAM.ram[i]=0;
		end

		for (i = 0; i < `b; i = i + 1) begin
			expander.key_RAM.ram[i]=key[8*i+:8];
		end 

		expander.S_RAM.ram[0]=`pW;

		#2 rst = 1;
		#4 rst = 0;

		#1065
		$display("Valores de L:\n");
		for (i = 0; i < `c; i = i + 1) begin
			$display(expander.L_RAM.ram[i]);
		end

		$display("\n\nValores de S:\n");
		for (i = 0; i < `t; i = i + 1) begin
			$display(expander.S_RAM.ram[i]);
		end 

		#87
		$display("Valor:");
		$display(expander.S_RAM.ram[0]);

		#8000 

		#1 $finish;

	end

	always #5 clk=~clk;

endmodule