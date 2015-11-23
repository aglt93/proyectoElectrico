task drv_init;
  begin

  	for (i=0;i<`c;i=i+1) begin
		L[i]=0;
	end

	for (i=0;i<`b;i=i+1) begin
		keyInBytes[i]=5+i;
	end

    @(negedge clk2) begin
		rst = 1;
    end 

    @(negedge clk2)
		rst = 0;

  end

endtask

task drv_read;
	@(posedge clk2) begin
		S_sub_i = S[S_address];
		L_sub_i = L[L_address];
		key_sub_i = keyInBytes[key_address];
	end
endtask

task drv_write;
	@(negedge clk2) begin
		S[S_address+1] = S_sub_i_prima;
		L[L_address] = L_sub_i_prima;	
	end
endtask