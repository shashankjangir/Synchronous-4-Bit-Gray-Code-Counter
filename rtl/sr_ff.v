// Reconstructed from the original lab report. No explicit reset input.
module sr_ff (
    input wire clk,
    input wire s,
    input wire r,
    output reg q
);
    // Matches the report. Hardware power-up support is device dependent.
    initial q = 1'b0;

    always @(posedge clk) begin
        case ({s, r})
            2'b00: q <= q;
            2'b01: q <= 1'b0;
            2'b10: q <= 1'b1;
            2'b11: q <= 1'bx; // Simulation indication, not a physical X voltage.
            default: q <= 1'bx;
        endcase
    end
endmodule
