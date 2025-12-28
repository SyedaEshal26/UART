`timescale 1ns / 1ps
module fullduplexf_tb;

  // Testbench signals
  reg clk;
  reg reset;
  reg Tx_start;
  reg [7:0] data_in;
  wire tx_serial_out;
  wire tx_done;
  wire rx_done;
  wire error_flag;
  wire [7:0] rx_data;
  reg rx_serial_in;

  always @(*) begin
    rx_serial_in = tx_serial_out;
  end

 
  fd uut (  .clk(clk),.reset(reset),.Tx_start(Tx_start),.data_in(data_in),.rx_serial_in(rx_serial_in),.tx_serial_out(tx_serial_out),.tx_done(tx_done),.rx_data(rx_data),
    .rx_done(rx_done),.error_flag(error_flag) );

 initial clk = 0;
  always #10 clk = ~clk;   // 20 ns period = 50 MHz
  initial begin
    // Initial conditions
    reset = 1;
    Tx_start = 0;
    data_in = 8'd0;

    // Apply reset
    #50;
    reset = 0;

    // Wait a bit
    #100;

    // Transmit byte 0x55 (01010101)
    data_in = 8'b01010101;
    Tx_start = 1;
    #20;
    Tx_start = 0;

    // Wait for TX and RX completion
    wait (tx_done);
    wait (rx_done);

    // Display received data
    $display("--------------------------------------------------------");
    $display("Time = %0t ns | Transmitted = %b | Received = %b | Error = %b",
             $time, data_in, rx_data, error_flag);
    $display("--------------------------------------------------------");

    #10000;
    data_in = 8'hA3;
    Tx_start = 1;
    #20;
    Tx_start = 0;

    wait (tx_done);
    wait (rx_done);

    $display("Time = %0t ns | Transmitted = %b | Received = %b | Error = %b",
             $time, data_in, rx_data, error_flag);

    // End simulation
    #200000;
    $stop;
  end
  initial begin
    $monitor("T=%0t | TX_OUT=%b | RX_IN=%b | TX_DONE=%b | RX_DONE=%b | RX_DATA=%b | ERR=%b",
             $time, tx_serial_out, rx_serial_in, tx_done, rx_done, rx_data, error_flag);
  end

endmodule


