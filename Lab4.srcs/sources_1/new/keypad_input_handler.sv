`timescale 1ns / 1ps


module keypad_input_handler(
    input               clk, reset, enter_btn,
    input [3:0]         input_number,
    output reg          finished, stuck_on_input,
    output reg [15:0]   first_num, second_num
    );
    
//   Three main states exist, two with 8 sub states - 
//  Enter first number 
//    1. Enter first hex num 
//    2. Wait for first hex num to be cleared (stop 0,0 edge case)
//    3. Enter second hex num 
//    4. Wait for second hex num to be cleared (stop 0,0 edge case)
//    5. Enter third hex num 
//    6. Wait for third hex num to be cleared (stop 0,0 edge case)
//    7. Enter fourth hex num 
//    8. Go to the next main state, reset sub-state
//  Enter second num 
//    1. Enter first hex num 
//    2. Wait for first hex num to be cleared (stop 0,0 edge case)
//    3. Enter second hex num 
//    4. Wait for second hex num to be cleared (stop 0,0 edge case)
//    5. Enter third hex num 
//    6. Wait for third hex num to be cleared (stop 0,0 edge case)
//    7. Enter fourth hex num 
//    8. Go to the next main state, reset sub-state
//  Operation complete

    localparam [1:0]
        main_state_1 = 2'b00,
        main_state_2 = 2'b01,
        main_state_3 = 2'b10;
    localparam[7:0]
        sub_state_1 = 8'b00000001,
        sub_state_2 = 8'b00000010,
        sub_state_3 = 8'b00000100,
        sub_state_4 = 8'b00001000,
        sub_state_5 = 8'b00010000,
        sub_state_6 = 8'b00100000,
        sub_state_7 = 8'b01000000,
        sub_state_8 = 8'b10000000;
    
//    Declaration of flip flops and next state variables for the state, the completed bit, the first & second inputs
    reg [15:0] first_ff = 0, second_ff = 0, first_nxt = 0, second_nxt = 0;
    reg [1:0] main_state_ff, main_state_nxt; 
    reg [7:0] sub_state_ff = 0, sub_state_nxt = 0;
    reg finished_ff = 0, finished_nxt = 0, stuck_on_ff, stuck_on_nxt;
    
//    Assigning outputs 
    assign stuck_on_input = stuck_on_ff;
    assign finished = finished_ff;
    assign first_num = first_ff;
    assign second_num = second_ff;
    
//    Reset & update logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            finished_ff <= 0;
            main_state_ff <= main_state_1;
            sub_state_ff <= sub_state_1;
            first_ff <= 0;
            second_ff <= 0;
            stuck_on_ff <= 0;
        end else begin
            main_state_ff <= main_state_nxt;
            sub_state_ff <= sub_state_nxt;
            finished_ff <= finished_nxt;
            first_ff <= first_nxt;
            second_ff <= second_nxt;
            stuck_on_ff <= stuck_on_nxt;
        end
    end
    
//    Set the initial values to zero
    initial begin
        main_state_ff <= main_state_1;
        sub_state_ff <= sub_state_1;
        first_ff <= 0;
        second_ff <= 0;
        
    end
    
    always @(*) begin
//    Set the number based on the state        
        main_state_nxt = main_state_ff;
        sub_state_nxt = sub_state_ff;
        second_nxt = second_ff;
        first_nxt = first_ff;
        stuck_on_nxt = stuck_on_ff;
        finished_nxt = finished_ff;
        case(main_state_ff)
            main_state_1: begin
                finished_nxt = 0;
                case(sub_state_ff)
                    sub_state_1: begin
                        if(enter_btn)
                            sub_state_nxt = sub_state_2;
                        first_nxt[3:0] = input_number;
                        finished_nxt = 0;
                        stuck_on_nxt = 0;
                    end
                    sub_state_2: begin
                        stuck_on_nxt = 1;
                        if(first_nxt[3:0] != input_number)
                            stuck_on_nxt = 0;
                            sub_state_nxt = sub_state_3;
                    end
                    sub_state_3: begin
                        if(enter_btn) 
                            sub_state_nxt = sub_state_4;
                        first_nxt[7:4] = input_number;
                    end
                    sub_state_4: begin
                        stuck_on_nxt = 1;
                        if(first_nxt[7:4] != input_number)
                            stuck_on_nxt = 0;
                            sub_state_nxt = sub_state_5;
                    end
                    sub_state_5: begin
                        if(enter_btn) 
                            sub_state_nxt = sub_state_6;
                        first_nxt[11:8] = input_number;
                    end
                    sub_state_6: begin
                        stuck_on_nxt = 1;
                        if(first_nxt[11:8] != input_number)
                            stuck_on_nxt = 0;
                            sub_state_nxt = sub_state_7;
                    end
                    sub_state_7: begin
                        if(enter_btn) 
                            sub_state_nxt = sub_state_8;
                        first_nxt[15:12] = input_number;
                    end
                    sub_state_8: begin
                        main_state_nxt = main_state_2;
                        sub_state_nxt = sub_state_1;
                    end
                endcase
            end
            main_state_2: begin
                finished_nxt = 0;
                case(sub_state_ff)
                    sub_state_1: begin
                        if(enter_btn)
                            sub_state_nxt = sub_state_2;
                        second_nxt[3:0] = input_number;
                        stuck_on_nxt = 0;
                    end
                    sub_state_2: begin
                        stuck_on_nxt = 1;
                        if(second_nxt[3:0] != input_number)
                            stuck_on_nxt = 0;
                            sub_state_nxt = sub_state_3;
                    end
                    sub_state_3: begin
                        if(enter_btn) 
                            sub_state_nxt = sub_state_4;
                        second_nxt[7:4] = input_number;
                    end
                    sub_state_4: begin
                        stuck_on_nxt = 1;
                        if(second_nxt[7:4] != input_number)
                            stuck_on_nxt = 0;
                            sub_state_nxt = sub_state_5;
                    end
                    sub_state_5: begin
                        if(enter_btn) 
                            sub_state_nxt = sub_state_6;
                        second_nxt[11:8] = input_number;
                    end
                    sub_state_6: begin
                        stuck_on_nxt = 1;
                        if(second_nxt[11:8] != input_number)
                            stuck_on_nxt = 0;
                            sub_state_nxt = sub_state_7;
                    end
                    sub_state_7: begin
                        if(enter_btn) 
                            sub_state_nxt = sub_state_8;
                        second_nxt[15:12] = input_number;
                    end
                    sub_state_8: begin
                        main_state_nxt = main_state_3;
                        sub_state_nxt = sub_state_1;
                    end
                endcase
            end
            main_state_3: begin
                finished_nxt = 1;
            end 
            default:
                main_state_nxt = main_state_1;
        
        endcase
    end    
endmodule
