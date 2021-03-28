`timescale 1ns / 1ps


module output_handler(
    input               clk, reset,
    input               subtract, add, multiply, complete_input, enter_btn,
    input [15:0]        first_num, second_num, op_result,
    output reg [15:0]   result
    );
    
    
    reg next_state = 0;
    
    
    //    Sets output to the appropriate value, depending on the current state (from the input_handler)
    always @(posedge clk) begin 
        if(reset)
            next_state <= 0;            
        if(enter_btn)
            next_state <= 1;
        if(next_state)
            result <= second_num;
        else
            result <= first_num;
        if(complete_input)
            result <= op_result;
    end
    
    
endmodule
