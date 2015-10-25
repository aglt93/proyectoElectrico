task drv_init;
  begin

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
	end
endtask

task drv_write;
	@(negedge clk2) begin	
		S[S_address+1] = S_sub_i_prima;	
	end
endtask