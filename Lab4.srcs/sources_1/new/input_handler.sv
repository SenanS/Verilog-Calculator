`timescale 1ns / 1ps

module input_handler(
    input               clk, reset, enter_btn,
    input [15:0]        switch_number,
    output reg          finished, stuck_on_input,
    output reg [15:0]   first_num, second_num
    );
    
//   Three states exist - 
//    1. Enter first num 
//    2. Wait for first number to be cleared (stop 0,0 edge case)
//    3. Enter second num 
//    4. Operation complete
    localparam [1:0]
        state_1 = 2'b00,
        state_2 = 2'b01,
        state_3 = 2'b10,
        state_4 = 2'b11;
    
//    Declaration of flip flops and next state variables for the state, the completed bit, the first & second inputs
    reg [15:0] first_ff = 0, second_ff = 0, first_nxt = 0, second_nxt = 0;
    reg [1:0] state_ff = 0, state_nxt = 0; 
    reg finished_ff = 0, finished_nxt = 0, stuck_on_ff = 0, stuck_on_nxt = 0;
    
//    Assigning outputs 
    assign stuck_on_input = stuck_on_ff;
    assign finished = finished_ff;
    assign first_num = first_ff;
    assign second_num = second_ff;
    
//    Reset & update logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            finished_ff <= 0;
            state_ff <= state_1;
            first_ff <= 0;
            second_ff <= 0;
            stuck_on_ff <= 0;
        end else begin
            state_ff <= state_nxt;
            finished_ff <= finished_nxt;
            first_ff <= first_nxt;
            second_ff <= second_nxt;
            stuck_on_ff <= stuck_on_nxt;
        end
    end
    
    always @(*) begin
//    Set the number based on the state        
        state_nxt = state_ff;
        second_nxt = second_ff;
        first_nxt = first_ff;
        stuck_on_nxt = stuck_on_ff;
        
        case(state_ff)
//            1. Enter first num 
            state_1: begin
                if(enter_btn)
                    state_nxt = state_2;
                first_nxt = switch_number;
                finished_nxt = 0;
                stuck_on_nxt = 0;
            end
//            2. Wait for first number to be cleared
            state_2: begin
                stuck_on_nxt = 1;
                finished_nxt = 0;
                if(first_nxt != switch_number)
                    state_nxt = state_3;
//                else if (first_nxt == 0 && switch_number != 0)
//                    state_nxt = state_3;
            end
//            3. Enter second num 
            state_3: begin
                if(enter_btn) 
                    state_nxt = state_4;
                second_nxt = switch_number;
                finished_nxt = 0;
                stuck_on_nxt = 0;
            end
//            4. Operation complete
            state_4: begin
                finished_nxt = 1;
                stuck_on_nxt = 0;
            end
        endcase
    end    
endmodule
