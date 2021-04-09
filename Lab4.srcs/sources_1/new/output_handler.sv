`timescale 1ns / 1ps


module output_handler(
    input               clk, reset,
    input               complete_input, enter_btn, stuck_on_input, second_num_bool,
    input [3:0]         operation,
    input [15:0]        first_num, second_num, op_result,
    output reg [16:0]   result
    );
    
    // Keeps track of showing first or second number
    reg next_state = 0;
    
    localparam [16:0]
//    Declaration of descriptive words to be displayed on sseg display
//    (descriptive words bit = MSB = result[16] = HIGH, when you want to output a descriptive word)
        add =       17'b10010010101011100,
        sub =       17'b10001100000111100,
        mul =       17'b10110100110101011,
        exor =      17'b11001010000000111,
        done =      17'b10101000011010110,
        Chng =      17'b10100111011011111,
        unknown =   17'b11100110011001100;
        
// 4'b0000: "0"          
// 4'b0001: "5"          
// 4'b0010: "A"          
// 4'b0011: "b"          
// 4'b0100: "C"          
// 4'b0101: "d"          
// 4'b0110: "E"          
// 4'b0111: "r"          
// 4'b1000: "U"          
// 4'b1001: "U" rotated  
// 4'b1010: "L" rotated 
// 4'b1011: "T" rotated  
// 4'b1100: Nothing    
// 4'b1101: = "n"
// 4'b1110: = "h"
// 4'b1111: = "g"

   
//    Sets output to the appropriate value, depending on the current state (from the input_handler)
    always @(posedge clk) begin 
//        Reset state to show the first number
        if(reset)
            next_state <= 0;            
        if(second_num_bool)
            next_state <= 1;

//       Show the description of the operation IF there's an operation in progress
        if(!stuck_on_input) begin
            if(operation != 0) begin
                case(operation)
                    4'b0001:
                        result <= add;
                    4'b0010:
                        result <= mul;
                    4'b0100:
                        result <= sub;
                    4'b1000:
    //                    If the user isn't done entering input, then show "d0nE"
                        if(complete_input)
//                        if(!complete_input)
//                            result <= done;
//                        else
                            result <= exor;
                    default:
                        result <= unknown;            
                endcase
            end
//        Else show them the input numbers or final output
            else begin
    //            If the user hasn't completed input, then show them the input numbers.
                if(!complete_input)
                    if(!next_state)
    //                    Show the user the first input number
                        result <= { 1'b0, first_num};
                    else
    //                    Show the user the second input number
                        result <= { 1'b0, second_num};
                else
    //                Show the user the operated on result.
                    result <= { 1'b0, op_result};
            end
        end    
//        else
//                result <= Chng;   
    end
    
    
endmodule
