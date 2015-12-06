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

//`include "dut.v"

module dut_impl
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
	// Senales done
	output wire oDoneCipher,
	output wire oDoneDecipher,
	// Puerto entrada
	input wire [W-1:0] serial_port_in,
	// Puerto salida
	output reg [W-1:0] serial_port_out 
);


	parameter B_LENGTH = $clog2(B);

	// Entradas
	reg [W-1:0] iA;
	reg [W-1:0] iB;
	reg [W-1:0] iA_cipher;
	reg [W-1:0] iB_cipher;
	// Salidas
	wire [W-1:0] oA_cipher;
	wire [W-1:0] oB_cipher;
	wire [W-1:0] oA_decipher;
	wire [W-1:0] oB_decipher;

//////////////// LOGICA PARA SERIALIZAR //////////////////////////
reg [1:0] muxCount;
always @(posedge clk) begin
	
	if(rst) begin
		muxCount = 0;
	end
	else begin
		muxCount = muxCount + 1;
	end

end


// Serializar entradas
always @(posedge clk) begin

	case(muxCount)

		0: begin
			iA <= serial_port_in;
			iB <= iB;
			iA_cipher <= iA_cipher;
			iB_cipher <= iB_cipher;
		end

		1: begin
			iA <= iA;
			iB <= serial_port_in;
			iA_cipher <= iA_cipher;
			iB_cipher <= iB_cipher;
		end

		2: begin
			iA <= iA;
			iB <= iB;
			iA_cipher <= serial_port_in;
			iB_cipher <= iB_cipher;
		end


		3: begin
			iA <= iA;
			iB <= iB;
			iA_cipher <= iA_cipher;
			iB_cipher <= serial_port_in;
		end

		default: begin
			iA <= 0;
			iB <= 0;
			iA_cipher <= 0;
			iB_cipher <= 0;
		end
	endcase

end


// Serializar salidas
always @(posedge clk) begin

	case(muxCount)

		0: begin
			serial_port_out <= oA_cipher;
		end

		1: begin
			serial_port_out <= oB_cipher;
		end

		2: begin
			serial_port_out <= oA_decipher;
		end

		3: begin
			serial_port_out <= oB_decipher;
		end

		default: begin
			serial_port_out <= 0;
		end
	endcase

end
//////////////// FIN LOGICA PARA SERIALIZAR //////////////////////////


dut
#(
	.W(W),
	.C(C),
	.B(B),
	.R(R),
	.QW(QW)
)
dut_implementacion
(
	.clk(clk),
	.rst(rst),
	.iStartCipher(iStartCipher),
	.iStartDecipher(iStartDecipher),
	.iKey_sub_i(iKey_sub_i),
	.iKey_address(iKey_address),
	.iWen(iWen),
	.iA(iA),
	.iB(iB),
	.iA_cipher(iA_cipher),
	.iB_cipher(iB_cipher),
	.oA_cipher(oA_cipher),
	.oB_cipher(oB_cipher),
	.oA_decipher(oA_decipher),
	.oB_decipher(oB_decipher),
	.oDoneCipher(oDoneCipher),
	.oDoneDecipher(oDoneDecipher)
);


endmodule