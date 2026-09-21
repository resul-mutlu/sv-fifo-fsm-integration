module top_system (
    input logic clk,
    input logic rst_n,
    input logic start,
    input logic rd_en,

    output logic [7:0] rd_data,
    output logic empty,
    output logic full
);

  logic w_wr_en;
  logic [7:0] w_wr_data;

  fifo_controller fsm_inst (
      .clk(clk),
      .rst_n(rst_n),
      .start(start),
      .wr_en(w_wr_en),
      .wr_data(w_wr_data)
  );

  sync_fifo #(
      .DATA_WIDTH(8),
      .FIFO_DEPTH(16)
  ) fifo_inst (
      .clk    (clk),
      .rst_n  (rst_n),
      .wr_en  (w_wr_en),
      .wr_data(w_wr_data),
      .full   (full),
      .rd_en  (rd_en),
      .rd_data(rd_data),
      .empty  (empty)
  );
endmodule
