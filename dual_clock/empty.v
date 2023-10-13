/*
  Module generating empty flag in the read clock domain
  to prevent read from an empty FIFO

  ptr1 - next read pointer
  ptr2 - synchronized write pointer

*/

module empty_gen
#(
  parameter DEPTH = 8
)(
   input                            clock
  ,input                            resetn
  ,input        [$clog2(DEPTH)-1:0] ptr1
  ,input        [$clog2(DEPTH)-1:0] ptr2
  ,output logic                     empty
);

always @(posedge clock)
if (!resetn)  empty <= 1'b1;
else          empty <= ptr1 == ptr2;

endmodule
