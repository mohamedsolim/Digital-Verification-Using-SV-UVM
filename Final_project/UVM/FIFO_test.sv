package FIFO_test_pkg ;

  import FIFO_env_pkg::*;
  import FIFO_config_pkg::*;
  import FIFO_seq_reset_pkg::*;
  import FIFO_seq_main_pkg::*;
  import uvm_pkg::* ;
  `include "uvm_macros.svh"


  class FIFO_test extends uvm_test;
     `uvm_component_utils(FIFO_test)
    FIFO_env  env ;
    FIFO_config  FIFO_config_obj_test ;
    FIFO_reset_sequence reset_sequence  ;
    FIFO_write_sequence write_sequence ;
    FIFO_read_sequence  read_sequence ;
    FIFO_read_and_write_sequence read_and_write_sequence ;
    
     function new(string name = "FIFO_test" , uvm_component parent = null );
        super.new(name ,parent ) ;
     endfunction

     function void build_phase(uvm_phase phase) ;
      super.build_phase(phase);
      env = FIFO_env::type_id::create("env",this );   
      FIFO_config_obj_test = FIFO_config::type_id::create("FIFO_config_obj_test");
      reset_sequence = FIFO_reset_sequence::type_id::create("reset_sequence");
      write_sequence = FIFO_write_sequence::type_id::create("write_sequence");
      read_sequence  = FIFO_read_sequence::type_id::create("read_sequence");
      read_and_write_sequence = FIFO_read_and_write_sequence::type_id::create("read_and_write_sequence");
      if(!uvm_config_db#(virtual FIFO_if)::get (this , "" , "FIFOif" , FIFO_config_obj_test.FIFO_vif ))
        `uvm_fatal("run_phase" , "test - unable to get the virtual interface ") ;
      
      uvm_config_db#(FIFO_config)::set (this , "*" , "CFG" , FIFO_config_obj_test ) ;

   endfunction

   task run_phase(uvm_phase phase) ;
    super.run_phase(phase);
    phase.raise_objection(this);
    `uvm_info("run_phase","reset assert" ,  UVM_LOW)
    reset_sequence.start(env.agt.sqr);
    `uvm_info("run_phase","reset deassert" ,  UVM_LOW)

    `uvm_info("run_phase","write stimulus generation started" ,  UVM_LOW)
    write_sequence.start(env.agt.sqr);
    `uvm_info("run_phase","write stimulus generation ended" ,  UVM_LOW)

    `uvm_info("run_phase","read stimulus generation started" ,  UVM_LOW)
    read_sequence.start(env.agt.sqr);
    `uvm_info("run_phase","read stimulus generation ended" ,  UVM_LOW)


    `uvm_info("run_phase","read and write stimulus generation started" ,  UVM_LOW)
    read_and_write_sequence.start(env.agt.sqr);
    `uvm_info("run_phase","read and write stimulus generation ended" ,  UVM_LOW)
    phase.drop_objection(this);
   endtask:run_phase

  endclass
endpackage