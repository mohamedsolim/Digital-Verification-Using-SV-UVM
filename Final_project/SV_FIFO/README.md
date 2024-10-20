# Synchronous FIFO Systemverilog

## Overview to the testbench flow

### 1. Top Module:

. Generates the clock and passes it to the interface.

. The interface is then shared with the DUT, tb, and monitor.

### 2. Testbench (tb):

. Resets the DUT.

. Randomizes the inputs to the DUT.

. At the end of the simulation, asserts the signal test_finished.

### 3. Monitor Module:

. Creates instances of FIFO_transaction, FIFO_scoreboard, and FIFO_coverage classes.

. Samples the interface at each clock edge in a forever loop.

. Stores the sampled data in the FIFO_transaction object.

. Fork-join is used to simultaneously call methods sample_data (for functional coverage) and check_data (for correctness verification).

### 4. End of Simulation:

. After the fork-join, checks whether test_finished is asserted.

.If test_finished is high, the simulation stops, and a summary of the correct_count and error_count is displayed.

## Classes Used in Verification 

. FIFO_transaction_pkg: Defines the FIFO_transaction class with inputs, outputs, and constraints on the enable signals.

. FIFO_coverage_pkg: Contains the FIFO_coverage class that collects functional coverage using cross-coverage of wr_en, rd_en, and control signals.

. FIFO_scoreboard_pkg: Implements the FIFO_scoreboard class to check the DUT’s outputs against a reference model and update the correct_count or error_count.

