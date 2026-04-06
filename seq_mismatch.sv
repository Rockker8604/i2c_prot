class seq_mismatch extends uvm_sequence #(seq_item);
  `uvm_object_utils(seq_mismatch)
  
  function new(string name="mismatching addresses");
    super.new(name);
  endfunction
  
  byte i;
  
  task body();
    repeat(5) begin
      $display("Slave Nack","Slave address mismatch Sequence",UVM_LOW);
      `uvm_do_with(req,{!(slv_addr inside {`bit7}); bit_10==0; rpt==0;})
      `uvm_do_with(req,{!(slv_addr inside {`bit10}); bit_10==1; rpt==0;})
    end
    repeat(5) begin
      $display("Reg Nack","Register address mismatch Sequence",UVM_MEDIUM);
      `uvm_do_with(req,{slv_addr inside {`bit7}; bit_10==0; rpt==0; int_addr>15;})
      `uvm_do_with(req,{slv_addr inside {`bit10}; bit_10==1; rpt==0; int_addr>15;})
    end
  endtask
  
endclass