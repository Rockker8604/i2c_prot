class test extends uvm_test;
  `uvm_component_utils(test)
  
  environment env;
  seq 			sqrn2,sqrn;	// random
  seq_7bit 			sq7;	// 7bit slave
  seq_10bit 		sq10;	// 10bit slave
  seq_rpt_start 	sqrpt;	// repeated start
  seq_mismatch 		sqms;	// address mismatch
  seq_data_override sqov;	// data override
  seq_full_rw 		sqf;	// full write read
  seq_stuck0		sqstk0; // stuck at 0
  seq_stuck1		sqstk1; // stuck at 1
  seq_directed 		sqdr;	// directed test
  
  function new(string name="Test", uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env=environment::type_id::create("Environment",this);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    
    sqrn   = seq				::type_id::create();	// random
    sqrn2  = seq				::type_id::create();	// random
    sq7    = seq_7bit			::type_id::create();	// 7bit slave
    sq10   = seq_10bit			::type_id::create();	// 10bit slave
    sqrpt  = seq_rpt_start		::type_id::create();	// repeated start
    sqms   = seq_mismatch		::type_id::create();	// address mismatch
    sqov   = seq_data_override	::type_id::create();	// data override
    sqf    = seq_full_rw		::type_id::create();	// full write read
    sqstk0 = seq_stuck0			::type_id::create();	// stuck at 0
    sqstk1 = seq_stuck1			::type_id::create();	// stuck at 1
    sqdr   = seq_directed		::type_id::create();	// directed test
    
    phase.raise_objection(this);
    
//     fork
//       sqrn.   start(env.ag.sqnr);	// random
//       sqrn2.  start(env.ag.sqnr2);	// random
//     join
//     sq7.    start(env.ag.sqnr);	// 7bit slave
//     sq10.   start(env.ag.sqnr2);	// 10bit slave
//     sqrpt.  start(env.ag.sqnr);	// repeated start
//     sqms.   start(env.ag.sqnr);	// address mismatch
//     sqov.   start(env.ag.sqnr);	// data override
//     sqf.    start(env.ag.sqnr);	// full write read
    fork
      sqstk0. start(env.ag.sqnr);	// stuck at 0
      sqstk1. start(env.ag.sqnr2);	// stuck at 1
    join
//     sqdr.q=env.sb.q;
//     sqdr.   start(env.ag.sqnr);	// directed test
    phase.drop_objection(this);
  endtask
  
endclass