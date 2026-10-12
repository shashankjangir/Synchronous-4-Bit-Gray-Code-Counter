// Parity/toggle implementation reconstructed from the project report.
module gray_counter_4bit (
    input wire clk,
    output wire q0,
    output wire q1,
    output wire q2,
    output wire q3
);
    wire p_even;
    wire f0, f1, f2, f3;
    wire s0, r0, s1, r1, s2, r2, s3, r3;

    assign p_even = ~(q3 ^ q2 ^ q1 ^ q0);
    assign f0 = p_even;
    assign f1 = ~p_even & q0;
    assign f2 = ~p_even & ~q0 & q1;
    assign f3 = ~p_even & ~q0 & ~q1;

    // Toggle a zero by setting it; toggle a one by resetting it.
    assign s0 = f0 & ~q0;
    assign r0 = f0 & q0;
    assign s1 = f1 & ~q1;
    assign r1 = f1 & q1;
    assign s2 = f2 & ~q2;
    assign r2 = f2 & q2;
    assign s3 = f3 & ~q3;
    assign r3 = f3 & q3;

    sr_ff ff0 (.clk(clk), .s(s0), .r(r0), .q(q0));
    sr_ff ff1 (.clk(clk), .s(s1), .r(r1), .q(q1));
    sr_ff ff2 (.clk(clk), .s(s2), .r(r2), .q(q2));
    sr_ff ff3 (.clk(clk), .s(s3), .r(r3), .q(q3));
endmodule
