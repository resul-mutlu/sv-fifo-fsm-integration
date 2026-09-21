`timescale 1ns / 1ps

module tb_top_system ();
  // Dış dünya sinyalleri
  logic clk;
  logic rst_n;
  logic start;
  logic rd_en;

  logic [7:0] rd_data;
  logic empty;
  logic full;

  // Ana kartı (Top System) test masasına koyuyoruz
  top_system dut (
      .clk    (clk),
      .rst_n  (rst_n),
      .start  (start),
      .rd_en  (rd_en),
      .rd_data(rd_data),
      .empty  (empty),
      .full   (full)
  );

  // Saat sinyali üretici
  always #5 clk = ~clk;

  initial begin
    $dumpfile("top_dump.vcd");
    $dumpvars(0, tb_top_system);
  end

  initial begin
    // 1. BAŞLANGIÇ
    clk   = 0;
    rst_n = 0;
    start = 0;
    rd_en = 0;
    #15 rst_n = 1;  // Sistemi uyandır
    #10;

    // 2. FSM'Yİ TETİKLE (Sadece tek bir start verip çekiliyoruz)
    @(posedge clk);
    #1;
    start = 1;
    @(posedge clk);
    #1;
    start = 0;

    // FSM'nin kendi kendine FIFO'yu doldurması için zaman tanıyoruz
    #50;

    // 3. DIŞ DÜNYADAN FIFO'YU OKUMA İŞLEMİ
    // FSM işini bitirdi, şimdi biz dışarıdan okuma emri verip
    // o AA, BB, CC verilerini dışarı çekebilecek miyiz ona bakıyoruz.
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
