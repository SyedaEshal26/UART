module transmitter( tx,tx_done,clk,rst,Tx_start, data_in,tx_enb);
    output reg tx;
    output reg tx_done ;    // New: transmission complete flag
    input clk;
    input rst;
    input Tx_start;
    input [7:0] data_in;
    input tx_enb;         // From baud generator

localparam idle = 0;
localparam start = 1;
localparam send_data = 2;
localparam stop = 3;

reg [1:0] state;
reg [2:0] index;
reg [7:0] data;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        tx <= 1'b1;
        tx_done <= 1'b0;
        state <= idle;
        index <= 3'd0;
        data <= 8'd0;
    end else begin
        tx_done <= 1'b0;   // Default low each cycle

        case (state)
            idle: begin
                tx <= 1'b1; // Idle line high
                if (Tx_start) begin
                    data <= data_in;
                    index <= 3'd0;
                    state <= start;
                end
            end

            start: begin
                if (tx_enb) begin
                    tx <= 1'b0;   // Start bit
                    state <= send_data;
                end
            end

            send_data: begin
                if (tx_enb) begin
                    tx <= data[index];   // Send LSB first
                    if (index == 3'd7)
                        state <= stop;
                    else
                        index <= index + 1'b1;
                end
            end

            stop: begin
                if (tx_enb) begin
                    tx <= 1'b1;   // Stop bit
                    tx_done <= 1'b1;  // Signal transmission complete
                    state <= idle;
                end
            end
default: state <= idle;
        endcase
    end
end
endmodule




`timescale 1ns / 1ps

module transmitter_tb;
  reg clk, rst, Tx_start;
  reg [7:0] data_in;
  wire tx, tx_done;
  wire Tx_en;
// Baud generator for TX enable
  baudgene bg (
    .Tx_en(Tx_en),
    .Rx_en(),
    .clk(clk),
    .reset(rst)
  );
// Transmitter 
transmitter uut (.tx(tx),.tx_done(tx_done),.clk(clk),.rst(rst),.Tx_start(Tx_start),.data_in(data_in),.tx_enb(Tx_en));
// Generate clock (50 MHz)
  initial clk = 0;
  always #10 clk = ~clk;

  // Stimulus
  initial begin
    rst = 1; Tx_start = 0; data_in = 8'd0;
    #50; rst = 0;

    // Send first byte
    #100;
    data_in = 8'b01101011;   // Example data (0xAA)
    Tx_start = 1;
    #20; Tx_start= 0;

    // Wait for transmission to finish
    wait (tx_done);
    $display("Time=%0t: Transmission complete for data %b", $time, data_in);

    // Send another byte
    #200;
    data_in = 8'b11001100;   // 0xCC
    Tx_start = 1;
    #50; Tx_start = 0;

    wait (tx_done);
    $display("Time=%0t: Transmission complete for data %b", $time, data_in);

    #1000;
    $stop;
  end

  // Display signal changes
  initial begin
    $monitor("Time=%0t | TX=%b | TX_DONE=%b | DATA=%b",
              $time, tx, tx_done,data_in);
  end

endmodule