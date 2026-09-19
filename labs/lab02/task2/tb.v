// tb.v
// Starter testbench for lut.v

`timescale 1ns/1ps

module tb;

  // Parameters matching the DUT
  localparam WIDTH = 8;
  localparam DEPTH = 4;

  // Inputs & Outputs
  reg  [$clog2(DEPTH)-1:0] t_sel;
  wire [WIDTH-1:0]         t_dout;

  integer i;

  // Instantiate DUT
  lut #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
  ) DUT (
    .sel  (t_sel),
    .dout (t_dout)
  );

  // Waveform dump configuration (DO NOT CHANGE)
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  // Apply inputs across all address combinations
  initial begin
    t_sel = 0;
    
    // Cycle through all addresses in the LUT
    for (i = 0; i < DEPTH; i = i + 1) begin
      t_sel = i;
      #5;
    end

    #10;
    $finish;
  end

  // Monitor output changes
  initial begin
    $monitor($time, " sel=%0d (%b) | dout=%0d (%h)", t_sel, t_sel, t_dout, t_dout);
  end

endmodule