
`timescale 1ns/1ps
`include"/home/scf-22/ee577/design_pdk/osu_stdcells/lib/tsmc018/lib/osu018_stdcells.v"
module tb;
parameter WIDTH = 32;//using two width=16
parameter DEPTH_P = 3;
parameter DEPTH_P2 = 8;//depth=8
reg reset, clk, put, get;
reg [WIDTH-1:0] data_in;
wire [WIDTH-1:0] data_out;
wire empty, full;
wire [DEPTH_P:0] fillcount;
integer out;
FIFO_expwidth my_fifo_w (.clk(clk), .reset(reset), .data_in(data_in), .put(put), .get(get), .fillcount(fillcount), .data_out(data_out), .empty(empty), .full(full));
//module FIFO_expwidth (clk, reset, data_in, put, get, data_out, fillcount, empty, full);
always #1 clk = ~clk;

initial begin
$sdf_annotate("~/syn/sdf/FIFO_expwidth.sdf",my_fifo_w,,,"TYPICAL", "1.0:1.0:1.0", "FROM_MTM");
clk = 0;
put = 0;
get = 0;
reset = 1;
out = $fopen("tb_FIFO_expwidth.txt","w");


#2 reset = 0;
#2 put = 1; data_in = 32'h00;
#2 put = 1; data_in = 32'h11;
#2 put = 1; data_in = 32'h22;
#2 put = 1; data_in = 32'h33;
#2 put = 1; data_in = 32'h44;
#2 put = 1; data_in = 32'h55;
#2 put = 1; data_in = 32'h66;
#2 put = 1; get=1; data_in = 32'h77;
#2 put = 1; get=0;data_in = 32'h88;
#2 put = 1; data_in = 32'h99;
#2 put=0;get=1;
#18;
#2 get = 0;
#2 get = 1;put = 1; data_in = 32'h17;
#2 get = 1;put = 1; data_in = 32'h18;
#2 get = 0;put = 1; data_in = 32'h19;
#2 get = 1;put = 0; data_in = 32'h20;
#6;
$fclose(out);

$stop;
end
always @ (posedge clk)
begin 
	//$fwrite(out,"data_out:%h;full:%h;empty:%h;fillcount:%h;\n ",data_out,full,empty,fillcount);
	  $fwrite(out,"data_out:%h;full:%h;empty:%h;fillcount:%h\n ",data_out,full,empty,fillcount);
end
endmodule 

