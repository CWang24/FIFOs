module FIFO_explength (clk, reset, data_in, put, get, data_out, fillcount, empty, full);
input put, get, reset, clk;
output empty, full;
parameter DEPTH_P2 = 16;
parameter DEPTH_P = 4;
parameter DEPTH_P0 = 3;//depth of the two fifo.
parameter WIDTH = 16;
input [WIDTH-1 : 0] data_in;
output [WIDTH-1 : 0] data_out;
output [DEPTH_P:0] fillcount;
wire [WIDTH-1 : 0] data_out_b, data_out_t;
reg [DEPTH_P-1:0] wr_ptr,rd_ptr;
wire empty, full, empty_b, empty_t, full_t, full_b, put_t, get_t, put_b, get_b;
wire [DEPTH_P0:0] fillcount_t, fillcount_b;

always@(posedge clk)
	begin
		if(reset==1)
			begin
				wr_ptr<=4'b0000;
				rd_ptr<=4'b0000;
			end
		if(reset==0)
			begin
				if((put)&&(!full)) wr_ptr<=wr_ptr+1;
				if((get)&&(!empty)) rd_ptr<=rd_ptr+1;
			end
	end
	
assign data_out=(rd_ptr>=7)? data_out_t : data_out_b;
assign empty=empty_b;
assign full=full_t;
assign fillcount=fillcount_t+fillcount_b;
assign put_t=((put)&&(wr_ptr>=7));
assign put_b=((put)&&(wr_ptr<7));
assign get_t=((get)&&(rd_ptr>=7));
assign get_b=((get)&&(rd_ptr<7));
FIFO myfifotop   (clk, reset, data_in, put_t, get_t, data_out_t, fillcount_t, empty_t, full_t);
FIFO myfifobottom(clk, reset, data_in, put_b, get_b, data_out_b, fillcount_b, empty_b, full_b);
endmodule













