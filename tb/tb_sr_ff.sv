`timescale 1ns/1ps
module tb_sr_ff;
    reg clk = 0, s = 0, r = 0;
    wire q;
    sr_ff dut (.clk(clk), .s(s), .r(r), .q(q));
    always #5 clk = ~clk;

    task check(input reg sv, input reg rv, input reg want);
        begin
            @(negedge clk);
            s = sv; r = rv;
            @(posedge clk); #1;
            if (q !== want) $fatal(1, "SR=%b%b expected %b got %b", s,r,want,q);
        end
    endtask
    initial begin
        #1;
        if (q !== 0) $fatal(1, "Incorrect SR initialization");
        check(0,0,0);
        check(1,0,1);
        check(0,0,1);
        check(0,1,0);
        check(1,1,1'bx);
        check(1,0,1);
        check(0,1,0);
        $display("PASS: SR initialization, hold, set, reset, illegal input and recovery");
        $finish;
    end
    initial begin #200; $fatal(1,"Simulation timeout"); end
endmodule
