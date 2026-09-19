// cla4.v
// Gate-level 4-bit carry-lookahead adder

module cla4(
  input  [3:0] a,
  input  [3:0] b,
  input        cin,
  output [3:0] sum,
  output       cout
);

  wire p0, p1, p2, p3;
  wire g0, g1, g2, g3;
  wire c1, c2, c3, c4;

  // Step 1: Generate & Propagate signals
  xor #(2) (p0, a[0], b[0]);
  and #(2) (g0, a[0], b[0]);

  xor #(2) (p1, a[1], b[1]);
  and #(2) (g1, a[1], b[1]);

  xor #(2) (p2, a[2], b[2]);
  and #(2) (g2, a[2], b[2]);

  xor #(2) (p3, a[3], b[3]);
  and #(2) (g3, a[3], b[3]);

  // Step 2: Carry equations
  // c1 = g0 + p0.cin
  wire c1_term1;
  and #(2) (c1_term1, p0, cin);
  or  #(2) (c1, g0, c1_term1);

  // c2 = g1 + p1.g0 + p1.p0.cin
  wire c2_term1, c2_term2;
  and #(2) (c2_term1, p1, g0);
  and #(2) (c2_term2, p1, p0, cin);
  or  #(2) (c2, g1, c2_term1, c2_term2);

  // c3 = g2 + p2.g1 + p2.p1.g0 + p2.p1.p0.cin
  wire c3_term1, c3_term2, c3_term3;
  and #(2) (c3_term1, p2, g1);
  and #(2) (c3_term2, p2, p1, g0);
  and #(2) (c3_term3, p2, p1, p0, cin);
  or  #(2) (c3, g2, c3_term1, c3_term2, c3_term3);

  // c4 = g3 + p3.g2 + p3.p2.g1 + p3.p2.p1.g0 + p3.p2.p1.p0.cin
  wire c4_term1, c4_term2, c4_term3, c4_term4;
  and #(2) (c4_term1, p3, g2);
  and #(2) (c4_term2, p3, p2, g1);
  and #(2) (c4_term3, p3, p2, p1, g0);
  and #(2) (c4_term4, p3, p2, p1, p0, cin);
  or  #(2) (c4, g3, c4_term1, c4_term2, c4_term3, c4_term4);

  // Step 3: Sum outputs
  xor #(2) (sum[0], p0, cin);
  xor #(2) (sum[1], p1, c1);
  xor #(2) (sum[2], p2, c2);
  xor #(2) (sum[3], p3, c3);

  assign cout = c4;

endmodule
