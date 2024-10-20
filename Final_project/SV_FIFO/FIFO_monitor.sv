import pack_FIFO_transaction::* ;
import pack_FIFO_scoreboard::* ;
import pack_FIFO_coverage::* ;
import shared_pkg::* ;

module FIFO_monitor(FIFO_inter.MONITOR  FIFO_if);

  FIFO_transaction  transaction = new()  ;
  FIFO_scoreboard  scoreboard = new();
  FIFO_coverage  coverage = new();


	//Test monitor and results
    initial begin
      forever 
      begin
          @(negedge FIFO_if.clk );
          transaction.clk = FIFO_if.clk ;
          transaction.data_in = FIFO_if.data_in ;
          transaction.rst_n = FIFO_if.rst_n ;
          transaction.wr_en = FIFO_if.wr_en ;
          transaction.rd_en = FIFO_if.rd_en ;
          transaction.data_out = FIFO_if.data_out ;
          transaction.wr_ack = FIFO_if.wr_ack ;
          transaction.overflow = FIFO_if.overflow ;
          transaction.full = FIFO_if.full ;
          transaction.empty = FIFO_if.empty ;
          transaction.almostfull = FIFO_if.almostfull ;
          transaction.almostempty = FIFO_if.almostempty ;
          transaction.underflow = FIFO_if.underflow ;
      

          fork

            begin  
              coverage.sample_data(transaction);
            end
          
            begin  // 2nd thread
              @(posedge FIFO_if.clk);
              #10;                     
              scoreboard.check_data(transaction);
            end
          
          join
          
          if(test_finished == 1) begin
            $display("no.of error_count   :%0d " , error_count  ) ;
            $display("no.of correct_count :%0d " , correct_count) ;
            $stop;
          end
      end
      end
    

endmodule