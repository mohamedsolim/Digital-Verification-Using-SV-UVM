package FIFO_seq_main_pkg;

   import FIFO_seq_item_pkg::*;
   import uvm_pkg::* ;
   `include "uvm_macros.svh"


   class FIFO_write_sequence extends uvm_sequence #(FIFO_seq_item);
      `uvm_object_utils(FIFO_write_sequence)

      FIFO_seq_item  seq_item ;
      function new(string name = "FIFO_write_sequence" );
         super.new(name) ;
      endfunction
      task body;
         repeat(100)
         begin
            seq_item = FIFO_seq_item::type_id::create("seq_item");
            start_item(seq_item);
            seq_item.constraint_mode(0);
            seq_item.write_only.constraint_mode(1);
            assert(seq_item.randomize()) ;
            finish_item(seq_item);
         end         

      endtask 
   endclass


   class FIFO_read_sequence extends uvm_sequence #(FIFO_seq_item);
      `uvm_object_utils(FIFO_read_sequence)

      FIFO_seq_item  seq_item ;
      function new(string name = "FIFO_read_sequence" );
         super.new(name) ;
      endfunction
      task body;
         repeat(100)
         begin
            seq_item = FIFO_seq_item::type_id::create("seq_item");
            start_item(seq_item);
            seq_item.constraint_mode(0);
            seq_item.read_only.constraint_mode(1);
            assert(seq_item.randomize()) ;
            finish_item(seq_item);
         end         

      endtask 
   endclass


   class FIFO_read_and_write_sequence extends uvm_sequence #(FIFO_seq_item);
      `uvm_object_utils(FIFO_read_and_write_sequence)

      FIFO_seq_item  seq_item ;
      function new(string name = "FIFO_read_and_write_sequence" );
         super.new(name) ;
      endfunction
      task body;
         repeat(10000)
         begin
            seq_item = FIFO_seq_item::type_id::create("seq_item");
            start_item(seq_item);
            seq_item.constraint_mode(0);
            seq_item.read_and_write.constraint_mode(1);
            assert(seq_item.randomize()) ;
            finish_item(seq_item);
         end         

      endtask 
   endclass
endpackage