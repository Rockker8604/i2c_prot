class seq_item extends uvm_sequence_item;
  rand bit [9:0]slv_addr;	// slave address
  rand bit [7:0]int_addr;	// register address
  rand bit [7:0]wdata;		// data to slave
  bit [7:0]rdata;			// data from slave
  rand bit rd_wr;			// read or write
  rand bit rpt;				// repeated start
  bit m_ack;				// master read acknowledge
  bit a_ack;				// slave address acknowledge
  bit i_ack;				// register address acknowledge
  bit s_ack;				// write ackacknowledge
  rand bit bit_10;			// 10- bit addressing
  
  constraint reg_addr {soft int_addr<16;}
  constraint slave_addr {if(!bit_10) !(slv_addr inside {[120:123]});}
//   constraint mode7 {soft if(slv_addr inside {`bit7}) bit_10==0;}
//   constraint mode10 {if(slv_addr inside {`bit10}) bit_10==1;}
  
  `uvm_object_utils_begin(seq_item)
  `uvm_field_int(slv_addr,UVM_ALL_ON)
  `uvm_field_int(int_addr,UVM_ALL_ON)
  `uvm_field_int(wdata,UVM_ALL_ON)
  `uvm_field_int(rdata,UVM_ALL_ON)
  `uvm_field_int(rd_wr,UVM_ALL_ON)
  `uvm_field_int(m_ack,UVM_ALL_ON)
  `uvm_field_int(a_ack,UVM_ALL_ON)
  `uvm_field_int(i_ack,UVM_ALL_ON)
  `uvm_field_int(s_ack,UVM_ALL_ON)
  `uvm_field_int(rpt,UVM_ALL_ON)
  `uvm_field_int(bit_10,UVM_ALL_ON)
  `uvm_object_utils_end
  
  function new(string name="seq_item");
    super.new(name);
  endfunction
  
endclass