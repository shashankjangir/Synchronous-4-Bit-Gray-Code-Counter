`timescale 1ns/1ps
module tb_gray_counter_4bit;
    reg clk = 0;
    wire [3:0] q;
    reg [3:0] previous, expected, difference;
    integer cycle;
    gray_counter_4bit dut (.clk(clk), .q0(q[0]), .q1(q[1]), .q2(q[2]), .q3(q[3]));
    always #5 clk = ~clk;

    initial begin
        $dumpfile("build/gray_counter.vcd");
        $dumpvars(0, tb_gray_counter_4bit);
        #1;
        if (q !== 4'b0000) $fatal(1, "Incorrect initialization: %b", q);
        previous = q;
        for (cycle = 1; cycle <= 64; cycle = cycle + 1) begin
            // Check inputs before the edge, including state 0000.
            if ((({dut.s3,dut.s2,dut.s1,dut.s0} &
                   {dut.r3,dut.r2,dut.r1,dut.r0})) !== 4'b0000)
                $fatal(1, "Illegal/unknown SR input at state %b", q);
            @(posedge clk);
            #1; // Sample after nonblocking register updates.
            expected = (cycle % 16) ^ ((cycle % 16) >> 1);
            if (q !== expected)
                $fatal(1, "Cycle %0d: expected %b got %b", cycle, expected, q);
            difference = q ^ previous;
            if ((difference !== 4'b0001) && (difference !== 4'b0010) &&
                (difference !== 4'b0100) && (difference !== 4'b1000))
                $fatal(1, "Not a one-bit transition: %b -> %b", previous, q);
            previous = q;
            @(negedge clk);
            #1;
            if (q !== previous) $fatal(1, "Output changed on falling edge");
        end
        $display("PASS: 64 counting transitions, four wraps, legal SR inputs and falling-edge stability");
        $finish;
    end

    // Catch changes anywhere other than the active edge (after startup).
    always @(q) begin
        if ($time > 1 && (($time % 10) != 5))
            $fatal(1, "Output changed between active clock edges");
    end
    initial begin
        #1000;
        $fatal(1, "Simulation timeout");
    end
endmodule
