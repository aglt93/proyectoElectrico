`define W 16 // Cantidad de bits por palabra.
`define U (`W/8)
`define B 16 // Cantidad de bytes de la llave.
`define R 12 // Cantidad de rondas.
`define C (`B/`U) // Tamaño del vector L. Corresponde a b/u.

`define barrel16

`ifdef barrel16
	`define PW 16'hb7e1 // Constantes
	`define QW 16'h9e37 //
`endif

`ifdef barrel32
	`define PW 32'hb7e15163 // Constantes
	`define QW 32'h9e3779b9//
`endif

`ifdef barrel64
	`define PW 64'hb7e151628aed2a6b // Constantes
	`define QW 64'h9e3779b97f4a7c15 //
`endif

//`define NO_XILLINX

`ifdef NO_XILLINX
	`include "ram.v"
	`include "keyExpander.v"
	`include "cipher.v"
	`include "decipher.v"
	`include "barrelShifter.v"
	`include "ffd.v"
	`include "L_operation.v"
	`include "S_operation.v"
	`include "keyMixer.v"
`endif




module dut
#(
	parameter W = `W,
	parameter C = `C,
	parameter B = `B,
	parameter R = `R,
	parameter QW = `QW
)
(
	input wire clk,
	input wire rst,
	// Senales para iniciar cifrado/descifrado
	input wire iStartCipher,
	input wire iStartDecipher,
	// Entradas a la memoria de la llave
	input wire [7:0] iKey_sub_i,
	input wire [B_LENGTH-1:0] iKey_address,
	input wire iWen,
	// Entradas
	input wire [W-1:0] iA,
	input wire [W-1:0] iB,
	input wire [W-1:0] iA_cipher,
	input wire [W-1:0] iB_cipher,
	// Salidas
	output wire [W-1:0] oA_cipher,
	output wire [W-1:0] oB_cipher,
	output wire [W-1:0] oA_decipher,
	output wire [W-1:0] oB_decipher,
	// Senales done
	output wire oDoneCipher,
	output wire oDoneDecipher
);

	parameter T = 2*(R+1);
	parameter W_BITS = $clog2(W);
	parameter C_LENGTH = $clog2(C);
	parameter B_LENGTH = $clog2(B);
	parameter T_LENGTH = $clog2(T);

	wire [W-1:0] S_sub_i;
	wire [W-1:0] L_sub_i;
	wire [7:0] key_sub_i;
	wire [C_LENGTH-1:0] L_address;
	wire [T_LENGTH-1:0] S_address;
	wire L_we;
	wire S_we;
	wire [B_LENGTH-1:0] key_address;
	wire [W-1:0] S_sub_i_prima;
	wire [W-1:0] L_sub_i_prima;
	wire keyExpanderDone;

	///////////////////////////////////////////////
	wire wStartCipher = iStartCipher && keyExpanderDone2;
	FFD_POSEDGE_SYNCRONOUS_RESET #(1) ff1(clk,rst,1,keyExpanderDone,keyExpanderDone1);
	FFD_POSEDGE_SYNCRONOUS_RESET #(1) ff2(clk,rst,1,keyExpanderDone1,keyExpanderDone2);

	wire wStartDecipher = iStartDecipher && keyExpanderDone2;
	//FFD_POSEDGE_SYNCRONOUS_RESET #(1) ff3(clk,rst,1,oDoneCipher,cipherDone1);
	//FFD_POSEDGE_SYNCRONOUS_RESET #(1) ff4(clk,rst,1,cipherDone1,wStartDecipher);
	//
	wire [T_LENGTH-1:0] S_address_expander;
	wire [T_LENGTH-1:0] wS_address2;

	assign  wS_address2 = (wStartDecipher) ? wS_address_decipher2: wS_address_cipher2;

	wire [T_LENGTH-1:0] wS_address_decipher1;
	wire [T_LENGTH-1:0] wS_address_decipher2;
	wire [T_LENGTH-1:0] wS_address_cipher1;
	wire [T_LENGTH-1:0] wS_address_cipher2;
	wire [T_LENGTH-1:0] wS_address_cipher;
	
	assign S_address = (wStartDecipher) ? wS_address_decipher1: wS_address_cipher;
	assign wS_address_cipher = (wStartCipher) ? wS_address_cipher1 : S_address_expander;
	//
	wire [W-1:0] iS_sub_i2;

	//*****************************************************************************
	decipher
	#(
		.W(W),
		.R(R)
	)
	descifrador
	(
		.clk(clk),
		.rst(rst),
		.iStart(wStartDecipher),
		.iA(iA_cipher),
		.iB(iB_cipher),
		.oS_address1(wS_address_decipher1),
		.oS_address2(wS_address_decipher2),
		.iS_sub_i1(S_sub_i),
		.iS_sub_i2(iS_sub_i2),
		.oA_decipher(oA_decipher),
		.oB_decipher(oB_decipher),
		.oDone(oDoneDecipher)
	);
	//*****************************************************************************
	cipher 
	#(
		.W(W),
		.R(R)
	)
	cifrador
	(
		.clk(clk),
		.rst(rst),
		.iStart(wStartCipher),
		.iA(iA),
		.iB(iB),
		.oS_address1(wS_address_cipher1),
		.oS_address2(wS_address_cipher2),
		.iS_sub_i1(S_sub_i),
		.iS_sub_i2(iS_sub_i2),
		.oA_cipher(oA_cipher),
		.oB_cipher(oB_cipher),
		.oDone(oDoneCipher)
	);
	//********************************************************************
	keyExpander
	#(
		.W(W),
		.C(C),
		.B(B),
		.R(R),
		.QW(QW)
	)
	expander
	(
		.clk(clk),
		.rst(rst),
		.iStart(iStartCipher || iStartDecipher),
		.iS_sub_i(S_sub_i),
		.iL_sub_i(L_sub_i),
		.iKey_sub_i(key_sub_i),
		.oL_address(L_address),
		.oS_address(S_address_expander),
		.oKey_address(key_address),
		.oL_we(L_we),
		.oS_we(S_we),
		.oS_sub_i_prima(S_sub_i_prima),
		.oL_sub_i_prima(L_sub_i_prima),
		.oKeyExpanderDone(keyExpanderDone)
	);	
	//********************************************************************
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
		.addr_b(wS_address2),
		.we_a(S_we),
		.we_b(0),
		.q_a(S_sub_i),
		.q_b(iS_sub_i2)
	);
	//********************************************************************
	RAM_DUAL_READ_DUAL_WRITE_PORT  
	#( 
		.DATA_WIDTH(8),
		.ADDR_WIDTH(B_LENGTH) 
	)
	key_RAM
	(
		.clk(clk),
		.data_a(0),
		.data_b(iKey_sub_i),
		.addr_a(key_address),
		.addr_b(iKey_address),
		.we_a(0),
		.we_b(iWen),
		.q_a(key_sub_i)
	);
	//*****************************************************
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
endmodule