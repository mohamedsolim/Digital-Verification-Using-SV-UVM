package pack_FIFO_coverage;

  import pack_FIFO_transaction::* ;
    class FIFO_coverage ;

      FIFO_transaction F_cvg_txn = new() ;


      covergroup cvr_gp ;
        wr_en_cp : coverpoint F_cvg_txn.wr_en ;
        rd_en_cp : coverpoint F_cvg_txn.rd_en ;
        wr_ack_cp : coverpoint F_cvg_txn.wr_ack ;
        overflow_cp : coverpoint F_cvg_txn.overflow ;
        full_cp : coverpoint F_cvg_txn.full ;
        empty_cp : coverpoint F_cvg_txn.empty ;
        almostfull_cp : coverpoint F_cvg_txn.almostfull ;
        almostempty_cp : coverpoint F_cvg_txn.almostempty ;
        underflow_cp : coverpoint F_cvg_txn.underflow ;

        
        wr_full_cp : cross  wr_en_cp  , full_cp ;
        wr_wr_ack_cp : cross  wr_en_cp , wr_ack_cp ;
        wr_overflow_cp : cross  wr_en_cp , overflow_cp ;
        wr_empty_cp : cross  wr_en_cp  , empty_cp ;
        wr_almostfull_cp : cross  wr_en_cp  , almostfull_cp ;
        wr_almostempty_cp : cross  wr_en_cp  , almostempty_cp ;
        wr_underflow_cp : cross  wr_en_cp  , underflow_cp ;

        rd_full_cp : cross  rd_en_cp  , full_cp 
        {
          ignore_bins rd_full = binsof(rd_en_cp) intersect {1} && binsof(full_cp) intersect {1} ;
        }
        rd_wr_ack_cp : cross  rd_en_cp ,  wr_ack_cp ;        
        rd_overflow_cp : cross  rd_en_cp , overflow_cp ;
        rd_empty_cp : cross  rd_en_cp  , empty_cp ;
        rd_almostfull_cp : cross  rd_en_cp  , almostfull_cp ;
        rd_almostempty_cp : cross  rd_en_cp  , almostempty_cp ;
        rd_underflow_cp : cross  rd_en_cp  , underflow_cp ;


      endgroup 

    function new() ;
      cvr_gp  = new;
    endfunction


      function void  sample_data(input FIFO_transaction F_txn ) ;
        F_cvg_txn = F_txn ;
       cvr_gp.sample();
      endfunction 
          


      
    endclass

endpackage 
