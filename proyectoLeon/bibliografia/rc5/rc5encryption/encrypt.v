module enc(clock,reset,enc_dec,outa,outb);

//I/O port declarations
input clock,reset,enc_dec;
output reg[7:0]outa,outb;

// plain text input  A and B
reg [7:0]A,B;
reg[7:0] ex_a,ex_b,evens,odds,r_a,r_b,shifta,shiftb,c;

//memory for S array
reg [7:0]S[12:0];
reg tempa,tempb;

// states used
reg[4:0]st0,st1,st2,st3,st4,st5,st6,st7,st8,st9,st11,st12,next_state;

always@(posedge clock)
begin

if(reset)
begin

A <= 8'haa;
B <= 8'hbb;
//say 4 example the s array is here
    
	  S[0]=8'h50;
		S[1]=8'ha8;
		S[2]=8'hc8;
		S[3]=8'hd0;
		S[4]=8'h38;
		S[5]=8'h58;
		S[6]=8'h90;
		S[7]=8'h48;
		S[8]=8'h08;
		S[9]=8'h90;
		S[10]=8'h10;
		S[11]=8'h0b;
		S[12]=8'h0c;
		
//states initialised
next_state<=5'd0;
st0 <= 5'd0;
st1 <= 5'd1;
st2 <= 5'd2;
st3 <= 5'd3;
st4 <= 5'd4;
st5 <= 5'd5;
st6 <= 5'd6;
st7 <= 5'd7;
st8 <= 5'd8;
st9 <= 5'd9;
st11 <= 5'd11;

// even and odd S index initialised
evens <= 8'd2;
odds <= 8'd3;

// number of iteratons
c <= 8'd2;

end

else if(enc_dec)
begin

case(next_state)
st0: begin
     if(c==8'd0)
      begin
       outa <= ex_a;
       outb <= ex_b;
       next_state<=st0;
      end
  else
    begin
      A <= A + S[0];
      B <= B + S[1];
      next_state <=st1;
   end
     end
st1: begin
     if(c == 8'd0)
     next_state<=st0;
    else
     begin
     ex_a <= A ^ B;    
     next_state <=st2;
     end
     end
st2: begin
     r_b<= B;
     next_state <=st3;
     end
st3: begin
     if(r_b ==8'd0)
      begin 
			//ex_b <= B ^ ex_a;
       next_state<= st7;
       end
     else 
		begin
     tempa <= ex_a[7];
     shifta <= ex_a<<1;
     r_b <= r_b -1'b1;
     next_state <=st4;
     end
     end
st4: begin
     ex_a <= shifta + tempa;
     next_state <=st3;
     end
st5: begin
    if(r_a ==8'd0)
      begin 
      next_state<= st8;
      end
     else 
		begin
     tempb<= ex_b[7];
     shiftb<=ex_b<<1;
     r_a<=r_a -1'b1;
     next_state <=st6;
     end     
     end
st6: begin
     ex_b <= shiftb + tempb;
     next_state <=st5;
     end
st7: begin
     ex_a <= ex_a + S[evens];
     next_state <=st11;
     end
st11:begin
     r_a <= ex_a;
     next_state<=st12;
     end
st12: begin
      ex_b <= B ^ ex_a;
      next_state<=st5;
      end
st8: begin
     ex_b <= ex_b + S[odds];
     next_state <=st9;
     end
st9 :begin
     evens<= evens + 8'd2;
     odds <= odds + 8'd2;
     B<= ex_a;
     A<= ex_b;//swap
     c <= c-1'b1;
     next_state <=st1;
     end
endcase
end

end
endmodule

