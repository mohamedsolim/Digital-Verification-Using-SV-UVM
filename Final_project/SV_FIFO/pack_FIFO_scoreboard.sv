package pack_FIFO_scoreboard;

  import pack_FIFO_transaction::* ;
  import shared_pkg::* ;

    class FIFO_scoreboard ;
      parameter FIFO_WIDTH = 16;
      parameter FIFO_DEPTH = 8;  
      localparam max_fifo_addr = $clog2(FIFO_DEPTH);
      logic [FIFO_WIDTH-1:0] data_out_ref;
      logic wr_ack_ref, overflow_ref;
      logic full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;
      
      bit [FIFO_WIDTH-1:0] mem_queue[$] ;
      reg [max_fifo_addr:0] count;


      function void  reference_model(input FIFO_transaction obj_tran ) ;
        fork
            begin
                if (!obj_tran.rst_n) begin
                    mem_queue.delete();	
                end
                else if (obj_tran.wr_en && count < obj_tran.FIFO_DEPTH) begin
                    mem_queue.push_back(obj_tran.data_in) ;
                    wr_ack_ref = 1;
                end
                else begin 
                    wr_ack_ref = 0; 
                    if (full_ref & obj_tran.wr_en)
                    overflow_ref = 1;
                    else
                    overflow_ref = 0;
                end
            end
            begin
                if (!obj_tran.rst_n) begin
                    data_out_ref = 0 ;
                end
                else if (obj_tran.rd_en && count != 0) begin
                    data_out_ref = mem_queue.pop_front() ;
                end
                else begin 
                    if (empty_ref && obj_tran.rd_en)
                    underflow_ref = 1;
                    else
                    underflow_ref = 0 ;
                end
            end
        join

        full_ref = (count == FIFO_DEPTH)? 1 : 0;
        empty_ref = (count == 0)? 1 : 0;
        almostfull_ref = (count == FIFO_DEPTH-1)? 1 : 0; 
        almostempty_ref = (count == 1)? 1 : 0;

        if (!obj_tran.rst_n) begin
            count = 0;
        end
        else begin
            if	( ({obj_tran.wr_en, obj_tran.rd_en} == 2'b10) && !full_ref) 
                count = count + 1;
            else if ( ({obj_tran.wr_en, obj_tran.rd_en} == 2'b01) && !empty_ref)
                count = count - 1;
            else if ( ({obj_tran.wr_en, obj_tran.rd_en} == 2'b11) && empty_ref)
                count = count + 1;	
            else if	( ({obj_tran.wr_en, obj_tran.rd_en} == 2'b11) && full_ref) 
                count = count - 1;
        end

      endfunction 


      function void check_data(input FIFO_transaction obj_tran_check ) ;
       logic [6:0] flag_test , flag_dut ;
        reference_model(obj_tran_check);
        flag_test ={ wr_ack_ref , overflow_ref , full_ref , empty_ref , almostfull_ref , almostempty_ref , underflow_ref } ;
        flag_dut ={ obj_tran_check.wr_ack , obj_tran_check.overflow , obj_tran_check.full , obj_tran_check.empty , obj_tran_check.almostfull , obj_tran_check.almostempty , obj_tran_check.underflow } ;
    
        if( (obj_tran_check.data_out !== data_out_ref) && (flag_dut !== flag_test) )
        begin
            $display ("At time = %0t ::error ==> obj_tran_check.data_out  = %0d  ,  data_out_ref  = %0d  , flag_dut  = %0b , flag_test  = %0b  , obj_tran_check.rst_n  = %0b  ,  obj_tran_check.wr_en  = %0b  ,  obj_tran_check.rd_en  = %0b    " , $time , obj_tran_check.data_out , data_out_ref , flag_dut , flag_test , obj_tran_check.rst_n  , obj_tran_check.wr_en   ,  obj_tran_check.rd_en);
            error_count++ ;
        end
    else
        begin
            correct_count++ ;
        end 
      
      endfunction 

    endclass

endpackage 
