`include "ram.v"
`include "S_operation.v"
`include "L_operation.v"
`include "keyMixer.v"
`include "ffd.v"

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



module keyExpander
(
	//
	input wire clk,
	input wire rst
);


	parameter W = `w;
	parameter W_BITS = $clog2(W);
	parameter C = `c;
	parameter C_LENGTH = $clog2(C);
	parameter B = `b;
	parameter B_LENGTH = $clog2(B);
	parameter T = `t;
	parameter T_LENGTH = $clog2(T);
	parameter QW = `qW;
	


	//*******************************
	wire [W-1:0] S_sub_i_prima1;
	wire [W-1:0] S_sub_i;
	wire S_we1;
	wire [T_LENGTH-1:0] S_address1;
	//
	wire S_done;
	//*******************************
	wire [W-1:0] L_sub_i_prima1;
	wire [W-1:0] L_sub_i;
	wire L_we1;
	wire [C_LENGTH-1:0] L_address1;
	//
	wire [7:0] key_sub_i;
	wire [B_LENGTH-1:0] key_address;
	wire L_done;
	//*******************************
	wire [W-1:0] S_sub_i_prima2;
	wire S_we2;
	wire [T_LENGTH-1:0] S_address2;
	//
	wire [W-1:0] L_sub_i_prima2;
	wire L_we2;
	wire [C_LENGTH-1:0] L_address2;
	// 
	wire start;
	wire [C_LENGTH-1:0] L_address;
	wire [T_LENGTH-1:0] S_address;
	wire [W-1:0] S_sub_i_prima;
	wire [W-1:0] L_sub_i_prima;
	wire L_we;
	wire S_we;
	wire keyExpanderDone;
	//*******************************

	assign start1 = L_done && S_done;
	FFD_POSEDGE_SYNCRONOUS_RESET #(1) ff1(clk,rst,1,start1,start2);
	FFD_POSEDGE_SYNCRONOUS_RESET #(1) ff2(clk,rst,1,start2,start);

	assign L_sub_i_prima = (!start) ? L_sub_i_prima1:L_sub_i_prima2;
	assign L_address = (!start) ? L_address1:L_address2;

	assign S_sub_i_prima = (!start) ? S_sub_i_prima1:S_sub_i_prima2;
	assign S_address = (!start) ? S_address1:S_address2;

	assign L_we = (!start) ? L_we1:L_we2;
	assign S_we = (!start) ? S_we1:S_we2;

	//********************************************************************
	keyMixer
	#(
		.W(W),
		.C(C),
		.T(T)
	)
	mixer
	(
		.clk(clk),
		.rst(rst),
		.iStart(start),
		//
		.oL_address(L_address2),
		.iL_sub_i(L_sub_i),
    	.oL_sub_i_prima(L_sub_i_prima2),
    	// 
    	.iS_sub_i(S_sub_i),
    	.oS_address(S_address2),
    	.oS_sub_i_prima(S_sub_i_prima2),
    	//
    	.oDone(keyExpanderDone),
    	.oL_we(L_we2),
    	.oS_we(S_we2)
	);

	//********************************************************************
	/////////////////////////////////////////////
	S_operation 
	#(
		.W(W),
		.T(T),
		.QW(QW)
	)
	S
	(
		.clk(clk),
		.rst(rst),
		.iS_sub_i(S_sub_i),
		.oS_sub_i_prima(S_sub_i_prima1),
		.oS_we(S_we1),
		.oS_address(S_address1),
		.oDone(S_done)
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
	//********************************************************************
	/////////////////////////////////////////////
	L_operation 
	#(
		.W(W),
		.C(C)
	)
	L
	(
		.clk(clk),
		.rst(rst),
		.L_sub_i(L_sub_i),
		.L_sub_i_prima(L_sub_i_prima1),
		.L_we(L_we1),
		.L_address(L_address1),
		.key_address(key_address),
		.key_sub_i(key_sub_i),
		.done(L_done)
	);


	////////////////////////////////////////////
	RAM_DUAL_READ_DUAL_WRITE_PORT  
	#( 
		.DATA_WIDTH(8),
		.ADDR_WIDTH(B_LENGTH) 
	)
	key_RAM
	(
		.clk(clk),
		.data_a(0),
		.data_b(0),
		.addr_a(key_address),
		.addr_b(0),
		.we_a(0),
		.we_b(0),
		.q_a(key_sub_i)
	);


	///////////////////////////////////////////
	RAM_DUAL_READ_DUAL_WRITE_PORT  
	#( 
		.DATA_WIDTH(W),
		.ADDR_WIDTH(C_LENGTH) 
	)
	L_RAM
	(
		.clk(clk),
		.data_a(L_sub_i_prima),
		.data_b(0),
		.addr_a(L_address),
		.addr_b(0),
		.we_a(L_we),
		.we_b(0),
		.q_a(L_sub_i)
	);
	//***********************************************************************
endmodule