`timescale 1ns / 1ps

module tb_sync_fifo ();

  // Sinyaller
  logic clk;
  logic rst_n;
  logic wr_en;
  logic [7:0] wr_data;
  logic full;
  logic rd_en;
  logic [7:0] rd_data;
  logic empty;

  // Tasarımı Test Masasına Çağırma (Instantiation)
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

  // Orkestra Şefi: Her 5 nanosaniyede bir vuran Saat Sinyali
  always #5 clk = ~clk;

  // GTKWave için Dalga Formu Çıktısı (Çok Kritik!)
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_sync_fifo);
  end

  // Test Senaryosu - OVERFLOW (TAŞMA) TESTİ
  initial begin
    // 1. BAŞLANGIÇ VE RESET
    clk = 0;
    rst_n = 0;
    wr_en = 0;
    wr_data = 0;
    rd_en = 0;
    #15 rst_n = 1;

    // 2. FIFO'YU AĞZINA KADAR DOLDUR (16 Veri)
    // Bir for döngüsü ile arka arkaya 16 saat vuruşunda veri basıyoruz.
    for (int i = 0; i < 16; i++) begin
      @(posedge clk);
      #1;
      wr_en   = 1;
      wr_data = i + 10;  // 10, 11, 12... diye giden sayılar yazılacak
    end

    // 3. FIFO DOLDU! ŞİMDİ ZORLA YAZMAYA ÇALIŞ (Taşma Girişimi)
    // Kuyruk 16 kapasiteliydi. Biz şimdi 17. 18. ve 19. verileri zorla iteceğiz.
    for (int i = 0; i < 3; i++) begin
      @(posedge clk);
      #1;
      wr_en   = 1;
      wr_data = 8'hFF;  // Zorla yazılmaya çalışılan "Yasak Elma" verisi
    end

    @(posedge clk);
    #1;
    wr_en = 0;  // Yazmayı durdur
    #20;

    // 4. İÇERİDEKİ VERİLERİ OKU VE KONTROL ET
    // Bakalım o "FF" verileri kuyruğa girebilmiş mi, yoksa 
    // tasarımımız onları başarıyla reddetmiş mi?
    for (int i = 0; i < 16; i++) begin
      @(posedge clk);
      #1;
      rd_en = 1;
    end

    @(posedge clk);
    #1;
    rd_en = 0;  // Okumayı durdur

    #30;
    $display("Overflow Testi Tamamlandi!");
    $finish;
  end

endmodule
