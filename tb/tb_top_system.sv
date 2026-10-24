`timescale 1ns / 1ps

module tb_top_system ();
  logic clk;
  logic rst_n;
  logic start;
  logic rd_en;

  logic [7:0] rd_data;
  logic empty;
  logic full;

  top_system dut (
      .clk    (clk),
      .rst_n  (rst_n),
      .start  (start),
      .rd_en  (rd_en),
      .rd_data(rd_data),
      .empty  (empty),
      .full   (full)
  );

  always #5 clk = ~clk;

  initial begin
    $dumpfile("top_dump.vcd");
    $dumpvars(0, tb_top_system);
  end

  initial begin
    clk   = 0;
    rst_n = 0;
    start = 0;
    rd_en = 0;
    #15 rst_n = 1;
    #10;

    @(posedge clk);
    #1;
    start = 1;
    @(posedge clk);
    #1;
    start = 0;

    #50;


    for (int i = 0; i < 3; i++) begin
      @(posedge clk);
      #1;
      rd_en = 1;
    end
    @(posedge clk);
    #1;
    rd_en = 0;

    #30;
    $display("Sistem Entegrasyon Testi Tamamlandi!");
    $finish;
  end
endmodule
