module sync2
#(
  parameter  DATA_WIDTH = 4
)(
   input                          clock
  ,input                          resetn
  ,input        [DATA_WIDTH-1:0]  din
  ,output logic [DATA_WIDTH-1:0]  dout
);

/*
  2-stage synchronization flip-flops
*/

logic [DATA_WIDTH-1:0] dout1;
always @(posedge clock)
if (!resetn)  {dout, dout1} <= 0;
else          {dout, dout1} <= {dout1, din};

endmodule

