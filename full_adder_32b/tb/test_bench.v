`timescale 1ns/1ps

module test_bench();
    reg [31:0]a;
    reg [31:0]b;

    wire [31:0]sum;
    reg [31:0]new_sum; // expected sum 
    
    integer cntf = 0; // dem so test case failed

    top dut (.*);

    initial begin
        a= 0;
        b=0;
        #10;

        repeat(20) begin 
            #10;
            a= $random;
            b= $random;
            new_sum = a +b; 
            #1;
            if (new_sum == sum)begin 
                    $display("------------------------------Testcase Passed-------------------------------");
                    $display("a = %h, b= %h, sum = %h, new_sum = %h", a, b, sum, new_sum);
                    $display("----------------------------------------------------------------------------");
            end else begin 
                    $display("------------------------------Testcase Failed-------------------------------");
                    $display("a = %h, b= %h, sum = %h, new_sum = %h,", a, b, sum, new_sum);
                    $display("----------------------------------------------------------------------------");
                    cntf = cntf +1;
            end
	    end

        $display("----------------------------------------------------------------------------");
        $display("So testcase failed : %d", cntf);
        #50;
        $finish;
    end    

endmodule
