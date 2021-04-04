`timescale 1ns / 1ps


module keypad_decoder(
    input               clk, reset,
    input[3:0]          cols,
    output reg [3:0]    rows,
    output reg [3:0]    final_number
    );
    
//    Four states in this input handler, reading the first, second, third & fourth row
    localparam [1:0]
        state_1 = 2'b00,
        state_2 = 2'b01,
        state_3 = 2'b10,
        state_4 = 2'b11;
        
    reg [3:0] number_ff = 0, number_nxt = 0, row_ff = 0, row_nxt = 0;
    reg [1:0] state_ff = 0, state_nxt = 0; 
    reg finished_ff = 0, finished_nxt = 0, stuck_on_ff = 0, stuck_on_nxt = 0;
    
//    Assigning outputs 
    assign final_number = number_ff;
    assign rows = row_ff;
    
//    Reset & update logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            number_ff <= 4'b0000;
            state_ff <= state_1;
            row_ff <= 4'b0000;
        end else begin
            number_ff <= number_nxt;
            state_ff <= state_nxt;
            row_ff <= row_nxt;
        end
    end
    
    always @(*) begin
//    Set the number based on the button being pressed       
        number_nxt = number_ff;    
        row_nxt = row_ff;    
        case(state_ff)
//            1. Read first row
            state_1: begin
                state_nxt = state_2;
                row_nxt = 4'b0001;
                if(cols[0] == 0)
                    number_nxt = 4'b0001;
                else if(cols[1] == 0)
                    number_nxt = 4'b0010;
                else if(cols[2] == 0)
                    number_nxt = 4'b0011;
                else if(cols[3] == 0)
                    number_nxt = 4'b1010;
            end
//            2. Read second row
            state_2: begin
                state_nxt = state_3;
                row_nxt = 4'b0010;
                if(cols[0] == 0)
                    number_nxt = 4'b0100;
                else if(cols[1] == 0)
                    number_nxt = 4'b0101;
                else if(cols[2] == 0)
                    number_nxt = 4'b0110;
                else if(cols[3] == 0)
                    number_nxt = 4'b1011;
            end
//            3. Read third row
            state_3: begin
                state_nxt = state_4;
                row_nxt = 4'b0100;
                if(cols[0] == 0)
                    number_nxt = 4'b0111;
                else if(cols[1] == 0)
                    number_nxt = 4'b1000;
                else if(cols[2] == 0)
                    number_nxt = 4'b1001;
                else if(cols[3] == 0)
                    number_nxt = 4'b1100;
            end
//            4. Read fourth row
            state_4: begin
                state_nxt = state_1;
                row_nxt = 4'b1000;
                if(cols[0] == 0)
                    number_nxt = 4'b1111;
                else if(cols[1] == 0)
                    number_nxt = 4'b0000;
                else if(cols[2] == 0)
                    number_nxt = 4'b1110;
                else if(cols[3] == 0)
                    number_nxt = 4'b1101;
            end
        endcase
    end    
endmodule

