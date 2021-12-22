module datapath (
    line_data_in,weight_data_in,
    clock,reset,
    data_out,x_dim_zero_flag,x_dim_sec_flag,stopper,
    //control
    data_or_dim,x_or_y,weight_data_sel,y_sel,sel,flush
);
    input[15:0] line_data_in,weight_data_in;
    input clock,reset;
    output[15:0] data_out;
    output x_dim_zero_flag;
    output x_dim_sec_flag;
    output stopper;

     //wires
    reg[15:0] IR_in;
    reg[4:0] SRAM_in,x_line,y_line;
    reg[15:0] weight_data_line;
    reg[15:0] data_temp;
    reg[15:0] Carry_A;
    reg[47:0] A_reg_added_val;
    reg[15:0] data_temp_padded;

    //temporary storage
    reg[15:0] weight_data;
    reg[4:0] x_dim,y_dim;
    reg[15:0] A_reg,B_reg,C_reg;


    //control signals
    input data_or_dim,x_or_y,weight_data_sel,y_sel;
    input flush;
    input[1:0] sel;

    //output
    reg[15:0] data_out;
    reg x_dim_zero_flag;
    reg x_dim_sec_flag;
    reg stopper;


    //Module instantiation
    //A LUT1 implementation
    wire[47:0] A_reg_temp;
    reg[2:0] temp_a_0,temp_a_1,temp_a_2,temp_a_3,temp_a_4,temp_a_5,temp_a_6,temp_a_7,temp_a_8,temp_a_9,temp_a_10,temp_a_11,temp_a_12,temp_a_13,temp_a_14,temp_a_15,temp_a_16;
    LUT1 l1(A_reg_temp[2:0],temp_a_0[0],temp_a_0[1],temp_a_0[2]);
    LUT1 l2(A_reg_temp[5:3],temp_a_1[0],temp_a_1[1],temp_a_1[2]);
    LUT1 l3(A_reg_temp[8:6],temp_a_2[0],temp_a_2[1],temp_a_2[2]);
    LUT1 l4(A_reg_temp[11:9],temp_a_3[0],temp_a_3[1],temp_a_3[2]);
    LUT1 l5(A_reg_temp[14:12],temp_a_4[0],temp_a_4[1],temp_a_4[2]);
    LUT1 l6(A_reg_temp[17:15],temp_a_5[0],temp_a_5[1],temp_a_5[2]);
    LUT1 l7(A_reg_temp[20:18],temp_a_6[0],temp_a_6[1],temp_a_6[2]);
    LUT1 l8(A_reg_temp[23:21],temp_a_7[0],temp_a_7[1],temp_a_7[2]);
    LUT1 l9(A_reg_temp[26:24],temp_a_8[0],temp_a_8[1],temp_a_8[2]);
    LUT1 l10(A_reg_temp[29:27],temp_a_9[0],temp_a_9[1],temp_a_9[2]);
    LUT1 l11(A_reg_temp[32:30],temp_a_10[0],temp_a_10[1],temp_a_10[2]);
    LUT1 l12(A_reg_temp[35:33],temp_a_11[0],temp_a_11[1],temp_a_11[2]);
    LUT1 l13(A_reg_temp[38:36],temp_a_12[0],temp_a_12[1],temp_a_12[2]);
    LUT1 l14(A_reg_temp[41:39],temp_a_13[0],temp_a_13[1],temp_a_13[2]);
    assign A_reg_temp[47:42] = 6'b000000;


    //B LUT1 implementation
    wire[47:0] B_reg_temp;
    reg[2:0] temp_b_0,temp_b_1,temp_b_2,temp_b_3,temp_b_4,temp_b_5,temp_b_6,temp_b_7,temp_b_8,temp_b_9,temp_b_10,temp_b_11,temp_b_12,temp_b_13,temp_b_14,temp_b_15,temp_b_16;
    LUT1 g1(B_reg_temp[2:0],temp_b_0[0],temp_b_0[1],temp_b_0[2]);
    LUT1 g2(B_reg_temp[5:3],temp_b_1[0],temp_b_1[1],temp_b_1[2]);
    LUT1 g3(B_reg_temp[8:6],temp_b_2[0],temp_b_2[1],temp_b_2[2]);
    LUT1 g4(B_reg_temp[11:9],temp_b_3[0],temp_b_3[1],temp_b_3[2]);
    LUT1 g5(B_reg_temp[14:12],temp_b_4[0],temp_b_4[1],temp_b_4[2]);
    LUT1 g6(B_reg_temp[17:15],temp_b_5[0],temp_b_5[1],temp_b_5[2]);
    LUT1 g7(B_reg_temp[20:18],temp_b_6[0],temp_b_6[1],temp_b_6[2]);
    LUT1 g8(B_reg_temp[23:21],temp_b_7[0],temp_b_7[1],temp_b_7[2]);
    LUT1 g9(B_reg_temp[26:24],temp_b_8[0],temp_b_8[1],temp_b_8[2]);
    LUT1 g10(B_reg_temp[29:27],temp_b_9[0],temp_b_9[1],temp_b_9[2]);
    LUT1 g11(B_reg_temp[32:30],temp_b_10[0],temp_b_10[1],temp_b_10[2]);
    LUT1 g12(B_reg_temp[35:33],temp_b_11[0],temp_b_11[1],temp_b_11[2]);
    LUT1 g13(B_reg_temp[38:36],temp_b_12[0],temp_b_12[1],temp_b_12[2]);
    LUT1 g14(B_reg_temp[41:39],temp_b_13[0],temp_b_13[1],temp_b_13[2]);
    assign B_reg_temp[47:42] = 6'b000000;

    //C LUT1 implementction
    wire[47:0] C_reg_temp;
    reg[2:0] temp_c_0,temp_c_1,temp_c_2,temp_c_3,temp_c_4,temp_c_5,temp_c_6,temp_c_7,temp_c_8,temp_c_9,temp_c_10,temp_c_11,temp_c_12,temp_c_13,temp_c_14,temp_c_15,temp_c_16;
    LUT1 p1(C_reg_temp[2:0],temp_c_0[0],temp_c_0[1],temp_c_0[2]);
    LUT1 p2(C_reg_temp[5:3],temp_c_1[0],temp_c_1[1],temp_c_1[2]);
    LUT1 p3(C_reg_temp[8:6],temp_c_2[0],temp_c_2[1],temp_c_2[2]);
    LUT1 p4(C_reg_temp[11:9],temp_c_3[0],temp_c_3[1],temp_c_3[2]);
    LUT1 p5(C_reg_temp[14:12],temp_c_4[0],temp_c_4[1],temp_c_4[2]);
    LUT1 p6(C_reg_temp[17:15],temp_c_5[0],temp_c_5[1],temp_c_5[2]);
    LUT1 p7(C_reg_temp[20:18],temp_c_6[0],temp_c_6[1],temp_c_6[2]);
    LUT1 p8(C_reg_temp[23:21],temp_c_7[0],temp_c_7[1],temp_c_7[2]);
    LUT1 p9(C_reg_temp[26:24],temp_c_8[0],temp_c_8[1],temp_c_8[2]);
    LUT1 p10(C_reg_temp[29:27],temp_c_9[0],temp_c_9[1],temp_c_9[2]);
    LUT1 p11(C_reg_temp[32:30],temp_c_10[0],temp_c_10[1],temp_c_10[2]);
    LUT1 p12(C_reg_temp[35:33],temp_c_11[0],temp_c_11[1],temp_c_11[2]);
    LUT1 p13(C_reg_temp[38:36],temp_c_12[0],temp_c_12[1],temp_c_12[2]);
    LUT1 p14(C_reg_temp[41:39],temp_c_13[0],temp_c_13[1],temp_c_13[2]);
    assign C_reg_temp[47:42] = 6'b000000;

    always @(posedge clock or negedge reset) begin
        if(!reset)begin
            x_dim <= 5'b00000;
            y_dim <= 5'b00000;
            A_reg <= 16'h0000;
            B_reg <= 16'h0000;
            C_reg <= 16'h0000;
            data_out <= 16'h0000;
            x_dim_zero_flag <= 1'b0;
            x_dim_sec_flag <= 1'b0;
            stopper <= 1'b0; 
        end

        else if(flush == 1'b1)begin
            x_dim <= 5'b00000;
            y_dim <= 5'b00000;
            A_reg <= 16'h0000;
            B_reg <= 16'h0000;
            C_reg <= 16'h0000;
            data_out <= 16'h0000;
            x_dim_zero_flag <= 1'b0;
            x_dim_sec_flag <= 1'b0;
            stopper <= 1'b0; 
        end
        else begin
            if(y_sel == 1'b1) begin
                //update y
                y_dim <= y_line;
            end

            if(weight_data_sel == 1'b1)begin
                //weight data update
                weight_data <= weight_data_in;
            end

            if(sel == 2'b00)begin
                x_dim <= x_line;
            end
            else if(sel == 2'b01)begin
                x_dim <= x_dim - 1'b1;
            end

            if(x_dim == 5'b00000) begin
                x_dim_zero_flag <= 1'b1;
            end
            else begin
                x_dim_zero_flag <= 1'b0;
            end


            if(x_dim == 5'b00010) begin
                x_dim_sec_flag <= 1'b1;
            end
            else begin
                x_dim_sec_flag <= 1'b0;
            end

            C_reg <= IR_in;
            B_reg <= C_reg;
            A_reg <= B_reg;
            data_out <= data_temp_padded;

            if((~C_reg[15]) && (~C_reg[14]) && (~C_reg[13]) && (~C_reg[14]) && (~C_reg[13]) && (~C_reg[12]) && (~C_reg[11]) && (~C_reg[10]) && (~C_reg[9]) && (~C_reg[8]) && (C_reg[7]) && (C_reg[6]) && (C_reg[5]) && (C_reg[4]) && (C_reg[3]) && (C_reg[2]) && (C_reg[1]) && (C_reg[0])) begin
                stopper <= 1'b1;                
            end          

        end
    end


    always @(*) begin
        casex(data_or_dim)
            1'b1: begin
                //data
                IR_in = line_data_in;
                SRAM_in = 4'b0000;
            end
            1'b0: begin
                //dim
                IR_in = 16'h0000;
                SRAM_in = line_data_in[4:0];
            end
        endcase

        casex (x_or_y)
            1'b0:begin
                //x
                x_line = SRAM_in;
                y_line = 4'b0000;
            end
            1'b1:begin
                //y
                x_line = 4'b0000;
                y_line = SRAM_in;
            end
        endcase

        //weight_data_line <= weight_data_in;

         //C XNOR computation
        temp_c_0 <= ~((weight_data[8:6]) ^ (C_reg[2:0]));
        temp_c_1 <= ~((weight_data[8:6]) ^ (C_reg[3:1]));
        temp_c_2 <= ~((weight_data[8:6]) ^ (C_reg[4:2]));
        temp_c_3 <= ~((weight_data[8:6]) ^ (C_reg[5:3]));
        temp_c_4 <= ~((weight_data[8:6]) ^ (C_reg[6:4]));
        temp_c_5 <= ~((weight_data[8:6]) ^ (C_reg[7:5]));
        temp_c_6 <= ~((weight_data[8:6]) ^ (C_reg[8:6]));
        temp_c_7 <= ~((weight_data[8:6]) ^ (C_reg[9:7]));
        temp_c_8 <= ~((weight_data[8:6]) ^ (C_reg[10:8]));
        temp_c_9 <= ~((weight_data[8:6]) ^ (C_reg[11:9]));
        temp_c_10 <= ~((weight_data[8:6]) ^ (C_reg[12:10]));
        temp_c_11 <= ~((weight_data[8:6]) ^ (C_reg[13:11]));
        temp_c_12 <= ~((weight_data[8:6]) ^ (C_reg[14:12]));
        temp_c_13 <= ~((weight_data[8:6]) ^ (C_reg[15:13]));  


        //B XNOR computation
        temp_b_0 <= ~((weight_data[5:3]) ^ (B_reg[2:0]));
        temp_b_1 <= ~((weight_data[5:3]) ^ (B_reg[3:1]));
        temp_b_2 <= ~((weight_data[5:3]) ^ (B_reg[4:2]));
        temp_b_3 <= ~((weight_data[5:3]) ^ (B_reg[5:3]));
        temp_b_4 <= ~((weight_data[5:3]) ^ (B_reg[6:4]));
        temp_b_5 <= ~((weight_data[5:3]) ^ (B_reg[7:5]));
        temp_b_6 <= ~((weight_data[5:3]) ^ (B_reg[8:6]));
        temp_b_7 <= ~((weight_data[5:3]) ^ (B_reg[9:7]));
        temp_b_8 <= ~((weight_data[5:3]) ^ (B_reg[10:8]));
        temp_b_9 <= ~((weight_data[5:3]) ^ (B_reg[11:9]));
        temp_b_10 <= ~((weight_data[5:3]) ^ (B_reg[12:10]));
        temp_b_11 <= ~((weight_data[5:3]) ^ (B_reg[13:11]));
        temp_b_12 <= ~((weight_data[5:3]) ^ (B_reg[14:12]));
        temp_b_13 <= ~((weight_data[5:3]) ^ (B_reg[15:13])); 


        //A XNOR computation
        temp_a_0 <= ~((weight_data[2:0]) ^ (A_reg[2:0]));
        temp_a_1 <= ~((weight_data[2:0]) ^ (A_reg[3:1]));
        temp_a_2 <= ~((weight_data[2:0]) ^ (A_reg[4:2]));
        temp_a_3 <= ~((weight_data[2:0]) ^ (A_reg[5:3]));
        temp_a_4 <= ~((weight_data[2:0]) ^ (A_reg[6:4]));
        temp_a_5 <= ~((weight_data[2:0]) ^ (A_reg[7:5]));
        temp_a_6 <= ~((weight_data[2:0]) ^ (A_reg[8:6]));
        temp_a_7 <= ~((weight_data[2:0]) ^ (A_reg[9:7]));
        temp_a_8 <= ~((weight_data[2:0]) ^ (A_reg[10:8]));
        temp_a_9 <= ~((weight_data[2:0]) ^ (A_reg[11:9]));
        temp_a_10 <= ~((weight_data[2:0]) ^ (A_reg[12:10]));
        temp_a_11 <= ~((weight_data[2:0]) ^ (A_reg[13:11]));
        temp_a_12 <= ~((weight_data[2:0]) ^ (A_reg[14:12]));
        temp_a_13 <= ~((weight_data[2:0]) ^ (A_reg[15:13])); 

        {Carry_A[0], A_reg_added_val[2:0]} <= (A_reg_temp[2:0] + B_reg_temp[2:0]) + (C_reg_temp[2:0] + 3'b000);
        {Carry_A[1], A_reg_added_val[5:3]} <= (A_reg_temp[5:3] + B_reg_temp[5:3]) + (C_reg_temp[5:3] + 3'b000);
        {Carry_A[2], A_reg_added_val[8:6]} <= (A_reg_temp[8:6] + B_reg_temp[8:6]) + (C_reg_temp[8:6] + 3'b000);
        {Carry_A[3], A_reg_added_val[11:9]} <= (A_reg_temp[11:9] + B_reg_temp[11:9]) + (C_reg_temp[11:9] + 3'b000);
        {Carry_A[4], A_reg_added_val[14:12]} <= (A_reg_temp[14:12] + B_reg_temp[14:12]) + (C_reg_temp[14:12] + 3'b000);
        {Carry_A[5], A_reg_added_val[17:15]} <= (A_reg_temp[17:15] + B_reg_temp[17:15]) + (C_reg_temp[17:15] + 3'b000);
        {Carry_A[6], A_reg_added_val[20:18]} <= (A_reg_temp[20:18] + B_reg_temp[20:18]) + (C_reg_temp[20:18] + 3'b000);
        {Carry_A[7], A_reg_added_val[23:21]} <= (A_reg_temp[23:21] + B_reg_temp[23:21]) + (C_reg_temp[23:21] + 3'b000);
        {Carry_A[8], A_reg_added_val[26:24]} <= (A_reg_temp[26:24] + B_reg_temp[26:24]) + (C_reg_temp[26:24] + 3'b000);
        {Carry_A[9], A_reg_added_val[29:27]} <= (A_reg_temp[29:27] + B_reg_temp[29:27]) + (C_reg_temp[29:27] + 3'b000);
        {Carry_A[10], A_reg_added_val[32:30]} <= (A_reg_temp[32:30] + B_reg_temp[32:30]) + (C_reg_temp[32:30] + 3'b000);
        {Carry_A[11], A_reg_added_val[35:33]} <= (A_reg_temp[35:33] + B_reg_temp[35:33]) + (C_reg_temp[35:33] + 3'b000);
        {Carry_A[12], A_reg_added_val[38:36]} <= (A_reg_temp[38:36] + B_reg_temp[38:36]) + (C_reg_temp[38:36] + 3'b000);
        {Carry_A[13], A_reg_added_val[41:39]} <= (A_reg_temp[41:39] + B_reg_temp[41:39]) + (C_reg_temp[41:39] + 3'b000);
        {Carry_A[14], A_reg_added_val[44:42]} <= (A_reg_temp[44:42] + B_reg_temp[44:42]) + (C_reg_temp[44:42] + 3'b000);
        {Carry_A[15], A_reg_added_val[47:45]} <= (A_reg_temp[47:45] + B_reg_temp[47:45]) + (C_reg_temp[47:45] + 3'b000);

        if((Carry_A[0]) || (A_reg_added_val[2:0] > 3'b100)) begin
            data_temp[0] <= 1'b1;
        end
        else begin
            data_temp[0] <= 1'b0;
        end

        if((Carry_A[1]) || (A_reg_added_val[5:3] > 3'b100)) begin
            data_temp[1] <= 1'b1;
        end
        else begin
            data_temp[1] <= 1'b0;
        end

        if((Carry_A[2]) || (A_reg_added_val[8:6] > 3'b100)) begin
            data_temp[2] <= 1'b1;
        end
        else begin
            data_temp[2] <= 1'b0;
        end

        if((Carry_A[3]) || (A_reg_added_val[11:9] > 3'b100)) begin
            data_temp[3] <= 1'b1;
        end
        else begin
            data_temp[3] <= 1'b0;
        end

        if((Carry_A[4]) || (A_reg_added_val[14:12] > 3'b100)) begin
            data_temp[4] <= 1'b1;
        end
        else begin
            data_temp[4] <= 1'b0;
        end

        if((Carry_A[5]) || (A_reg_added_val[17:15] > 3'b100)) begin
            data_temp[5] <= 1'b1;
        end
        else begin
            data_temp[5] <= 1'b0;
        end

        if((Carry_A[6]) || (A_reg_added_val[20:18] > 3'b100)) begin
            data_temp[6] <= 1'b1;
        end
        else begin
            data_temp[6] <= 1'b0;
        end

        if((Carry_A[7]) || (A_reg_added_val[23:21] > 3'b100)) begin
            data_temp[7] <= 1'b1;
        end
        else begin
            data_temp[7] <= 1'b0;
        end

        if((Carry_A[8]) || (A_reg_added_val[26:24] > 3'b100)) begin
            data_temp[8] <= 1'b1;
        end
        else begin
            data_temp[8] <= 1'b0;
        end

        if((Carry_A[9]) || (A_reg_added_val[29:27] > 3'b100)) begin
            data_temp[9] <= 1'b1;
        end
        else begin
            data_temp[9] <= 1'b0;
        end

        if((Carry_A[10]) || (A_reg_added_val[32:30] > 3'b100)) begin
            data_temp[10] <= 1'b1;
        end
        else begin
            data_temp[10] <= 1'b0;
        end

        if((Carry_A[11]) || (A_reg_added_val[35:33] > 3'b100)) begin
            data_temp[11] <= 1'b1;
        end
        else begin
            data_temp[11] <= 1'b0;
        end

        if((Carry_A[12]) || (A_reg_added_val[38:36] > 3'b100)) begin
            data_temp[12] <= 1'b1;
        end
        else begin
            data_temp[12] <= 1'b0;
        end

        if((Carry_A[13]) || (A_reg_added_val[41:39] > 3'b100)) begin
            data_temp[13] <= 1'b1;
        end
        else begin
            data_temp[13] <= 1'b0;
        end
        
        // if((Carry_A[14]) || (A_reg_added_val[44:42] > 3'b100)) begin
        //     data_temp[14] <= 1'b1;
        // end
        // else begin
            data_temp[14] <= 1'b0;
        //end

        // if((Carry_A[15]) || (A_reg_added_val[47:45] > 3'b100)) begin
        //     data_temp[15] <= 1'b1;
        // end
        // else begin
            data_temp[15] <= 1'b0;
        //end


        if(y_dim == 5'b10000) begin
            data_temp_padded <= data_temp;
        end
        else if(y_dim == 5'b01100) begin
            data_temp_padded <= {1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,data_temp[9:0]};
        end
        else if(y_dim == 5'b01010) begin
            data_temp_padded <= {1'h0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,data_temp[7:0]};
        end
        else begin
            data_temp_padded <= 16'h0;
        end
    end
    
endmodule


module LUT1(out,in1,in2,in3);
    input in1,in2,in3;
    output[2:0] out;
    reg[2:0] out;
    always @(*) begin
        casex ({in3,in2,in1})
        3'b000: out<= 3'b000; 
        3'b001: out<= 3'b001;
        3'b010: out<= 3'b001;
        3'b011: out<= 3'b010;
        3'b100: out<= 3'b001;
        3'b101: out<= 3'b010;
        3'b110: out<= 3'b010;
        3'b111: out<= 3'b011;
    endcase
    end
    
endmodule