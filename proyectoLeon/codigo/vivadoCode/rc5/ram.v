module RAM_DUAL_READ_DUAL_WRITE_PORT  # ( parameter DATA_WIDTH = 8, parameter ADDR_WIDTH = 6 )
(
input wire [(DATA_WIDTH-1):0] data_a, data_b,
input wire [(ADDR_WIDTH-1):0] addr_a, addr_b,
input wire we_a, we_b, clk,
output reg [(DATA_WIDTH-1):0] q_a, q_b
);


// Declare the RAM variable
reg [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0];
	always @ (posedge clk)
	begin // Port A
		if (we_a) 
		begin
			ram[addr_a] <= data_a;
			q_a <= data_a;
		end
		else 
			q_a <= ram[addr_a];
	end
		
	always @ (posedge clk)
	begin // Port b
		if (we_b) 
		begin
			ram[addr_b] <= data_b;
			q_b <= data_b;
		end
		else 
			q_b <= ram[addr_b];
	end
endmodule