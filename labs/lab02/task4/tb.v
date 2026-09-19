`timescale 1ns/1ps

// ==========================================
// 1. Dataflow Implementation
// ==========================================
module and_df (
  input  a,
  input  b,
  output y
);
  assign #5 y = a & b;
endmodule

// ==========================================
// 2. Behavioral (Delay Before Evaluation)
// ==========================================
module and_beh_before (
  input      a,
  input      b,
  output reg y
);
  always @(a or b) begin
    #5 y = a & b;
  end
endmodule

// ==========================================
// 3. Behavioral (Intra-Assignment Delay)
// ==========================================
module and_beh_intra (
  input      a,
  input      b,
  output reg y
);
  always @(a or b) begin
    y = #5 (a & b);
  end
endmodule

// ==========================================
// 4. Testbench Module
// ==========================================
module tb;

  reg  t_a, t_b;
  wire y_df, y_before, y_intra;

  and_df         U_DF     (.a(t_a), .b(t_b), .y(y_df));
  and_beh_before U_BEFORE (.a(t_a), .b(t_b), .y(y_before));
  and_beh_intra  U_INTRA  (.a(t_a), .b(t_b), .y(y_intra));

  // Waveform dump configuration
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, tb);
    end
  end

  initial begin
    t_a = 0; t_b = 0;
    #2 t_a = 1; t_b = 0;
    #2 t_a = 1; t_b = 1;
    #2 t_a = 0; t_b = 1;
    #2 t_a = 1; t_b = 1;
    #2 t_a = 0; t_b = 0;
    #2 t_a = 1; t_b = 1;
    #2 t_a = 0; t_b = 0;
    #10 $finish;
  end

  initial
    $monitor($time, " a=%b b=%b | df=%b  before=%b  intra=%b",
             t_a, t_b, y_df, y_before, y_intra);

endmodule