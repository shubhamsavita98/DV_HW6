`default_nettype none

  module my_mem(my_mem_inf dut);

   // Declare a 9-bit associative array using the logic data type
   //typedef bit[15:0] halfword;
   logic [8:0] mem_array[int];
   int func_result;
   
   always @(posedge dut.clk) begin
      if (dut.write) begin
      	//func_result = my_mem_inf.evenparity(dut.data_in);
      	//$display("dut.data_in: ",dut.data_in);
      	#10;
        mem_array[dut.address] = {dut.evenparity(dut.data_in), dut.data_in};
        //mem_array[dut.address] = {func_result, dut.data_in};
    end
      else if (dut.read)
        dut.data_out =  mem_array[dut.address];
   end
endmodule