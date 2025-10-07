`timescale 1ns/1ps

module test_bench();
    // Clock and control signals
    reg clk = 0;
    reg reset = 0;
    reg ena = 0;

    // DUT outputs
    wire pm;
    wire [7:0] hh;
    wire [7:0] mm;
    wire [7:0] ss;
    // expected output (model)
    reg       exp_pm = 1'b0;
    reg [7:0] exp_hh = 8'h12;
    reg [7:0] exp_mm = 8'h00;
    reg [7:0] exp_ss = 8'h00;
    
    count_clk uut (
        .clk(clk),
        .reset(reset),
        .ena(ena),
        .pm(pm),
        .hh(hh),
        .mm(mm),
        .ss(ss)
    );

    // -------------GOLDEN RATE --------------//
    function [7:0] bcd_inc60(input [7:0] val);
       if (val[3:0] == 9) begin
            if (val[7:4] == 5) bcd_inc60 = 8'h00;
            else bcd_inc60 = {val[7:4]+1, 4'h0};
        end else
            bcd_inc60 = val + 1;
    endfunction

    task update_model();
        begin
            if (reset) begin 
                exp_ss = 8'h00;
                exp_mm = 8'h00;
                exp_hh = 8'h12;
                exp_pm = 1'b0;
            end else if (ena) begin
                exp_ss = bcd_inc60(exp_ss);
                if (exp_ss == 8'h00) begin
                    exp_mm = bcd_inc60(exp_mm);
                    if (exp_mm == 8'h00) begin
                        if (exp_hh == 8'h11) begin
                            exp_hh = 8'h12;
                            exp_pm = ~exp_pm;
                        end else begin
                            exp_hh = bcd_inc60(exp_hh);
                        end
                    end
                end
            end
        end
    endtask

    initial begin 
        clk = 0;
        forever begin
            #25 clk = ~clk;
        end
    end

    integer i;
    integer cntf =0;


    initial begin
        reset = 1;
        ena = 1;
        #50; 

        $display("==============================================================================");
        $display("=============================Directed check===================================");
        $display("==============================================================================");
        if ( {pm,hh,mm,ss} !== {1'b0,8'h12,8'h00,8'h00} )begin
            $display ("----------------Testcase fail----------------");
            $display ("t=%0t: ACT = %h,%h,%h,%h  || EXP = 0,12,00,00",$time, pm, hh, mm, ss);        
            $display ("---------------------------------------------");
            cntf = cntf + 1;
        end else begin 
            $display ("----------------Testcase PASSED---------------");        
            $display("t=%0t: ACT = %h,%h,%h,%h  || EXP = 0,12,00,00",$time, pm, hh, mm, ss );
            $display ("--------------------------------------------");       
        end

        @ (posedge clk );
        reset =0;
        // check ss ( giay )
        repeat(10)begin 
            @ (posedge clk);
        end
        #1;
        if ( {pm,hh,mm,ss} !== {1'b0,8'h12,8'h00,8'h10} )begin
            $display ("----------------Testcase fail----------------");
            $display ("t=%0t: ACT = %h,%h,%h,%h  || EXP = 0,00,00,10",$time, pm, hh, mm, ss);        
            $display ("---------------------------------------------"); 
            cntf = cntf +1;
        end else begin 
            $display ("----------------Testcase PASSED---------------");        
            $display("t=%0t: ACT = %h,%h,%h,%h  || EXP = 0,00,00,10",$time, pm, hh, mm, ss );
            $display ("--------------------------------------------");       
        end
        // check pp ( phut )
        repeat(50)begin 
            @ (posedge clk);
        end
        #1;
        if ( {pm,hh,mm,ss} !== {1'b0,8'h12,8'h01,8'h00} )begin
            $display ("----------------Testcase fail----------------");
            $display ("t=%0t: ACT = %h,%h,%h,%h  || EXP = 0,00,01,00",$time, pm, hh, mm, ss);        
            $display ("---------------------------------------------");
            cntf = cntf +1;
        end else begin 
            $display ("----------------Testcase PASSED---------------");        
            $display("t=%0t: ACT = %h,%h,%h,%h  || EXP = 0,00,01,00",$time, pm, hh, mm, ss );
            $display ("--------------------------------------------");       
        end

        // check pp ( gio )
        repeat(3540)begin 
            @ (posedge clk);
        end
        #1;
        if ( {pm,hh,mm,ss} !== {1'b0,8'h01,8'h00,8'h00} )begin
            $display ("----------------Testcase fail------------------");
            $display ("t=%0t: ACT = %h,%h,%h,%h  || EXP = 0,01,00,00",$time, pm, hh, mm, ss);        
            $display ("-----------------------------------------------");
            cntf = cntf +1;
        end else begin 
            $display ("----------------Testcase PASSED------------------");        
            $display("t=%0t: ACT = %h,%h,%h,%h  || EXP = 0,01,00,00",$time, pm, hh, mm, ss );
            $display ("-----------------------------------------------");       
        end


        
        $display("====================================================================");
        $display("========================== Random check ============================");
        $display("====================================================================");

        // Reset ban dau
        @(posedge clk);
        reset = 1; ena = 0;
        @(posedge clk) reset = 0; ena = 1;
        // Test trong nhieu chu ky
        for (i = 0; i < 500; i = i + 1) begin
            @(posedge clk);
            // advance the model in lock-step with the DUT
            update_model();
            #1;
            if ({pm,hh,mm,ss} !== {exp_pm,exp_hh,exp_mm,exp_ss}) begin
                $display ("----------------------Testcase fail------------------------");
                $display("t=%0t: ACT = %h,%h,%h,%h  || EXP = %h,%h,%h,%h",$time, pm, hh, mm, ss, exp_pm, exp_hh, exp_mm, exp_ss);
                $display ("-----------------------------------------------------------");       
                cntf= cntf + 1;
            end else begin 
                $display ("----------------------Testcase PASSED------------------------");
                $display("t=%0t: ACT = %h,%h,%h,%h  || EXP = %h,%h,%h,%h",$time, pm, hh, mm, ss, exp_pm, exp_hh, exp_mm, exp_ss);
                $display ("-----------------------------------------------------------");       
            end 
        end

        $display("====================================================================");
        $display("======================= ROLL-OVER CHECK ============================");
        $display("====================================================================");
        
        // Reset ban dau
        @(posedge clk);
        reset = 1; ena = 0;
        @(posedge clk) reset = 0 ; ena =1; 
        // check chuyen tu 11:59:59 AM → 12:00:00 PM 
        repeat(43199) begin
            @(posedge clk);
        end
        #1;
        if ( {pm,hh,mm,ss} !== {1'b0,8'h11,8'h59,8'h59} )begin
            $display ("----------------Testcase fail------------------");
            $display ("t=%0t: ACT = %h,%h,%h,%h  || EXP = 0,11,59,59",$time, pm, hh, mm, ss);        
            $display ("-----------------------------------------------");
            cntf = cntf +1;
        end else begin 
            $display ("----------------Testcase PASSED------------------");        
            $display("t=%0t: ACT = %h,%h,%h,%h  || EXP = 0,11,59,59",$time, pm, hh, mm, ss );
            $display ("-----------------------------------------------");       
        end
        @(posedge clk);
        #1;
        if ( {pm,hh,mm,ss} !== {1'b1,8'h12,8'h00,8'h00} )begin
            $display ("----------------Testcase fail------------------");
            $display ("t=%0t: ACT = %h,%h,%h,%h  || EXP = 1,12,00,00",$time, pm, hh, mm, ss);        
            $display ("-----------------------------------------------");
            cntf = cntf +1;
        end else begin 
            $display ("----------------Testcase PASSED------------------");        
            $display("t=%0t: ACT = %h,%h,%h,%h  || EXP = 1,12,00,00",$time, pm, hh, mm, ss );
            $display ("-----------------------------------------------");       
        end

        // check chuyen tu 12:59:59 PM → 01:00:00 PM. 

        repeat(3599) begin
            @(posedge clk);
        end
        #1;
        if ( {pm,hh,mm,ss} !== {1'b1,8'h12,8'h59,8'h59} )begin
            $display ("----------------Testcase fail------------------");
            $display ("t=%0t: ACT = %h,%h,%h,%h  || EXP = 1,12,59,59",$time, pm, hh, mm, ss);        
            $display ("-----------------------------------------------");
            cntf = cntf +1;
        end else begin 
            $display ("----------------Testcase PASSED------------------");        
            $display("t=%0t: ACT = %h,%h,%h,%h  || EXP = 1,12,59,59",$time, pm, hh, mm, ss );
            $display ("-----------------------------------------------");       
        end
        @(posedge clk);
        #1;
        if ( {pm,hh,mm,ss} !== {1'b1,8'h01,8'h00,8'h00} )begin
            $display ("----------------Testcase fail------------------");
            $display ("t=%0t: ACT = %h,%h,%h,%h  || EXP = 1,01,00,00",$time, pm, hh, mm, ss);        
            $display ("-----------------------------------------------");
            cntf = cntf +1;
        end else begin 
            $display ("----------------Testcase PASSED------------------");        
            $display("t=%0t: ACT = %h,%h,%h,%h  || EXP = 1,01,00,00",$time, pm, hh, mm, ss );
            $display ("-----------------------------------------------");       
        end

        // check chuyen tu 11:59:59 PM → 12:00:00 AM. 

        repeat(39599) begin
            @(posedge clk);
        end
        #1;
        if ( {pm,hh,mm,ss} !== {1'b1,8'h11,8'h59,8'h59} )begin
            $display ("----------------Testcase fail------------------");
            $display ("t=%0t: ACT = %h,%h,%h,%h  || EXP = 1,11,59,59",$time, pm, hh, mm, ss);        
            $display ("-----------------------------------------------");
            cntf = cntf +1;
        end else begin 
            $display ("----------------Testcase PASSED------------------");        
            $display("t=%0t: ACT = %h,%h,%h,%h  || EXP = 1,11,59,59",$time, pm, hh, mm, ss );
            $display ("-----------------------------------------------");       
        end
        @(posedge clk);
        #1;
        if ( {pm,hh,mm,ss} !== {1'b0,8'h12,8'h00,8'h00} )begin
            $display ("----------------Testcase fail------------------");
            $display ("t=%0t: ACT = %h,%h,%h,%h  || EXP = 0,12,00,00",$time, pm, hh, mm, ss);        
            $display ("-----------------------------------------------");
            cntf = cntf +1;
        end else begin 
            $display ("----------------Testcase PASSED------------------");        
            $display("t=%0t: ACT = %h,%h,%h,%h  || EXP = 0,12,00,00",$time, pm, hh, mm, ss );
            $display ("-----------------------------------------------");       
        end
        $display("-------------------------------------------");
        $display ("So test fail: %d", cntf);

        $finish;
    end

endmodule
