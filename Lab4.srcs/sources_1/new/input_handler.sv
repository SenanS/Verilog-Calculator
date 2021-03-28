`timescale 1ns / 1ps

module input_handler(
    input               clk, reset, enter_btn,
    input [15:0]        switch_number,
    output reg          finished,
    output reg [15:0]   first_num, second_num
    );
    
    // Three states exist - 1. enter first num 2. enter second num 3. operation complete
    localparam [1:0]
        state_1 = 2'b00,
        state_2 = 2'b01,
        state_3 = 2'b10,
        state_4 = 2'b11;
    
    reg [15:0] first_ff = 0, second_ff = 0, first_nxt = 0, second_nxt = 0;
    reg [1:0] state_ff = 0, state_nxt = 0; 
    reg finished_ff = 0, finished_nxt = 0;
     
    assign finished = finished_ff;
    assign first_num = first_ff;
    assign second_num = second_ff;
    
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            finished_ff <= 0;
            state_ff <= state_1;
            first_ff <= 0;
            second_ff <= 0;
        end else begin
            state_ff <= state_nxt;
            finished_ff <= finished_nxt;
            first_ff <= first_nxt;
            second_ff <= second_nxt;
        end
    end
    
    always @(*) begin
//    Set the number based on the state        
        state_nxt = state_ff;
        second_nxt = second_ff;
        first_nxt = first_ff;
        case(state_ff)
            state_1: begin
                if(enter_btn)
                    state_nxt = state_2;
                first_nxt = switch_number;
                finished_nxt = 0;
            end
            state_2: begin
                finished_nxt = 0;
                if(first_nxt != 0 && switch_number == 0)
                    state_nxt = state_3;
                else if (first_nxt == 0 && switch_number != 0)
                    state_nxt = state_3;
            end
            state_3: begin
                if(enter_btn) 
                    state_nxt = state_4;
                second_nxt = switch_number;
                finished_nxt = 0;
            end
            state_4: begin
                finished_nxt = 1;
            end
        endcase
    end    
endmodule
