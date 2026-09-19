`timescale 1ns/1ps

module tb;

  reg  [1:0] t_a, t_b;
  wire       t_gt, t_lt, t_eq;

  integer i, j;

  // Instantiate DUT
  comp2 DUT (
    .A  (t_a),
    .B  (t_b),
    .GT (t_gt),
    .LT (t_lt),
    .EQ (t_eq)
  );

  initial begin
    // Loop through all 16 input combinations (4x4)
    for (i = 0; i < 4; i = i + 1) begin
      for (j = 0; j < 4; j = j + 1) begin
        t_a = i;
        t_b = j;
        #5;

        // One-hot assertion check: exactly one output must be active
        if ((t_gt + t_lt + t_eq) != 1) begin
          $display("ERROR at time %0t: Invalid output state for A=%d, B=%d | GT=%b, LT=%b, EQ=%b",
                   $time, t_a, t_b, t_gt, t_lt, t_eq);
        end

        // Specific expected value checks
        if (t_a > t_b && !t_gt) $display("FAIL: Expected GT=1 for A=%d, B=%d", t_a, t_b);
        if (t_a < t_b && !t_lt) $display("FAIL: Expected LT=1 for A=%d, B=%d", t_a, t_b);
        if (t_a == t_b && !t_eq) $display("FAIL: Expected EQ=1 for A=%d, B=%d", t_a, t_b);
      end
    end

    $display("Testbench complete.");
    $finish;
  end

endmodule