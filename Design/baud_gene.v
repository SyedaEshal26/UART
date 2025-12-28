module baudgene(Tx_en,Rx_en,clk,reset);
input clk,reset;
output reg Tx_en,Rx_en;
 reg [12:0]count1,count2;
always@(posedge clk or posedge reset)begin
if (reset)begin
count1=13'd0;
count2=13'd0;
Tx_en=1'b0;
Rx_en=1'b0;
end else begin
if (count1==13'd5207)begin
 Tx_en=1'b1;
 count1=13'd0;
end else begin
 Tx_en=1'b0;
 count1=count1+1'b1;
 end
if (count2==13'd5207)begin
 Rx_en=1'b1;
count2=13'd0;
end else begin
Rx_en=1'b0;
count2=count2+1'b1;
end
end
end
endmodule

//test bench
module Baudg_tb;
reg clk,reset;
wire Tx_en,Rx_en;
baudgene uut(.clk(clk),.reset(reset),.Tx_en(Tx_en),.Rx_en(Rx_en));
 initial clk =0;
 always #10 clk=~clk; 
 initial begin
reset=1;
#20;           
reset=0;
end
initial begin
$display("Time\tTx_en\tRx_en");
$monitor("%0t\t%b\t%b",$time,Tx_en,Rx_en);
#1_000_000;  
$stop;
end
endmodule  


