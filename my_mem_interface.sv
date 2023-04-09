`default_nettype none

interface my_mem_inf(input clk);
    logic write;
    logic read;
    logic [7:0] data_in;
    logic [15:0] address;
    logic [8:0] data_out;

    int error_count = 0;

/*
    clocking my_mem_clk(@ posedge clk);
      default input #1ps output #1ps;
      output data_out;
    endclocking*/

modport my_mem( input  clk, write, read, data_in, address,
        output data_out);

   //calculating even parity using functions
   function [7:0] evenparity(input  var logic [7:0] data_in);
      evenparity = ^data_in;
    endfunction

  //Checker for error counter using task
  task err_checker;
    input write, read;
    if(write == 1 && read == 1) begin
       error_count = error_count + 1;
      $display("==== Error count by checker: %0d ====", error_count);
    end
     else
       $display("No error increment from checker.\n");
  endtask

endinterface

