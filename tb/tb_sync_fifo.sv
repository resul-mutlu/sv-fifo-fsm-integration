`timescale 1ns / 1ps

module tb_sync_fifo ();

  logic clk;
  logic rst_n;
  logic wr_en;
  logic [7:0] wr_data;
  logic full;
  logic rd_en;
  logic [7:0] rd_data;
  logic empty;

  sync_fifo #(
      .DATA_WIDTH(8),
      .FIFO_DEPTH(16)
  ) dut (
      .clk(clk),
      .rst_n(rst_n),
      .wr_en(wr_en),
      .wr_data(wr_data),
      .full(full),
      .rd_en(rd_en),
      .rd_data(rd_data),
      .empty(empty)
  );

  always #5 clk = ~clk;

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_sync_fifo);
  end

  initial begin
    clk = 0;
    rst_n = 0;
    wr_en = 0;
    wr_data = 0;
    rd_en = 0;
    #15 rst_n = 1;

    for (int i = 0; i < 16; i++) begin
      @(posedge clk);
      #1;
      wr_en   = 1;
      wr_data = i + 10;
    end


    for (int i = 0; i < 3; i++) begin
      @(posedge clk);
      #1;
      wr_en   = 1;
      wr_data = 8'hFF;
    end

    @(posedge clk);
    #1;
    wr_en = 0;
    #20;


    for (int i = 0; i < 16; i++) begin
      @(posedge clk);
      #1;
      rd_en = 1;
    end

    @(posedge clk);
    #1;
    rd_en = 0;

    #30;
    $display("Overflow Testi Tamamlandi!");
    $finish;
  end

endmodule
