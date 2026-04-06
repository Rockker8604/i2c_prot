class agent extends uvm_agent;
  `uvm_component_utils(agent)
  
  sequencer sqnr,sqnr2;
  driver dri,dri2;
  monitor mon;
  
  function new(string name="Monitor", uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    if(get_is_active==UVM_ACTIVE) begin
      sqnr=sequencer::type_id::create("Sequencer",this);
      dri=driver::type_id::create("Driver",this);
      sqnr2=sequencer::type_id::create("Sequencer2",this);
      dri2=driver::type_id::create("Driver2",this);
    end
    mon=monitor::type_id::create("Monitor",this);
  endfunction
  
  function void connect_phase (uvm_phase phase);
    if(get_is_active==UVM_ACTIVE) begin
      dri.seq_item_port.connect(sqnr.seq_item_export);
      dri2.seq_item_port.connect(sqnr2.seq_item_export);
    end
  endfunction
  
endclass