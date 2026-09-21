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
    // 1. Başlangıç ve Reset
    clk   = 0;
    rst_n = 0;
    start = 0;
    #15 rst_n = 1;  // Sistemi uyandır

    #10;
    // 2. FSM'yi tetikle
    @(posedge clk);
    #1;
    start = 1;  // start butonuna bas

    // Sadece 1 saat vuruşu boyunca basılı tutup elimizi çekiyoruz
    @(posedge clk);
    #1;
    start = 0;

    // 3. FSM'nin kendi kendine AA, BB, CC yazmasını izlemek için bekle
    #50;

    $display("FSM Testi Tamamlandi!");
    $finish;
  end
endmodule
