// cla64_flat.v
// A flat, unblocked 64-bit carry-lookahead adder with explicit delays.

module cla64_flat(
  input  [63:0] a,
  input  [63:0] b,
  input         cin,
  output [63:0] sum,
  output        cout
);

  wire [63:0] p, g;
  wire [64:0] c;   // c[0] is cin, c[1]..c[64] are carries

  assign c[0] = cin;

  // Step 1: generate/propagate signals
  genvar i;
  generate
    for (i = 0; i < 64; i = i + 1) begin : gen_pg
      xor #(2) (p[i], a[i], b[i]);
      and #(2) (g[i], a[i], b[i]);
    end
  endgenerate

  // Step 2: direct carry equations for c[1] through c[64]
  genvar k, j;
  generate
    for (k = 1; k <= 64; k = k + 1) begin : gen_carry
      wire [k:0] terms;
      
      // Base term: g[k-1]
      assign terms[0] = g[k-1];
      
      // Intermediate terms: (p[k-1] & ... & p[j] & g[j-1])
      for (j = 1; j < k; j = j + 1) begin : gen_terms
        assign terms[j] = (&p[k-1:j]) & g[j-1];
      end
      
      // Last term: (p[k-1] & ... & p[0] & cin)
      assign terms[k] = (&p[k-1:0]) & c[0];
      
      // Combine all terms with delay
      assign #(2) c[k] = |terms;
    end
  endgenerate

  assign cout = c[64];

  // Step 3: sum bits
  assign #(2) sum = p ^ c[63:0];

endmodule
