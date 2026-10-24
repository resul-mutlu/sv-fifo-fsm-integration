`timescale 1ns / 1ps

module tb_fifo_controller ();
  logic clk;
  logic rst_n;
  logic start;
  logic wr_en;
  logic [7:0] wr_data;

  fifo_controller dut (
      .clk(clk),
      .rst_n(rst_n),
      .start(start),
      .wr_en(wr_en),
      .wr_data(wr_data)
  );

  always #5 clk = ~clk;

  initial begin
    $dumpfile("fsm_dump.vcd");
    $dumpvars(0, tb_fifo_controller);
  end

  initial begin
    clk   = 0;
    rst_n = 0;
    start = 0;
    #15 rst_n = 1;

    #10;
    @(posedge clk);
    #1;
    start = 1;

    @(posedge clk);
    #1;
    start = 0;

    #50;

    $display("FSM Testi Tamamlandi!");
    $finish;
  end
endmodule
