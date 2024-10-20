module TOP_FIFO ();

    bit clk ;
    initial begin
        clk = 0;
        forever
          #10 clk = ~clk;
      end

      FIFO_inter  FIFO_if (clk) ;
      FIFO    DUT (FIFO_if);
      FIFO_monitor   mon (FIFO_if);
      FIFO_tb  test (FIFO_if);

endmodule