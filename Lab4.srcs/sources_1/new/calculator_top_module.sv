`timescale 1ns / 1ps


module calculator_top_module(
    input clk, reset,
    input add_btn, sub_btn, mult_btn, enter_btn,
    input[3:0] col,
    input[15:0] switch,
    output reg [3:0] row,
    output reg [6:0] LED_out,
    output reg [3:0] Anode_Activate,
    output reg [4:0] LED
    );
    
//                          INTERAL WIRING
//    Variables to debounce the buttons 
    wire reset_btn_db, enter_btn_db, sub_btn_db, add_btn_db, mult_btn_db, complete_input, stuck_on_input;
//    Single keypad number
    wire[3:0] keypad_num;
//    Arrays to represent input numbers and output number
    wire[15:0] first_num, second_num, output_num; 
//    The buffer which displays the final 16-bit output number (with the extra descriptive word bit).
    reg[16:0] buffer_num;

   
//                          MODULE INSTANTIATION
//    Button Debouncing
    debouncer subtractor_db
        (.clk(clk), .reset(reset_btn_db), .button(sub_btn), .button_db(sub_btn_db));
    debouncer adder_db
        (.clk(clk), .reset(reset_btn_db), .button(add_btn), .button_db(add_btn_db));
    debouncer enter_db
        (.clk(clk), .reset(reset_btn_db), .button(enter_btn), .button_db(enter_btn_db));
    debouncer reset_db
        (.clk(clk), .reset(reset_btn_db), .button(reset), .button_db(reset_btn_db));
    debouncer mult_db
        (.clk(clk), .reset(reset_btn_db), .button(mult_btn), .button_db(mult_btn_db));
        
//    Takes input from the keypad and outputs a single hex number
    keypad_decoder keypad_input
        (.clk(clk), .reset(reset_btn_db), .rows(row), .cols(col), .final_number(keypad_num));
        
    keypad_input_handler keypad_number_creation
        (.clk(clk), .reset(reset_btn_db), .enter_btn(enter_btn_db), .input_number(keypad_num),
        .finished(complete_input), .first_num(first_num), .second_num(second_num),        
        .stuck_on_input(stuck_on_input));      
                                               
//Takes two inputs from switches and outputs them as two arrays
//    input_handler number_in_module
//        (.clk(clk), .reset(reset_btn_db), .enter_btn(enter_btn_db), .input_number(switch), 
//        .finished(complete_input), .first_num(first_num), .second_num(second_num),
//        .stuck_on_input(stuck_on_input));
   
   
//   Does the operations of addition, subtraction, multiplication & xor-ing
    operation_handler operations
        (.clk(clk), .reset(reset_btn_db), .subtract(sub_btn_db), .add(add_btn_db), .multiply(mult_btn_db), 
        .xor_btn(enter_btn_db), .begin_operation(complete_input), .first_input(first_num), .second_input(second_num), 
        .result(output_num), .indicators(LED));


//    Decides what to display on the seven segment display (based on the state from input_state & the buttons being pressed)
    output_handler sseg_output_handler        
        (.clk(clk), .reset(reset_btn_db), .complete_input(complete_input), .enter_btn(enter_btn_db), 
        .first_num(first_num), .second_num(second_num), .op_result(output_num), .result(buffer_num),
        .operation(LED[3:0]), .stuck_on_input(stuck_on_input));
        
        
//    assign buffer_num = {{1'b0}, {4{keypad_num}}};
          
//    Displaying result on 7 segment display
    seven_seg_ctrl sseg_display
        (.clk(clk), .reset(reset_btn_db),.number(buffer_num),.LED_out(LED_out), 
        .Anode_Activate(Anode_Activate));

        
endmodule
