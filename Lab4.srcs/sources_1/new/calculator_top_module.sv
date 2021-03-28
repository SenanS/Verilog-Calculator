`timescale 1ns / 1ps


module calculator_top_module(
    input clk, reset,
    input[15:0] sw,
    input add_btn, sub_btn, mult_btn, enter_btn,
    output reg [6:0] LED_out,
    output reg [3:0] Anode_Activate,
    output reg [3:0] LED
   
    );
    
//    Internal wiring 
    wire reset_btn_db, enter_btn_db, sub_btn_db, add_btn_db, mult_btn_db, complete_input;
    wire[1:0] db_btns;
    wire[15:0] first_num, second_num;
    wire[15:0] output_num; 
    reg[15:0] buffer_num;

   
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
        
        
//    Takes two inputs from switches as different variables
    input_handler number_in_module
        (.clk(clk), .reset(reset_btn_db), .enter_btn(enter_btn_db), .switch_number(sw), 
        .finished(complete_input), .first_num(first_num), .second_num(second_num));
   
   
//   Does addition, subtraction & multiplication
    operation_handler operations
        (.clk(clk), .reset(reset_btn_db), .subtract(sub_btn_db), .add(add_btn_db), .multiply(mult_btn_db), 
        .xor_btn(enter_btn_db), .begin_operation(complete_input), .first_input(first_num),.second_input(second_num), 
        .result(output_num), .indicators(LED));

//    Decideds what to display on the seven segment display (based on the state from input_state)
    output_handler sseg_setter        
        (.clk(clk), .reset(reset_btn_db), .complete_input(complete_input), .enter_btn(enter_btn_db), 
        .first_num(first_num), .second_num(second_num), .op_result(output_num), .result(buffer_num));

      
//    Displaying result
    seven_seg_ctrl sseg_display
        (.clk(clk), .reset(reset_btn_db),.number(buffer_num),.LED_out(LED_out), 
        .Anode_Activate(Anode_Activate));

        
endmodule
