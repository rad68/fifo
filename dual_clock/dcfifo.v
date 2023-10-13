`timescale 1ns/1ps
/*
  Asynchronous Dual Clock FIFO

  If FIFO not empty - dout is a valid data value

  Cummings approved :) Style #2
*/
module dcfifo #(
  parameter DEPTH = 16,
  parameter WIDTH = 8
)(
  input                     w_clock,
  input                     r_clock,
  input                     resetn,
  input                     wr,
  input         [WIDTH-1:0] din,
  input                     rd,
  output  logic [WIDTH-1:0] dout,
  output  logic             full,
  output  logic             empty
);

localparam l_DEPTH = $clog2(DEPTH);

logic [l_DEPTH-1:0] r_ptr, r_ptr_next, r_ptr_sync, 
                    w_ptr, w_ptr_next, w_ptr_sync;
logic [l_DEPTH-2:0] r_addr, w_addr;

/*
  Read Clock Domain
*/

sync2 #(
  .DATA_WIDTH(l_DEPTH)
) r_sync (
   .clock   (r_clock    )
  ,.resetn  (resetn     )
  ,.din     (w_ptr      )
  ,.dout    (w_ptr_sync )
);

empty_gen #(
  .DEPTH(DEPTH)
) empty_gen (
   .clock   (r_clock    )
  ,.resetn  (resetn     )
  ,.ptr1    (r_ptr_next )
  ,.ptr2    (w_ptr_sync )
  ,.empty   (empty      )
);

ptr_gen #(
  .DEPTH(DEPTH)
) r_ptr_gen (
   .clock   (r_clock    )
  ,.resetn  (resetn     )
  ,.flag    (empty      )
  ,.inc     (rd         ) 
  ,.ptr     (r_ptr      )
  ,.ptr_next(r_ptr_next )
  ,.addr    (r_addr     )
);

/*
  Write Clock Domain
*/

sync2 #(
  .DATA_WIDTH(l_DEPTH)
) w_sync (
   .clock   (w_clock    )
  ,.resetn  (resetn     )
  ,.din     (r_ptr      )
  ,.dout    (r_ptr_sync )
);

full_gen #(
  .DEPTH(DEPTH)
) full_gen (
   .clock   (w_clock    )
  ,.resetn  (resetn     )
  ,.ptr1    (w_ptr_next )
  ,.ptr2    (r_ptr_sync )
  ,.full    (full       )
);

ptr_gen #(
  .DEPTH(DEPTH)
) w_ptr_gen (
   .clock   (w_clock    )
  ,.resetn  (resetn     )
  ,.flag    (full       )
  ,.inc     (wr         )
  ,.ptr     (w_ptr      )
  ,.ptr_next(w_ptr_next )
  ,.addr    (w_addr     )
);

/*
  Memory
*/
logic mem_wr;
assign mem_wr = wr && !full;

mem #(
   .DEPTH(DEPTH)
  ,.WIDTH(WIDTH)
) mem (
   .clock   (w_clock  )
  ,.resetn  (resetn   )
  ,.en      (mem_wr   ) 
  ,.r_addr  (r_addr   )
  ,.r_data  (dout     )
  ,.w_addr  (w_addr   )
  ,.w_data  (din      )
);

endmodule

