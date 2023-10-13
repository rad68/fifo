module ptr_gen 
#(
  parameter DEPTH = 8
)(
   input                            clock
  ,input                            resetn
  ,input                            flag
  ,input                            inc
  ,output logic [$clog2(DEPTH)-1:0] ptr, ptr_next
  ,output logic [$clog2(DEPTH)-2:0] addr
);

localparam l_DEPTH = $clog2(DEPTH);

logic inc_ctrl;
assign inc_ctrl = !flag & inc;

/*
  Binary counter
*/
logic [l_DEPTH-1:0] bin, bin_next;
assign bin_next = bin + inc_ctrl;
always @(posedge clock)
if (!resetn)  bin <= 0;
else          bin <= bin_next;

/*
  Binary to Gray code converter
*/
logic [l_DEPTH-1:0] gray;
genvar i;
generate
for (i=0;i<l_DEPTH;i=i+1) begin
  if (i==l_DEPTH-1)
    assign gray[i] = bin_next[i];
  else
  assign gray[i] = bin_next[i] ^ bin_next[i+1];
end
endgenerate

/*
  Synchronization pointer
*/
always @(posedge clock)
if (!resetn)  ptr <= 0;
else          ptr <= gray;

/*
  Flag pointer
*/
assign ptr_next = gray;

/*
  Memory address
*/
assign addr = bin[l_DEPTH-2:0];

endmodule
