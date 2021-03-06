`timescale 1ns / 1ps

module operation_handler(
    input               clk, reset,
    input               subtract, add, multiply, xor_btn, begin_operation,
    input [15:0]        first_input, second_input,
    output reg [4:0]    indicators,
    output reg [15:0]   result
    );
//    Flip-Flop and next state update regs
    reg [15:0] result_ff = 0, result_nxt = 0;
    
//    Assigning output value
    assign result = result_ff;
    
//    Reset, update logic & LED output setup
    always @(posedge clk or posedge reset) begin
        if(reset)
            result_ff <= 0;
        else
            result_ff <= result_nxt;
            indicators[0]  <= add; 
            indicators[1]  <= multiply; 
            indicators[2]  <= subtract; 
            indicators[3]  <= xor_btn;
            indicators[4]  <= begin_operation;
    end
    
//   Logic to perform operations on first and second numbers & update output respectively.
//   (logic only updates if the input_handler signals that it's finished).
    always @(*) begin
        result_nxt = result_ff;
        if(begin_operation) begin
            if(subtract)
                result_nxt = first_input - second_input;
            else if(add)
                result_nxt = first_input + second_input;
            else if(multiply)
                result_nxt = first_input * second_input;
            else if(xor_btn)
                result_nxt = first_input ^ second_input;
        end   
    end
endmodule
