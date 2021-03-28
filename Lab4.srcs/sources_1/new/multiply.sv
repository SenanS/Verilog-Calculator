`timescale 1ns / 1ps

module multiply(
    input               clk, reset, multiply, begin_operation,
    input [15:0]        first_input, second_input,
    output reg [15:0]   result
    );
    
    reg [15:0] result_ff = 0, result_nxt = 0;
    
    assign result = result_ff;
    
    always @(posedge clk or posedge reset) begin
        if(reset)
            result_ff <= 0;
        else
            result_ff <= result_nxt;
    end
    
    
    always @(*) begin
        result_nxt = result_ff;
        if(begin_operation && multiply) begin
            result_nxt = first_input * second_input;
        end 
    end
    
endmodule
