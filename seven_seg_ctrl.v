`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.12.2018 22:28:19
// Design Name: 
// Module Name: seven_seg_ctrl
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// Source:
//  https://www.fpga4student.com/2017/09/seven-segment-led-display-controller-basys3-fpga.html
//////////////////////////////////////////////////////////////////////////////////


module seven_seg_ctrl(
    input            clk,
    input            reset,
    input     [15:0] number,
    output reg [6:0] LED_out,
    output reg [3:0] Anode_Activate
    );
    
    
    // Constants
    
    // Local Variables
    // Digit selection
    reg [19:0] refresh_counter;
    wire [1:0] LED_activating_counter; 
    reg [15:0] LED_BCD;
    
    // Continuous Assignments
    assign LED_activating_counter = refresh_counter[19:18];

    // Combinational logic
    // Digit Selection
        // anode activating signals for 4 LEDs
    // decoder to generate anode signals 
    always @(*) begin
        case(LED_activating_counter)
        2'b00: begin
            Anode_Activate = 4'b1110; 
            // activate LED1 and Deactivate LED2, LED3, LED4
            LED_BCD = number[3:0];
            // the first hex-digit of the 16-bit number
             end
        2'b01: begin
            Anode_Activate = 4'b1101; 
            // activate LED2 and Deactivate LED1, LED3, LED4
            LED_BCD = number[7:4];
            // the second hex-digit of the 16-bit number
                end
        2'b10: begin
            Anode_Activate = 4'b1011; 
            // activate LED3 and Deactivate LED2, LED1, LED4
            LED_BCD = number[11:8];
             // the third hex-digit of the 16-bit number
              end
        2'b11: begin
            Anode_Activate = 4'b0111; 
            // activate LED4 and Deactivate LED2, LED3, LED1
             LED_BCD = number[15:12];
             // the fourth hex-digit of the 16-bit number 
               end   
        default:begin
             Anode_Activate = 4'b0111; 
            // activate LED1 and Deactivate LED2, LED3, LED4
            LED_BCD = number[3:0];
            // the first hex-digit of the 16-bit number
            end
        endcase
    end
    
    // BCD to 7seg;
    // Cathode patterns of the 7-segment LED display 
    always @(*) begin
        case(LED_BCD)
            4'b0000: LED_out = 7'b0000001; // "0"  
            4'b0001: LED_out = 7'b1001111; // "1" 
            4'b0010: LED_out = 7'b0010010; // "2" 
            4'b0011: LED_out = 7'b0000110; // "3" 
            4'b0100: LED_out = 7'b1001100; // "4" 
            4'b0101: LED_out = 7'b0100100; // "5" 
            4'b0110: LED_out = 7'b0100000; // "6" 
            4'b0111: LED_out = 7'b0001111; // "7" 
            4'b1000: LED_out = 7'b0000000; // "8"  
            4'b1001: LED_out = 7'b0000100; // "9" 
            4'b1010: LED_out = ~7'b1110111; // "A"
            4'b1011: LED_out = ~7'b0011111; // "b"
            4'b1100: LED_out = ~7'b1001110; // "C"
            4'b1101: LED_out = ~7'b0111101; // "d"
            4'b1110: LED_out = ~7'b1001111; // "E"
            4'b1111: LED_out = ~7'b1000111; // "F"
            default: LED_out = ~7'b0000001; // "0"
     endcase
    end
    // Synchronous Logic
    // Digit Selection
    always @(posedge clk, posedge reset) begin 
        if(reset==1) refresh_counter <= 0;
        else refresh_counter <= refresh_counter + 1;
    end 
endmodule
