`include "ram.v"
`include "S_operation.v"


`timescale 1ns/10ps

`define w 32 // Cantidad de bits por palabra.
`define u 4 // Cantidad de bytes por palabra.
`define b 16 // Cantidad de bytes de la llave.
`define b_length $clog2(`b) // Bits para direccionar a todos los bytes b de la llave.
`define r 12 // Cantidad de rondas.
`define t 2*(`r+1) // Tamaño del vector S es igual a 2 (r+1) donde r es la cantidad de rondas.
`define t_length $clog2(`t) // Cantidad de bit para direccionar al vector S.
`define c 4 // Tamaño del vector L. Corresponde a b/u.
`define c_length 2 // Cantidad de bits para direccionar al vector L.
`define qW 5 //32'h9E3779B9 // Constantes
`define pW 10 //32'hB7E15163 //



module testbench
(
	output reg clk,
	output reg rst
);

	integer i;
	reg [127:0] key;

	initial begin
		
		$dumpfile("S.vcd");
		$dumpvars;
		clk=0;
		rst = 0;
		key = 128'hFFFEEEE58684FFF05FFE493853000434;

		S_RAM.ram[0]=`pW;

		#2 rst = 1;
		#4 rst = 0;

		#1200 

		for (i = 0; i < `t; i = i + 1) begin
				$display(S_RAM.ram[i]);
		end

		#1 $finish;

	end

	always #5 clk=~clk;

endmodule



module probador;

	parameter W = `w;
	parameter W_bits = $clog2(W);
	parameter C = `c;
	parameter C_length = $clog2(C);
	parameter B = `b;
	parameter B_length = $clog2(B);
	parameter T = `t;
	parameter T_LENGTH = $clog2(T);
	parameter QW = `qW;
	//
	wire clk;
	wire rst;
	//
	wire [W-1:0] S_sub_i_prima;
	wire [W-1:0] S_sub_i;
	wire S_we;
	wire [T_LENGTH-1:0] S_address;
	//
	wire done;

	////////////////////////////////////////////
	testbench test
	(
		.clk(clk),
		.rst(rst)
	);

	/////////////////////////////////////////////
	S_operation 
	#(
		.W(W),
		.T(T),
		.QW(QW)
	)
	operation
	(
		.clk(clk),
		.rst(rst),
		.iS_sub_i(S_sub_i),
		.oS_sub_i_prima(S_sub_i_prima),
		.oS_we(S_we),
		.oS_address(S_address),
		.oDone(done)
	);

	////////////////////////////////////////////
	RAM_DUAL_READ_DUAL_WRITE_PORT  
	#( 
		.DATA_WIDTH(W),
		.ADDR_WIDTH(T_LENGTH) 
	)
	S_RAM
	(
		.clk(clk),
		.data_a(S_sub_i_prima),
		.data_b(0),
		.addr_a(S_address),
		.addr_b(0),
		.we_a(S_we),
		.we_b(0),
		.q_a(S_sub_i)
	);


endmodule