package FIFO_scoreboard_pkg ;

   import FIFO_seq_item_pkg::* ;
   import uvm_pkg::* ;
   `include "uvm_macros.svh"


   class FIFO_scoreboard extends uvm_scoreboard;
      `uvm_component_utils(FIFO_scoreboard)

      uvm_analysis_export #(FIFO_seq_item) sb_export ;
      uvm_tlm_analysis_fifo #(FIFO_seq_item) sb_fifo ;
      FIFO_seq_item seq_item_sb ;

      parameter FIFO_WIDTH = 16 ;
      parameter FIFO_DEPTH = 8 ;  
      localparam max_fifo_addr = $clog2(FIFO_DEPTH);
      logic [FIFO_WIDTH-1:0] data_out_ref =0;
      logic wr_ack_ref = 0 ;
      logic overflow_ref = 0 ;
      logic full_ref = 0  ;
      logic empty_ref = 0 ;
      logic almostfull_ref = 0 ;
      logic almostempty_ref = 0 ;
      logic underflow_ref = 0 ;
      logic [6:0] flag_test , flag_dut ;
      logic [FIFO_WIDTH-1:0] mem_queue[$] ;
      logic [max_fifo_addr:0] count = 0 ;

      int error_count = 0 ;
      int correct_count = 0 ;
      function new(string name = "FIFO_scoreboard" , uvm_component parent = null );
         super.new(name ,parent ) ;
      endfunction

      function void build_phase(uvm_phase phase) ;
         super.build_phase(phase);
        // seq_item_sb = new("seq_item_sb");
         sb_export =  new("sb_export" , this) ;
         sb_fifo =  new("sb_fifo" , this) ;
      endfunction

      function void connect_phase(uvm_phase phase) ;
         sb_export.connect(sb_fifo.analysis_export);
      endfunction

      
      task run_phase(uvm_phase phase) ;
         super.run_phase(phase);
         forever
         begin
            sb_fifo.get(seq_item_sb) ;
            ref_model(seq_item_sb) ;
            flag_test ={ wr_ack_ref , overflow_ref , full_ref , empty_ref , almostfull_ref , almostempty_ref , underflow_ref } ;
            flag_dut ={ seq_item_sb.wr_ack , seq_item_sb.overflow , seq_item_sb.full , seq_item_sb.empty , seq_item_sb.almostfull , seq_item_sb.almostempty , seq_item_sb.underflow } ;
            if((seq_item_sb.data_out != data_out_ref) || (flag_dut !== flag_test))
            begin
               `uvm_error("run_phase" , $sformatf("comparsion failed trasnsaction received by the dut %s shile the reference out %ob" ,seq_item_sb.convert2string , data_out_ref )) ;
               error_count++ ;
            end
            else
            begin
               `uvm_info("run_phase" ,seq_item_sb.convert2string() , UVM_HIGH ) ;
               correct_count++ ;
            end
         end
        endtask

        task ref_model(FIFO_seq_item seq_item);
            fork
                begin
                    if (!seq_item.rst_n) begin
                        mem_queue.delete();	
                    end
                    else if (seq_item.wr_en && count < seq_item.FIFO_DEPTH) begin
                        mem_queue.push_back(seq_item.data_in) ;
                        wr_ack_ref = 1;
                    end
                    else begin 
                        wr_ack_ref = 0; 
                        if (full_ref & seq_item.wr_en)
                        overflow_ref = 1;
                        else
                        overflow_ref = 0;
                    end
                end
                begin
                    if (!seq_item.rst_n) begin
                        data_out_ref = 0 ;
                    end
                    else if (seq_item.rd_en && count != 0) begin
                        data_out_ref = mem_queue.pop_front() ;
                    end
                    else begin 
                        if (empty_ref && seq_item.rd_en)
                        underflow_ref = 1;
                        else
                        underflow_ref = 0 ;
                    end
                end
            join
    

    
            if (!seq_item.rst_n) begin
                count = 0;
            end
            else begin
                if	( ({seq_item.wr_en, seq_item.rd_en} == 2'b10) && !full_ref) 
                    count = count + 1;
                else if ( ({seq_item.wr_en, seq_item.rd_en} == 2'b01) && !empty_ref)
                    count = count - 1;
                else if ( ({seq_item.wr_en, seq_item.rd_en} == 2'b11) && empty_ref)
                    count = count + 1;	
                else if	( ({seq_item.wr_en, seq_item.rd_en} == 2'b11) && full_ref) 
                    count = count - 1;
            end
            full_ref = (count == FIFO_DEPTH)? 1 : 0;
            empty_ref = (count == 0)? 1 : 0;
            almostfull_ref = (count == FIFO_DEPTH-1)? 1 : 0; 
            almostempty_ref = (count == 1)? 1 : 0;

        endtask 

        function void report_phase(uvm_phase phase) ;
         super.report_phase(phase);
         `uvm_info("report_phase" ,$sformatf("total successful %0d  " ,correct_count ) , UVM_MEDIUM ) ;
         `uvm_info("report_phase" ,$sformatf("total FAILED %0d  " ,error_count ) , UVM_MEDIUM ) ;  
      endfunction
   endclass
endpackage