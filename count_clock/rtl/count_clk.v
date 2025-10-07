module count_clk(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // BCD tang phut, giay (00–59)
    function [7:0] bcd_inc60(input [7:0] val);
        if (val[3:0] == 9) begin
            if (val[7:4] == 5) bcd_inc60 = 8'h00;
            else bcd_inc60 = {val[7:4]+1, 4'h0};
        end else
            bcd_inc60 = val + 1;
    endfunction

    // Ham tang gio (01–12)
    function [7:0] bcd_inc12(input [7:0] val);
        if (val == 8'h12) bcd_inc12 = 8'h01;
        else if (val[3:0] == 9) bcd_inc12 = {val[7:4]+1, 4'h0};
        else bcd_inc12 = val + 1;
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            ss <= 8'h00;
            mm <= 8'h00;
            hh <= 8'h12;
            pm <= 1'b0;
        end else if (ena) begin
            if (ss != 8'h59) begin
                ss <= bcd_inc60(ss);
            end else begin
                ss <= 8'h00;
                if (mm != 8'h59) begin
                    mm <= bcd_inc60(mm);
                end else begin
                    mm <= 8'h00;
                    if (hh == 8'h11) begin
                        hh <= 8'h12;
                        pm <= ~pm;   // Đoi AM/PM
                    end else begin
                        hh <= bcd_inc12(hh);
                    end
                end
            end
        end
    end
endmodule
