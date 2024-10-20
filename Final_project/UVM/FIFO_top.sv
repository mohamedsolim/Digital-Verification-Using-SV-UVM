import FIFO_test_pkg::*;
import uvm_pkg::* ;
`include "uvm_macros.svh"



module FIFO_top();
bit clk ;

initial 
  begin
    clk = 0 ;
    forever
    begin
    #1 clk = ~clk ;
    end
  end
  FIFO_if FIFOif (clk) ;
  FIFO dU (FIFOif) ;
  bind FIFO  SVA  sva(FIFOif) ;
  initial
    begin
        uvm_config_db#(virtual FIFO_if)::set(null , "uvm_test_top" , "FIFOif" , FIFOif ); 
        run_test("FIFO_test");
    end




endmodule