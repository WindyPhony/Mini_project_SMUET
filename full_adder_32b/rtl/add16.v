module add16 (
    input [15:0] a,
    input [15:0] b,
    input cin,
    output [15:0] sum,
    output cout
);
    wire [15:0] c;
    add1 a0 (a[0], b[0], cin, sum[0], c[0]);
    genvar i;
    generate
        for (i = 1; i < 16; i = i + 1) begin : adder_loop
            add1 ai (a[i], b[i], c[i-1], sum[i], c[i]);
        end
    endgenerate
    assign cout = c[15];
endmodule
