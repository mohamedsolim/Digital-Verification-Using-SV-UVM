////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(FIFO_inter.DUT  FIFO_if);
 
localparam max_fifo_addr = $clog2(FIFO_if.FIFO_DEPTH);

reg [FIFO_if.FIFO_WIDTH-1:0] mem [FIFO_if.FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

always @(posedge FIFO_if.clk or negedge FIFO_if.rst_n) begin
	if (!FIFO_if.rst_n) begin
		wr_ptr <= 0;
	end
	else if (FIFO_if.wr_en && count < FIFO_if.FIFO_DEPTH) begin
		mem[wr_ptr] <= FIFO_if.data_in;
		FIFO_if.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
	end
	else begin 
		FIFO_if.wr_ack <= 0; 
		if (FIFO_if.full && FIFO_if.wr_en)
		FIFO_if.overflow <= 1;
		else
		FIFO_if.overflow <= 0 ;
	end
end

always @(posedge FIFO_if.clk or negedge FIFO_if.rst_n) begin
	if (!FIFO_if.rst_n) begin
		rd_ptr <= 0;
		FIFO_if.data_out <= 0;
	end
	else if (FIFO_if.rd_en && count != 0) begin
		FIFO_if.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
	end
	else begin 
		if (FIFO_if.empty && FIFO_if.rd_en)
		FIFO_if.underflow <= 1;
		else
		FIFO_if.underflow <= 0 ;
	end
end

always @(posedge FIFO_if.clk or negedge FIFO_if.rst_n) begin
	if (!FIFO_if.rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({FIFO_if.wr_en, FIFO_if.rd_en} == 2'b10) && !FIFO_if.full) 
			count <= count + 1;
		else if ( ({FIFO_if.wr_en, FIFO_if.rd_en} == 2'b01) && !FIFO_if.empty)
			count <= count - 1;
		else if ( ({FIFO_if.wr_en, FIFO_if.rd_en} == 2'b11) && FIFO_if.empty)
			count <= count + 1;	
		else if	( ({FIFO_if.wr_en, FIFO_if.rd_en} == 2'b11) && FIFO_if.full) 
			count <= count - 1;
	end
end

assign FIFO_if.full = (count == FIFO_if.FIFO_DEPTH)? 1 : 0;
assign FIFO_if.empty = (count == 0)? 1 : 0;
assign FIFO_if.almostfull = (count == FIFO_if.FIFO_DEPTH-1)? 1 : 0; 
assign FIFO_if.almostempty = (count == 1)? 1 : 0;

		property prop1 ;
			@(posedge FIFO_if.clk )
			disable iff (!FIFO_if.rst_n)
			(FIFO_if.wr_en && count < FIFO_if.FIFO_DEPTH) |=>  (FIFO_if.wr_ack ) ;
		endproperty
		prop1_assertion:  assert property (prop1) ;
		prop1_cover: cover property (prop1) ;

		property prop2 ;
			@(posedge FIFO_if.clk )
			disable iff (!FIFO_if.rst_n)
			( FIFO_if.full && FIFO_if.wr_en ) |=>  (FIFO_if.overflow ) ;
		endproperty
		prop2_assertion:  assert property (prop2) ;
		prop2_cover: cover property (prop2) ;
		always_comb begin
			if (count == 0) begin
				prop3_assertion : assert (FIFO_if.empty && !FIFO_if.full && !FIFO_if.almostempty && !FIFO_if.almostfull) ;
				prop3_cover     : cover  (FIFO_if.empty && !FIFO_if.full && !FIFO_if.almostempty && !FIFO_if.almostfull)      ;
			end
			if (count == 1) begin
				prop4_assertion : assert (!FIFO_if.empty && !FIFO_if.full && FIFO_if.almostempty && !FIFO_if.almostfull) ;
				prop4_cover     : cover  (!FIFO_if.empty && !FIFO_if.full && FIFO_if.almostempty && !FIFO_if.almostfull)      ;
			end
			if (count == FIFO_if.FIFO_DEPTH-1) begin
				prop5_assertion : assert (!FIFO_if.empty && !FIFO_if.full && !FIFO_if.almostempty && FIFO_if.almostfull);
				prop5_cover     : cover  (!FIFO_if.empty && !FIFO_if.full && !FIFO_if.almostempty && FIFO_if.almostfull)     ;
			end
			if (count == FIFO_if.FIFO_DEPTH) begin
				prop6_assertion : assert (!FIFO_if.empty && FIFO_if.full && !FIFO_if.almostempty && !FIFO_if.almostfull) ;
				prop6_cover     : cover  (!FIFO_if.empty && FIFO_if.full && !FIFO_if.almostempty && !FIFO_if.almostfull)      ;
			end
		end
	
		property prop7 ;
			@(posedge FIFO_if.clk )
			disable iff (!FIFO_if.rst_n)
			(FIFO_if.empty && FIFO_if.rd_en) |=>  ( FIFO_if.underflow ) ;
		endproperty
		prop7_assertion:  assert property (prop7) ;
		prop7_cover: cover property (prop7) ;


		property prop8 ;
			@(posedge FIFO_if.clk )
			disable iff (!FIFO_if.rst_n)
			(FIFO_if.wr_en && !FIFO_if.rd_en && !FIFO_if.full ) |=>  ( count === ($past(count) + 1 ) ) ;
		endproperty
		prop8_assertion:  assert property (prop8) ;
		prop8_cover: cover property (prop8) ;

		property prop9 ;
			@(posedge FIFO_if.clk )
			disable iff (!FIFO_if.rst_n)
			( !FIFO_if.wr_en && FIFO_if.rd_en && !FIFO_if.empty ) |=>  ( count === ($past(count) - 1 ) ) ;
		endproperty
		prop9_assertion:  assert property (prop9) ;
		prop9_cover: cover property (prop9) ;

		property prop10 ;
			@(posedge FIFO_if.clk )
			disable iff (!FIFO_if.rst_n)
			( FIFO_if.wr_en && FIFO_if.rd_en && FIFO_if.empty ) |=>  ( count === ($past(count) + 1 ) ) ;
		endproperty
		prop10_assertion:  assert property (prop10) ;
		prop10_cover: cover property (prop10) ;


		property prop11 ;
			@(posedge FIFO_if.clk )
			disable iff (!FIFO_if.rst_n)
			( FIFO_if.wr_en && FIFO_if.rd_en && FIFO_if.full ) |=>  ( count === ($past(count) - 1 ) ) ;
		endproperty
		prop11_assertion:  assert property (prop11) ;
		prop11_cover: cover property (prop11) ;

endmodule