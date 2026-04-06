interface intface();
//   cannot use logic with inout
  wand scl;
  wand sda;
  
  modport m(input scl, sda);
  modport d(output scl, inout sda);
endinterface