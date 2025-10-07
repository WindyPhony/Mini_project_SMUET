module top (
    input wire [31:0] a,
    input wire [31:0] b,
    output wire [31:0] sum
);
    wire c;
     add16 add16_0 (
        .a(a[15:0]),
        .b(b[15:0]),
        .cin(1'b0),
        .sum(sum[15:0]),
        .cout(c)
    );
     add16 add16_1 (
        .a(a[31:16]),
        .b(b[31:16]),
        .cin(c),
        .sum(sum[31:16]),
        .cout()
    );  
    
endmodule
