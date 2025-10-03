`timescale 1ns/1ps

module full_adder_tb();
    reg a;
    reg b;

    wire sum;
    reg new_sum; // expected sum 
    
    reg cntf = 0; // dem so test case failed

    top dut (.*);

    initial begin
        repeat(1000 ) begin 
            stimulus();
            #10;
            if (new_sum == sum)begin 
                    $display("------------------------------Testcase Passed-------------------------------");
                    $display("a = %b, b= %b, sum = %b, new_sum = %b", a, b, sum, new_sum);
                    $display("----------------------------------------------------------------------------");
            end else begin 
                    $display("------------------------------Testcase Failed-------------------------------");
                    $display("a = %b, b= %b, sum = %b, new_sum = %b,", a, b, sum, new_sum);
                    $display("----------------------------------------------------------------------------");
                    cntf = cntf +1;
            end

	    end

        $display("----------------------------------------------------------------------------");
        $display("So testcase failed : %d", cntf);
    end    

    task stimulus();
        reg A, B;
        begin 
            A   = $random;
            B   = $random;
            a   =   A;
            b   =   B;


            new_sum = A + B;
        end
    endtask
endmodule
