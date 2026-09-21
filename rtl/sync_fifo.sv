module sync_fifo #(
    parameter int DATA_WIDTH = 8,
    parameter int FIFO_DEPTH = 16
) (
    input logic clk,
    input logic rst_n,

    input logic wr_en,
    input logic [DATA_WIDTH-1:0] wr_data,
    output logic full,

    input logic rd_en,
    output logic [DATA_WIDTH-1:0] rd_data,
    output logic empty
);

  localparam int PTR_WIDTH = $clog2(FIFO_DEPTH) + 1;

  logic [ PTR_WIDTH-1:0] wr_ptr;
  logic [ PTR_WIDTH-1:0] rd_ptr;
  logic [DATA_WIDTH-1:0] fifo_ram[FIFO_DEPTH];

  assign empty = (wr_ptr == rd_ptr);

  assign full  = (wr_ptr[PTR_WIDTH-1] != rd_ptr[PTR_WIDTH-1]) &&
                   (wr_ptr[PTR_WIDTH-2:0] == rd_ptr[PTR_WIDTH-2:0]);

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      wr_ptr <= '0;
      rd_ptr <= '0;
    end else begin
      if (wr_en && !full) wr_ptr <= wr_ptr + 1;
      if (rd_en && !empty) rd_ptr <= rd_ptr + 1;
    end
  end

  always_ff @(posedge clk) begin
    if (wr_en && !full) begin
      fifo_ram[wr_ptr[PTR_WIDTH-2:0]] <= wr_data;
    end
  end

  assign rd_data = fifo_ram[rd_ptr[PTR_WIDTH-2:0]];

endmodule
