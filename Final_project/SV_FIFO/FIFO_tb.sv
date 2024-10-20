import pack_FIFO_transaction::* ;
import pack_FIFO_coverage::* ;
import shared_pkg::* ;

module FIFO_tb(FIFO_inter.TEST  FIFO_if);
	
  FIFO_transaction  transaction = new() ;
  FIFO_coverage     coverage    = new() ;
  initial 
    begin
        forever
        #10 transaction.clk = FIFO_if.clk;
    end
  initial begin
    rest ();
    
    test_finished = 0 ;
    FIFO_if.data_in = 1;
    FIFO_if.rst_n = 1;
    FIFO_if.wr_en =1 ;
    FIFO_if.rd_en = 1 ;
    @(negedge FIFO_if.clk) ;
    repeat(100000)
    begin
      transaction.randomize();
      FIFO_if.data_in = transaction.data_in ;
      FIFO_if.rst_n = transaction.rst_n ;
      FIFO_if.wr_en = transaction.wr_en ;
      FIFO_if.rd_en = transaction.rd_en ;
      @(negedge FIFO_if.clk) ;
    end
    test_finished = 1 ;
  end
  task rest ();
    FIFO_if.rst_n = 0 ;
    #10 
    FIFO_if.rst_n = 1 ;
    
endtask

endmodule
