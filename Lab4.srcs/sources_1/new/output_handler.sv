`timescale 1ns / 1ps


module output_handler(
    input               clk, reset,
    input               complete_input, enter_btn,
    input [3:0]         operation,
    input [15:0]        first_num, second_num, op_result,
    output reg [16:0]   result
    );
    
    
    reg next_state = 0;
    
    
    //    Sets output to the appropriate value, depending on the current state (from the input_handler)
    always @(posedge clk) begin 
        if(reset)
            next_state <= 0;            
        if(enter_btn)
            next_state <= 1;

        
        if(operation != 0) begin
            case(operation)
            4'b0001:
                result <= 17'b10000000000000000;
            4'b0010:
                result <= 17'b10000000000000001;
            4'b0100:
                result <= 17'b10000000000000010;
            4'b1000:
                result <= 17'b10000000000000011;
            default:
                result <= 17'b10000000000001111;            
            endcase
        end
        else begin
            if(next_state)
    //            result <= second_num;
                result <= { 1'b0, second_num};
            else
    //            result <= first_num;
                result <= { 1'b0, first_num};
            if(complete_input)
    //            result <= op_result;
                result <= { 1'b0, op_result};
        end
    end
    
    
endmodule
