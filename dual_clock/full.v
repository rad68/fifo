/*
  Module generating full flag in the write clock domain
  to prevent write to the full FIFO

  ptr1 - next write pointer
  ptr2 - synchronized read pointer

*/

module full_gen
#(
  parameter DEPTH = 8
)(
   input                            clock
  ,input                            resetn
  ,input        [$clog2(DEPTH)-1:0] ptr1
  ,input        [$clog2(DEPTH)-1:0] ptr2
  ,output logic                     full
);

localparam l_DEPTH = $clog2(DEPTH);

always @(posedge clock)
if (!resetn)  full <= 1'b0;
else          full <= ptr1 == {~ptr2[l_DEPTH-1:l_DEPTH-2],ptr2[l_DEPTH-3:0]};

endmodule
