/*
  Memory module using Verilog declared RAM
*/
module mem
#(
   parameter DEPTH = 8
  ,parameter WIDTH = 8
)(
   input                            clock
  ,input                            resetn
  ,input                            en
  ,input        [$clog2(DEPTH)-2:0] r_addr
  ,output logic [WIDTH        -1:0] r_data
  ,input        [$clog2(DEPTH)-2:0] w_addr
  ,input        [WIDTH        -1:0] w_data
);

logic [WIDTH-1:0] mem [0:DEPTH/2-1];

/*
  Read Data
*/
assign r_data = mem[r_addr];

/*
  Write Data
*/
always @(posedge clock)
if (en) mem[w_addr] <= w_data; 


endmodule
