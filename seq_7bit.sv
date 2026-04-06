class seq_7bit extends uvm_sequence #(seq_item);
  `uvm_object_utils(seq_7bit)
  
  function new(string name="7 bit address");
    super.new(name);
  endfunction
  
  byte i;
  bit [6:0]s;
  
  task body();
    repeat(10) begin
      `uvm_info("7-bit","7 bit slave sequence",UVM_LOW);
      `uvm_do_with(req,{slv_addr inside {`bit7}; rd_wr==0; bit_10==0; rpt==0;})
      s=req.slv_addr;
      i=req.int_addr;
      `uvm_do_with(req,{slv_addr==s; rd_wr==1; bit_10==0; rpt==0; req.int_addr==i;})
    end
  endtask
  
endclass