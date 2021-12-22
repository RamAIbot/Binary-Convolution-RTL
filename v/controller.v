module controller (
    x_dim_zero_flag,
    x_dim_sec_flag,
    clock,reset,
    dut_run,
    stopper,
    inc,PCout,dec,
    data_or_dim,x_or_y,weight_data_sel,y_sel,
    sel,
    we,
    Out_PC_inc,Out_PC_out,
    weight_PC,
    dut_busy,
    flush
);
    input x_dim_zero_flag;
    input x_dim_sec_flag;
    input clock,reset;
    input dut_run;
    input stopper;

    output inc,PCout,dec;
    output data_or_dim,x_or_y,weight_data_sel,y_sel;
    output[1:0] sel;
    output we;
    output Out_PC_inc,Out_PC_out;
    output[11:0] weight_PC;
    output dut_busy;
    output flush;

     parameter [3:0]
        S0 = 4'b0000,
        S1 = 4'b0001,
        S2 = 4'b0010,
        S3 = 4'b0011,
        S4 = 4'b0100,
        S5 = 4'b0101,
        S6 = 4'b0110,
        S7 = 4'b0111,
        S8 = 4'b1000,
        S9 = 4'b1001,
        S10 = 4'b1010,
        S11 = 4'b1011,
        S12 = 4'b1100,
        S13 = 4'b1101,
        S14 = 4'b1110,
        S15 = 4'b1111;

    reg [3:0] current_state, next_state;

    reg inc,PCout,dec;
    reg data_or_dim,x_or_y,weight_data_sel,y_sel;
    reg[1:0] sel;
    reg we;
    reg Out_PC_inc,Out_PC_out;
    reg[11:0] weight_PC;
    reg dut_busy;
    reg flush;
    reg dut_busy_wire;

    always @(posedge clock or negedge reset) begin
        if(!reset)begin
            current_state <= S0;
            dut_busy <= 1'b0;
        end
        else begin
            current_state <= next_state;
            dut_busy <= dut_busy_wire;
        end
    end

    always @(*) begin
        inc = 0;
        PCout = 0;
        dec = 0;
        data_or_dim = 0;
        x_or_y = 0;
        weight_data_sel = 0;
        y_sel = 0;
        sel = 0;
        we = 0;
        Out_PC_inc = 0;
        Out_PC_out = 0;
        weight_PC = 0;
        dut_busy_wire = 0;
        flush = 0;
        next_state = S0;

        case (current_state)
            S0: begin
                inc = 0;
                PCout = 0;
                dec = 0;
                data_or_dim = 0;
                x_or_y = 0;
                weight_data_sel = 0;
                y_sel = 0;
                sel = 0;
                we = 0;
                Out_PC_inc = 0;
                Out_PC_out = 0;
                weight_PC = 0;
                dut_busy_wire = 0;

                if(dut_run == 1'b0 || reset == 1'b0) begin
                    next_state = S0;
                end
                else if(dut_run == 1'b1 && reset == 1'b1) begin
                   // flush_PC = 1;
                    next_state = S1;
                end
            end 

            S1: begin
                inc = 1;
                PCout = 1;
                dec = 0;
                data_or_dim = 0;
                x_or_y = 0;
                weight_data_sel = 0;
                y_sel = 0;
                sel = 0;
                we = 0;
                Out_PC_inc = 0;
                Out_PC_out = 0;
                weight_PC = 12'b000000000001;
                dut_busy_wire = 1;

                if(stopper == 1'b1) begin
                    next_state = S0;
                    flush = 1'b1;
                end
                else begin
                    next_state = S2;
                end
                
            end

            S2: begin
                inc = 1;
                PCout = 1;
                dec = 0;
                data_or_dim = 0;
                x_or_y = 0;
                weight_data_sel = 1;
                y_sel = 0;
                sel = 0;
                we = 0;
                Out_PC_inc = 0;
                Out_PC_out = 0;
                weight_PC = 12'b000000000001;
                dut_busy_wire = 1;

                next_state = S3;
            end

            S3:begin
                inc = 1;
                PCout = 1;
                dec = 0;
                data_or_dim = 0;
                x_or_y = 1;
                weight_data_sel = 1;
                y_sel = 1;
                sel = 2'b10;
                we = 0;
                Out_PC_inc = 0;
                Out_PC_out = 0;
                weight_PC = 12'b000000000001;
                dut_busy_wire = 1;

                next_state = S4;
            end

            S4:begin
                inc = 1;
                PCout = 1;
                dec = 0;
                data_or_dim = 1;
                x_or_y = 1;
                weight_data_sel = 0;
                y_sel = 0;
                sel = 2'b01;
                we = 0;
                Out_PC_inc = 0;
                Out_PC_out = 0;
                weight_PC = 12'b000000000001;
                dut_busy_wire = 1;

                next_state = S5;
            end

            S5:begin
                inc = 1;
                PCout = 1;
                dec = 0;
                data_or_dim = 1;
                x_or_y = 1;
                weight_data_sel = 0;
                y_sel = 0;
                sel = 1;
                we = 0;
                Out_PC_inc = 0;
                Out_PC_out = 0;
                weight_PC = 12'b000000000001;
                dut_busy_wire = 1;

                next_state = S6;
            end

            S6:begin
                inc = 1;
                PCout = 1;
                dec = 0;
                data_or_dim = 1;
                x_or_y = 1;
                weight_data_sel = 0;
                y_sel = 0;
                sel = 1;
                we = 0;
                Out_PC_inc = 0;
                Out_PC_out = 0;
                weight_PC = 12'b000000000001;
                dut_busy_wire = 1;

                next_state = S7;
            end

            S7:begin
                inc = 1;
                PCout = 1;
                dec = 0;
                data_or_dim = 1;
                x_or_y = 1;
                weight_data_sel = 0;
                y_sel = 0;
                sel = 1;
                we = 0;
                Out_PC_inc = 0;
                Out_PC_out = 0;
                weight_PC = 12'b000000000001;
                dut_busy_wire = 1;

                next_state = S8;
            end

            S8:begin

                if(x_dim_sec_flag == 1'b0) begin
                    inc = 1; 
                    dec = 0;   
                end
                else begin
                    inc = 0;
                    dec = 1;
                end
                
                PCout = 1;
                data_or_dim = 1;
                x_or_y = 1;
                weight_data_sel = 0;
                y_sel = 0;
                sel = 1;
                we = 1;
                Out_PC_inc = 1;
                Out_PC_out = 1;
                weight_PC = 12'b000000000001;
                dut_busy_wire = 1;

                if(!x_dim_zero_flag) begin
                    next_state = S8;
                end
                else begin
                    next_state = S9;
                end
            end

            S9:begin
                inc = 0;
                PCout = 1;
                dec = 1;
                data_or_dim = 1;
                x_or_y = 1;
                weight_data_sel = 0;
                y_sel = 0;
                sel = 0;
                we = 0;
                Out_PC_inc = 0;
                Out_PC_out = 0;
                weight_PC = 12'b000000000001;
                dut_busy_wire = 1;

                next_state = S1;
            end

        endcase

    end
endmodule