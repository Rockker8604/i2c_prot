class seq_directed extends uvm_sequence #(seq_item);
  `uvm_object_utils(seq_directed)
  
  function new(string name="Directed");
    super.new(name);
  endfunction
  
  int q[$];
  byte a,i;
  int s;
  task body();
    q=q.unique();
    repeat(256-q.size()) begin
      `uvm_info("Directed Test","Directed test Sequence",UVM_LOW);
      `uvm_do_with(req,{slv_addr inside {`bit7,`bit10}; rd_wr==0; rpt==0; !(wdata inside {q});})
      i=req.int_addr;
      a=req.slv_addr;
      q.push_back(req.wdata);
      `uvm_do_with(req,{slv_addr==a; rd_wr==1; int_addr==i; rpt==0;})
    end
  endtask
  
endclass