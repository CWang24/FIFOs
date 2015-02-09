module FIFO_2clk (write_clk, read_clk, reset, data_in, put, get, data_out, empty, full);
//--depth and width of the fifo--//
parameter WIDTH = 8;
parameter DEPTH_P2 = 8;
parameter DEPTH_P = 3;
input put,get;
input reset, read_clk, write_clk; 
input [WIDTH-1 : 0] data_in;
output empty, full;
output [WIDTH-1 : 0] data_out;

//--reg--//
wire empty;
wire full;
reg [WIDTH-1 : 0] mem [DEPTH_P2-1 : 0];
reg [WIDTH-1 : 0] data_out;
reg [DEPTH_P:0] rd_pointer;
reg [DEPTH_P:0] rd_gray;
reg [DEPTH_P:0] rd_gray_s;
reg [DEPTH_P:0] rd_gray_ss;
reg [DEPTH_P:0] rd_pointer_ss;
reg [DEPTH_P:0] wr_pointer;
reg [DEPTH_P:0] wr_gray;
reg [DEPTH_P:0] wr_gray_s;
reg [DEPTH_P:0] wr_gray_ss;
reg [DEPTH_P:0] wr_pointer_ss;

//--coding begin--//
always @ (posedge write_clk or posedge reset)
begin:write_pointer
	if (reset == 1)
		begin
			wr_pointer <= 0;
		end
	else if ( put == 1 && full == 0)
		begin
			wr_pointer  <= wr_pointer + 1;
		end
end

always @ (posedge read_clk or posedge reset)
begin:read_pointer
	if (reset == 1)
		begin
			rd_pointer <= 0;
		end
	else if ( get == 1 && empty == 0)
		begin
			rd_pointer	<=  rd_pointer + 1;
		end
end

always @ (posedge read_clk or posedge reset)
begin:read_data
		if (reset == 1)
		begin
			data_out <= 0;
		end
		else if ( get == 1 && empty == 0)
		begin
			data_out <= mem[rd_pointer[DEPTH_P-1:0]];
		end
end

always @ (posedge write_clk or posedge reset)
begin:write_data
		if (reset == 1)
		begin
			mem[0] <= 0;
		end
		else if ( put == 1 && full == 0 )
		begin
			mem[wr_pointer[DEPTH_P-1:0]] <= data_in;
		end
end

always @ (posedge write_clk or posedge reset )
begin:write_clk_double_syn
		if (reset == 1)
		begin
			rd_gray_s <= 0;
			rd_gray_ss <= 0;
		end
		else 
		begin
			rd_gray_s <= rd_gray;
			rd_gray_ss <= rd_gray_s;
		end		
end

always @ (posedge read_clk or posedge reset)
begin:read_clk_double_syn
if (reset == 1)
		begin
		wr_gray_s <= 0;
		wr_gray_ss <= 0;
		end
		else 
		begin
		wr_gray_s <= wr_gray;
		wr_gray_ss <= wr_gray_s;
		end	
end

always @ (*)//gray to binary conversion
begin
	wr_pointer_ss[3]  =                    wr_gray_ss[3]; // B3 <=        G3;
	wr_pointer_ss[2]  = wr_pointer_ss[3] ^ wr_gray_ss[2]; // B2 <= B3 XOR G2;
	wr_pointer_ss[1]  = wr_pointer_ss[2] ^ wr_gray_ss[1]; // B1 <= B2 XOR G1;
	wr_pointer_ss[0]  = wr_pointer_ss[1] ^ wr_gray_ss[0]; // B0 <= B1 XOR G0;
	
	rd_pointer_ss[3]  =                    rd_gray_ss[3]; // B3 <=        G3;
	rd_pointer_ss[2]  = rd_pointer_ss[3] ^ rd_gray_ss[2]; // B2 <= B3 XOR G2;
	rd_pointer_ss[1]  = rd_pointer_ss[2] ^ rd_gray_ss[1]; // B1 <= B2 XOR G1;
	rd_pointer_ss[0]  = rd_pointer_ss[1] ^ rd_gray_ss[0]; // B0 <= B1 XOR G0;
end

always @ (*)//binary to gray conversion
begin
	wr_gray[0]  <= wr_pointer[1] ^ wr_pointer[0]; // G0 <= B1 ^ B0;
	wr_gray[1]  <= wr_pointer[2] ^ wr_pointer[1]; // G1 <= B2 ^ B1;
	wr_gray[2]  <= wr_pointer[3] ^ wr_pointer[2]; // G2 <= B3 ^ B2;
	wr_gray[3]  <=                 wr_pointer[3]; // G3 <=      B3;
	rd_gray[0]  <= rd_pointer[1] ^ rd_pointer[0]; // G0 <= B1 ^ B0;
	rd_gray[1]  <= rd_pointer[2] ^ rd_pointer[1]; // G1 <= B2 ^ B1;
	rd_gray[2]  <= rd_pointer[3] ^ rd_pointer[2]; // G2 <= B3 ^ B2;
	rd_gray[3]  <=                 rd_pointer[3]; // G3 <=      B3;
	
end



assign full =((wr_pointer-rd_pointer_ss) == DEPTH_P2);

assign empty =((wr_pointer_ss-rd_pointer) == 0);





endmodule

