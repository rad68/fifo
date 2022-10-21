module dcfifo_tb();

localparam DEPTH = 16,
           DEPTH_l = $clog2(DEPTH),
           WIDTH = 8;

reg wr, rd;
reg [WIDTH-1:0] din;
wire [WIDTH-1:0] dout;
wire full, empty;

reg fast_clock;
initial fast_clock = 0;
always #1 fast_clock = ~fast_clock;

reg slow_clock;
initial slow_clock = 0;
always #5 slow_clock = ~slow_clock;

task fast_delay;
input [4:0] d;
begin
    repeat (d) @(posedge fast_clock);
end
endtask

task slow_delay;
input [4:0] d;
begin
    repeat (d) @(posedge slow_clock);
end
endtask

reg reset;
task reset_task;
begin
    reset = 0;
    wr = 0;
    rd = 0;
    din = 0;
    fast_delay(10);
    reset = 1;
    fast_delay(10);
    reset = 0;
    fast_delay(10);
end
endtask

integer i;
task wr_task;
input [DEPTH_l:0] num;
begin
    wr = 1;
    for (i = 0; i < num; i = i + 1) begin
        din = $random;
        fast_delay(1);
    end
    wr = 0;
end
endtask

task rd_task;
input [DEPTH_l:0] d;
begin
    rd = 1;
    slow_delay(d);
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
    fast_delay(10);
    wr_task(20);
    fast_delay(20);
    rd_task(20);
    fast_delay(10);
    mix_task(100);
    fast_delay(100);
    $finish;
end

dcfifo #(
    .DEPTH   (DEPTH),
    .DEPTH_l (DEPTH_l),
    .WIDTH   (WIDTH)
) fifo (
    .wclock (fast_clock),
    .rclock (slow_clock),
    .reset (reset),
    .wr    (wr),
    .din   (din),
    .rd    (rd),
    .dout  (dout),
    .full  (full),
    .empty (empty)
);

endmodule
