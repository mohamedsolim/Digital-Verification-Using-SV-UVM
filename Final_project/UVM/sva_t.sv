module SVA(FIFO_if.DUT  FIFOif );


    property prop1 ;
        @(posedge FIFOif.clk )
        disable iff (!FIFOif.rst_n)
        (FIFOif.wr_en && dU.count < FIFOif.FIFO_DEPTH) |=>  (FIFOif.wr_ack ) ;
    endproperty
    dollar1_ass:  assert property (prop1) ;
    dollar1_cover: cover property (prop1) ;

    property prop2 ;
        @(posedge FIFOif.clk )
        disable iff (!FIFOif.rst_n)
        ( FIFOif.full && FIFOif.wr_en ) |=>  (FIFOif.overflow ) ;
    endproperty
    dollar2_ass:  assert property (prop2) ;
    dollar2_cover: cover property (prop2) ;


    always_comb begin
		if (dU.count == 0) begin
			dollar3_ass : assert (FIFOif.empty && !FIFOif.full && !FIFOif.almostempty && !FIFOif.almostfull) ;
			dollar3_cover     : cover  (FIFOif.empty && !FIFOif.full && !FIFOif.almostempty && !FIFOif.almostfull)      ;
		end
		if (dU.count == 1) begin
			dollar4_ass : assert (!FIFOif.empty && !FIFOif.full && FIFOif.almostempty && !FIFOif.almostfull) ;
			dollar4_cover     : cover  (!FIFOif.empty && !FIFOif.full && FIFOif.almostempty && !FIFOif.almostfull)      ;
		end
		if (dU.count == FIFOif.FIFO_DEPTH-1) begin
			dollar5_ass : assert (!FIFOif.empty && !FIFOif.full && !FIFOif.almostempty && FIFOif.almostfull);
			dollar5_cover     : cover  (!FIFOif.empty && !FIFOif.full && !FIFOif.almostempty && FIFOif.almostfull)     ;
		end
		if (dU.count == FIFOif.FIFO_DEPTH) begin
			dollar6_ass : assert (!FIFOif.empty && FIFOif.full && !FIFOif.almostempty && !FIFOif.almostfull) ;
			dollar6_cover     : cover  (!FIFOif.empty && FIFOif.full && !FIFOif.almostempty && !FIFOif.almostfull)      ;
		end
	end

    property prop7 ;
        @(posedge FIFOif.clk )
        disable iff (!FIFOif.rst_n)
        (FIFOif.empty && FIFOif.rd_en) |=>  ( FIFOif.underflow ) ;
    endproperty
    dollar7_ass:  assert property (prop7) ;
    dollar7_cover: cover property (prop7) ;


    property prop8 ;
        @(posedge FIFOif.clk )
        disable iff (!FIFOif.rst_n)
        (FIFOif.wr_en && !FIFOif.rd_en && !FIFOif.full ) |=>  ( dU.count === ($past(dU.count) + 1 ) ) ;
    endproperty
    dollar8_ass:  assert property (prop8) ;
    dollar8_cover: cover property (prop8) ;

    property prop9 ;
        @(posedge FIFOif.clk )
        disable iff (!FIFOif.rst_n)
        ( !FIFOif.wr_en && FIFOif.rd_en && !FIFOif.empty ) |=>  ( dU.count === ($past(dU.count) - 1 ) ) ;
    endproperty
    dollar9_ass:  assert property (prop9) ;
    dollar9_cover: cover property (prop9) ;

    property prop10 ;
        @(posedge FIFOif.clk )
        disable iff (!FIFOif.rst_n)
        ( FIFOif.wr_en && FIFOif.rd_en && FIFOif.empty ) |=>  ( dU.count === ($past(dU.count) + 1 ) ) ;
    endproperty
    dollar10_ass:  assert property (prop10) ;
    dollar10_cover: cover property (prop10) ;


    property prop11 ;
        @(posedge FIFOif.clk )
        disable iff (!FIFOif.rst_n)
        ( FIFOif.wr_en && FIFOif.rd_en && FIFOif.full ) |=>  ( dU.count === ($past(dU.count) - 1 ) ) ;
    endproperty
    dollar11_ass:  assert property (prop11) ;
    dollar11_cover: cover property (prop11) ;

endmodule