class seq extends uvm_sequence #(seq_item);
  `uvm_object_utils(seq)
  
  function new(string name="sequence");
    super.new(name);
  endfunction
  
  byte a,i;
  
  task body();
    `uvm_info("Random","Sequence",UVM_LOW);
//     `uvm_do_with(req,{slv_addr==7'b0000000; rd_wr==0;})
    repeat(1) begin
      `uvm_info("Random","Sequence",UVM_LOW);
      `uvm_do_with(req,{slv_addr inside {`bit7,`bit10}; rd_wr==0; rpt==1;})
      i=req.int_addr;
      a=req.slv_addr;
      `uvm_do_with(req,{slv_addr==a; rd_wr==1; int_addr==i; rpt==1;})
    end
    `uvm_do_with(req,{slv_addr==7'b0000000; rpt==0;})
  endtask
  
endclass