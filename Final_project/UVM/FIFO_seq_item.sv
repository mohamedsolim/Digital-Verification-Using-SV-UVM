package FIFO_seq_item_pkg ;
   
   import uvm_pkg::* ;
   `include "uvm_macros.svh"

   class FIFO_seq_item extends uvm_sequence_item;
      `uvm_object_utils(FIFO_seq_item)
      parameter FIFO_WIDTH = 16;
      parameter FIFO_DEPTH = 8;
      
      rand bit rst_n;
      rand bit wr_en;
      rand bit rd_en ;
      rand bit [FIFO_WIDTH-1:0] data_in;
      bit [FIFO_WIDTH-1:0] data_out;
      bit wr_ack, overflow;
      bit full, empty, almostfull, almostempty, underflow;

      constraint write_only{
         wr_en dist {1:/100 , 0:/0  } ;
         rd_en dist {1:/0 , 0:/100  } ; 
         rst_n dist {1:/99 , 0:/1  } ;
             }
         constraint read_only{
         rd_en dist {1:/100 , 0:/0  } ;
         wr_en dist {1:/0 , 0:/100  } ; 
         rst_n dist {1:/99 , 0:/1  } ;
               }
         constraint read_and_write{
            wr_en dist {1:/70 , 0:/30  } ;
            rd_en dist {1:/30 , 0:/70  } ;
            rst_n dist {1:/99 , 0:/1  } ;
                  }
               

      function new(string name = "FIFO_seq_item"   );
         super.new(name ) ;
      endfunction

      function string  convert2string();
         return $sformatf ("%s , rst_n = %0d , wr_en = %0d , rd_en = %0d , data_out = %0d , wr_ack = %0d , data_in = %0d , overflow = %0d , full = %0d , empty = %0d , almostfull = %0d , almostempty = %0d , underflow = %0d " , super.convert2string() , rst_n , wr_en , rd_en , data_out , wr_ack , data_in , overflow , full , empty , almostfull  , almostempty , underflow   ) ;
            endfunction
      
            function string  convert2string_stimulus();
               return $sformatf ("rst_n = %0d , wr_en = %0d , rd_en = %0d, data_in = %0d" ,  rst_n , wr_en , rd_en ,data_in  ) ;
                  endfunction
   endclass
endpackage