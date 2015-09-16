// module of key generation

module keygen(clock,reset,index,O,kflag,lvalue);
// load 32 bit values say P and Q
input clock;
input reset;
input [5:0]index,kflag;
output reg [31:0]O,lvalue;
//reg [7:0]key[15:0];
reg [31:0]L[3:0];
reg [31:0]P;
reg [31:0]Q;
reg [31:0]S[21:0];
reg [2:0]s0,s1,s2,s3;
reg [2:0]state;
reg [5:0]count;
reg set;
reg testreg;

always @(posedge clock)
begin

if(reset)
begin
P <= 32'haaaa_aaaa;
Q <= 32'hbbbb_bbbb;
lvalue<=32'd0;
count <=6'd0;
//cnt<=6'd0;
state <=3'b0;
s0<=3'd0;	  
s1<=3'd1;
s2<=3'd2;
s3<=3'd3;
set<=1'b0;
end

else

begin
// S array formed frm the constants P and Q
case (state)
   s0:begin
  L[0]={16'hffff,16'hdddd};
  L[1]={16'haaaa,16'hffff};
  L[2]={16'hffff,16'hbbbb};
  L[3]={16'hcccc,16'hffff};
    state <=s1;
      end
	s1:begin
		S[0] <= P;
		state<=s2;
	 	end
	s2: begin
			if(count <= 6'd21)
			begin
		testreg <=S[count];
		S[count+1] <= S[count] + Q;
		count <= count +1'b1;
		state <= s2;
			end
			else
			begin
			set <=1'b1;
			state <=s3;
			end
		end
	s3:begin
		if(set)
		begin
		O<=S[index];
      lvalue<=L[kflag];
		end
    		state <=s3;
		end

endcase
end

end

endmodule
