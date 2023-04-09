`default_nettype none

module my_mem_tb;

    logic clk, write, read;
    logic [7:0] data_in;
    logic [15:0] address;
    logic [8:0] data_out;
 
  	parameter SIZE=6;

    //mem_interface mi (.*);
  	my_mem_inf mem_inf(clk);

  	my_mem_top mem_top(mem_inf);

  	always #5 clk = ~clk;

  	int error_count_q = 0;

  	initial begin
    
      typedef struct {
        
        //16 bits of address
        bit [15:0] addr_to_read;
        //9 bits of data
        bit [8:0] data_to_write;
        //expected data read
        bit [8:0] expected_data_read;
        //actual data read
        bit [8:0] actual_data_read;
      
      }my_mem_struct;
  
   
    my_mem_struct memst[6];
    
    //intializing clk,read and write7
    clk=0; mem_inf.read=0; mem_inf.write=0;
    
    //randomize addresses
    for(int i=0; i<SIZE; i++) begin
      memst[i].addr_to_read = $random; //storing random address
      #1 $display("Address [%0d] = %0d",i, memst[i].addr_to_read);
    end
    
    //randomize data
    for(int j=0; j<SIZE; j++) begin
      memst[j].data_to_write = $random; //storing random data
      #1 $display("Data [%0d] = %0d",j, memst[j].data_to_write);
    end
    
    //set write to 1 to start writing to memory
    $display("testing....");
    mem_inf.write=1;

    for (int i = 0; i < 6; i++)
    begin
      @(posedge clk);
      $display(i);
      mem_inf.address = memst[i].addr_to_read;
      #20;
      $display("mem::%0d",mem_inf.address);
      mem_inf.data_in = memst[i].data_to_write;
      #20;
    end
    //check the memst before shuffle
    $display("Data before shuffle:\n", memst);
    memst.shuffle();
    //check the memst before shuffle
    $display("Data after shuffle:\n", memst);

    @(negedge clk);
    mem_inf.write = 0;
    
    //data expected
    for(int i=0; i < SIZE; i++) begin
      memst[i].expected_data_read = memst[i].data_to_write;
    end
    
    @(posedge clk)
    mem_inf.read = 1;

    //compare data out with data read expected
    $display("********* Starting Test*********");
    // data read in reverse order
    for(int i=SIZE-1; i>=0; i--) begin
      $display("Previous data out: %0d", mem_inf.data_out);
      #10;
      mem_inf.address = memst[i].addr_to_read;
      #10;
      $display("Address: %0d", mem_inf.address);
      $display("Data expected %0d", memst[i].expected_data_read);
      $display("Current data out %0d", mem_inf.data_out);
      memst[i].actual_data_read = mem_inf.data_out; //adding data to queue
      if(mem_inf.data_out !== memst[i].expected_data_read) begin
        $display("Error!!");
        error_count_q = error_count_q + 1;
        
        //test to test the checker
        mem_inf.err_checker(mem_inf.read, mem_inf.write);
      end
      else begin
        $display("\ndata out %0d is equal to data expected.", mem_inf.data_out); 
        $display("\n Read Success! \n");
        mem_inf.err_checker(mem_inf.read, mem_inf.write);
      end
    end

    $display("Total Error Count: %0d\n", error_count_q);
    $display("*************** End Test *************");
    
    $display("\n********* Traversing Queue *********");
    //traverse actual_data_read queue
    for(int i=0; i<SIZE; i++) begin
      //data_read_queue.push_back(data_out);
      $display("\tactual_data_read[%0d]= %0d",i,memst[i].actual_data_read);
    end
    
    //assinging read and write to 1 for checker task
    mem_inf.read =1; mem_inf.write =1;
    mem_inf.err_checker(mem_inf.read, mem_inf.write);
    
    #2000 $finish;
  end
    //vcd file generation and waveform enablement
    initial begin
      $vcdplusmemon;
      $vcdpluson;
      $dumpfile("dump.vcd");
      $dumpvars;
    end
    
    //end of module
    endmodule
