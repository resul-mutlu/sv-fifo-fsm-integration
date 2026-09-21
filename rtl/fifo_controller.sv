module fifo_controller (
    input logic clk,
    input logic rst_n,
    input logic start,

    output logic wr_en,
    output logic [7:0] wr_data

);

  typedef enum {
    IDLE,
    WRITE1,
    WRITE2,
    WRITE3
  } state_t;

  state_t state, next_state;


  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state <= IDLE;
    end else begin
      state <= next_state;
    end
  end

  always_comb begin
    case (state)
      IDLE:
      if (start) next_state = WRITE1;
      else next_state = IDLE;

      WRITE1: next_state = WRITE2;
      WRITE2: next_state = WRITE3;
      WRITE3: next_state = IDLE;

      default: next_state = IDLE;
    endcase
  end

  always_comb begin
    wr_en   = 0;
    wr_data = 8'h00;
    case (state)
      WRITE1: begin
        wr_en   = 1;
        wr_data = 8'hAA;
      end
      WRITE2: begin
        wr_en   = 1;
        wr_data = 8'hBB;
      end
      WRITE3: begin
        wr_en   = 1;
        wr_data = 8'hCC;
      end
      default: begin
        wr_en   = 0;
        wr_data = 8'h00;
      end
    endcase
  end
endmodule
