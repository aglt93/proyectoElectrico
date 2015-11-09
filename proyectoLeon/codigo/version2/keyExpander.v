module keyExpander
#(
	parameter W = 32,
	parameter C = 4,
	parameter B = 16,
	parameter R = 12,
	parameter QW = 32'hB7E15163
)

(
	input wire clk,
	input wire rst,
	//
	input wire [W-1:0] iS_sub_i,
	input wire [W-1:0] iL_sub_i,
	input wire [7:0] iKey_sub_i,
	//
	output wire [C_LENGTH-1:0] oL_address,
	output wire [T_LENGTH-1:0] oS_address,
	output wire [B_LENGTH-1:0] oKey_address,
	//
	output wire oL_we,
	output wire oS_we,
	//
	output wire [W-1:0] oS_sub_i_prima,
	output wire [W-1:0] oL_sub_i_prima,
	//
	output wire oKeyExpanderDone
);

	parameter T = 2*(R+1);
	parameter W_BITS = $clog2(W);
	parameter C_LENGTH = $clog2(C);
	parameter B_LENGTH = $clog2(B);
	parameter T_LENGTH = $clog2(T);

	//*******************************
	wire [W-1:0] wS_sub_i_prima1;
	wire wS_we1;
	wire [T_LENGTH-1:0] wS_address1;
	wire wS_done;
	//*******************************
	wire [W-1:0] wL_sub_i_prima1;
	wire wL_we1;
	wire [C_LENGTH-1:0] wL_address1;
	wire wL_done;
	//*******************************
	wire [W-1:0] wS_sub_i_prima2;
	wire wS_we2;
	wire [T_LENGTH-1:0] wS_address2;
	wire [W-1:0] wL_sub_i_prima2;
	wire wL_we2;
	wire [C_LENGTH-1:0] wL_address2;
	//*******************************
	wire wStart;

	assign start1 = wL_done && wS_done;
	FFD_POSEDGE_SYNCRONOUS_RESET #(1) ff1(clk,rst,1,start1,start2);
	FFD_POSEDGE_SYNCRONOUS_RESET #(1) ff2(clk,rst,1,start2,wStart);

	assign oL_sub_i_prima = (!wStart) ? wL_sub_i_prima1:wL_sub_i_prima2;
	assign oL_address = (!wStart) ? wL_address1:wL_address2;

	assign oS_sub_i_prima = (!wStart) ? wS_sub_i_prima1:wS_sub_i_prima2;
	assign oS_address = (!wStart) ? wS_address1:wS_address2;

	assign oL_we = (!wStart) ? wL_we1:wL_we2;
	assign oS_we = (!wStart) ? wS_we1:wS_we2;

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
		.iStart(wStart),
		//
		.oL_address(wL_address2),
		.iL_sub_i(iL_sub_i),
    	.oL_sub_i_prima(wL_sub_i_prima2),
    	// 
    	.iS_sub_i(iS_sub_i),
    	.oS_address(wS_address2),
    	.oS_sub_i_prima(wS_sub_i_prima2),
    	//
    	.oDone(oKeyExpanderDone),
    	.oL_we(wL_we2),
    	.oS_we(wS_we2)
	);
	//**********************************************************************
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
		.iS_sub_i(iS_sub_i),
		.oS_sub_i_prima(wS_sub_i_prima1),
		.oS_we(wS_we1),
		.oS_address(wS_address1),
		.oDone(wS_done)
	);
	//**********************************************************************
	L_operation 
	#(
		.W(W),
		.C(C)
	)
	L
	(
		.clk(clk),
		.rst(rst),
		.L_sub_i(iL_sub_i),
		.L_sub_i_prima(wL_sub_i_prima1),
		.L_we(wL_we1),
		.L_address(wL_address1),
		.key_address(oKey_address),
		.key_sub_i(iKey_sub_i),
		.done(wL_done)
	);

endmodule