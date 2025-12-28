module fd(output tx_serial_out,output tx_done,output [7:0] rx_data,output rx_done,output error_flag,
  input  clk,
 input  reset,
  input  Tx_start,
  input  [7:0] data_in,
  input  rx_serial_in);
  wire Tx_en;
  wire Rx_en;
 
// Baud Generator
  baudgene bg ( .clk(clk), .reset(reset), .Tx_en(Tx_en), .Rx_en(Rx_en));
// Transmitter
  transmitter txx (.tx(tx_serial_out), .tx_done(tx_done), .clk(clk), .rst(reset), .Tx_start(Tx_start),
 .data_in(data_in),
    .tx_enb(Tx_en));
// Receiver
  receiver rxx (.rx_data(rx_data),.rx_done(rx_done),.error_flag(error_flag),.clk(clk),.reset(reset),
    .rx_serial_in(rx_serial_in),
    .rx_enb(Rx_en));
endmodule


