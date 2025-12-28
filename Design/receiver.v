module receiver (rx_data,rx_done,error_flag,clk,reset,rx_serial_in,rx_enb);

  input clk, reset, rx_serial_in, rx_enb;
  output reg [7:0] rx_data;
  output reg rx_done, error_flag;

  localparam idle  = 2'd0;
  localparam start = 2'd1;
  localparam data  = 2'd2;
  localparam stop  = 2'd3;

  reg [1:0] state;
  reg [2:0] bit_index;      // counts 0?7 for 8 data bits
  reg [7:0] shift_reg;
  reg rx_sync0, rx_sync1;

  // Double-flop synchronizer to avoid metastability
  always @(posedge clk) begin
    rx_sync0 <= rx_serial_in;
    rx_sync1 <= rx_sync0;
  end

  // State machine
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state      <= idle;
      rx_done    <= 1'b0;
      error_flag <= 1'b0;
      bit_index  <= 3'd0;
      shift_reg  <= 8'd0;
      rx_data    <= 8'd0;
    end else begin
      rx_done    <= 1'b0;
      error_flag <= 1'b0;

      case (state)
        idle: begin
          if (~rx_sync1) begin
            state <= start;
          end
        end

        start: begin
          if (rx_enb) begin
            if (~rx_sync1) begin
              bit_index <= 3'd0;
              state     <= data;
            end else begin
              state <= idle;
            end
          end
        end

        data: begin
          if (rx_enb) begin
            shift_reg[bit_index] <= rx_sync1;
            if (bit_index == 3'd7) begin
              state <= stop;
            end else begin
              bit_index <= bit_index + 1'b1;
            end
          end
        end

        stop: begin
          if (rx_enb) begin
            rx_data <= shift_reg;
            rx_done <= 1'b1;

            if (~rx_sync1) begin
              error_flag <= 1'b1;  // framing error
            end

            state <= idle;
          end
        end

        default: state <= idle;
      endcase
    end
  end

endmodule
`timescale 1ns / 1ps

module receiver_tb;
  reg clk, reset;
  reg rx_serial_in;
  wire [7:0] rx_data;
  wire rx_done, error_flag;
  wire Rx_en;

  // Baud generator (for Rx enable)
  baudgene bg (.Tx_en(), .Rx_en(Rx_en), .clk(clk), .reset(reset));

  // Receiver
  receiver uut (
    .rx_data(rx_data),
    .rx_done(rx_done),
    .error_flag(error_flag),
    .clk(clk),
    .reset(reset),
    .rx_serial_in(rx_serial_in),
    .rx_enb(Rx_en)
  );

  // Clock
  initial clk = 0;
  always #50 clk = ~clk;

  initial begin
    reset = 1; rx_serial_in = 1;
    #50; reset = 0;

    // Simulate a start bit, 8 data bits, and stop bit
    // Start bit
    rx_serial_in = 0; #104160;
    // Data bits (0xA5 = 10100101, LSB first)
    rx_serial_in = 1; #104160;
    rx_serial_in = 0; #104160;
    rx_serial_in = 1; #104160;
    rx_serial_in = 0; #104160;
    rx_serial_in = 0; #104160;
    rx_serial_in = 1; #104160; 
    rx_serial_in = 0; #104160;
    rx_serial_in = 1; #104160;
    // Stop bit
    rx_serial_in = 1; #104160;

    #1000;
    $stop;
  end

  initial begin
    $monitor("Time=%0t | RX_DATA=%h | RX_DONE=%b | ERROR=%b",
              $time, rx_data, rx_done, error_flag);
  end
endmodule
     
`timescale 1ns / 1ps

module receiver_tb;
  reg clk, reset;
  reg rx_serial_in;
  wire [7:0] rx_data;
  wire rx_done, error_flag;
  wire Rx_en;

  // Baud generator (for Rx enable)
  baudgene bg (.Tx_en(), .Rx_en(Rx_en), .clk(clk), .reset(reset));

  // Receiver
  receiver uut (
    .rx_data(rx_data),
    .rx_done(rx_done),
    .error_flag(error_flag),
    .clk(clk),
    .reset(reset),
    .rx_serial_in(rx_serial_in),
    .rx_enb(Rx_en)
  );

  // Clock
  initial clk = 0;
  always #50 clk = ~clk;

  initial begin
    reset = 1; rx_serial_in = 1;
    #50; reset = 0;

    // Simulate a start bit, 8 data bits, and stop bit
    // Start bit
    rx_serial_in = 0; #104160;
    // Data bits (0xA5 = 10100101, LSB first)
    rx_serial_in = 1; #104160;
    rx_serial_in = 0; #104160;
    rx_serial_in = 1; #104160;
    rx_serial_in = 0; #104160;
    rx_serial_in = 0; #104160;
    rx_serial_in = 1; #104160; 
    rx_serial_in = 0; #104160;
    rx_serial_in = 1; #104160;
    // Stop bit
    rx_serial_in = 1; #104160;

    #1000;
    $stop;
  end

  initial begin
    $monitor("Time=%0t | RX_DATA=%h | RX_DONE=%b | ERROR=%b",
              $time, rx_data, rx_done, error_flag);
  end
endmodule