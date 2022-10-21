module fifo_tb();

localparam DEPTH = 16,
           DEPTH_l = $clog2(DEPTH),
           WIDTH = 8;

reg wr, rd;
reg [WIDTH-1:0] din;
wire [WIDTH-1:0] dout;
wire full, empty;

reg clock;
initial clock = 0;
always #1 clock = ~clock;

task delay;
input [4:0] d;
begin
    repeat (d) @(posedge clock);
end
endtask

reg reset;
task reset_task;
begin
    reset = 0;
    wr = 0;
    rd = 0;
    din = 0;
    delay(10);
    reset = 1;
    delay(10);
    reset = 0;
    delay(10);
end
endtask

integer i;
task wr_task;
input [DEPTH_l:0] num;
begin
    wr = 1;
    for (i = 0; i < num; i = i + 1) begin
        din = $random;
        delay(1);
    end
    wr = 0;
end
endtask

task rd_task;
input [DEPTH_l:0] d;
begin
    rd = 1;
    delay(d);
    rd = 0;
end
endtask

reg [1:0] tmp = 0;
task mix_task;
input [31:0] num;
begin
    for (i = 0; i < num; i = i + 1) begin
        tmp = $random;
        if (tmp == 0) begin
            wr_task($random);
        end else if (tmp == 1) begin
            rd_task($random);
        end else if (tmp == 2) begin
            wr_task($random);
            rd_task($random);
        end else if (tmp == 3) begin
            rd_task($random);
            wr_task($random);
        end
    end
end
endtask

initial begin
    reset_task;
    delay(10);
    wr_task(20);
    delay(20);
    rd_task(20);
    delay(10);
    mix_task(100);
    delay(100);
    $finish;
end

fifo #(
     .DEPTH   (DEPTH)
    ,.DEPTH_l (DEPTH_l)
    ,.WIDTH   (WIDTH)
) fifo (
     .clock (clock)
    ,.reset (reset)
    ,.wr    (wr)
    ,.din   (din)
    ,.rd    (rd)
    ,.dout  (dout)
    ,.full  (full)
    ,.empty (empty)
);

endmodule
