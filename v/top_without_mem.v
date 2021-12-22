module MyDesign (
    //---------------------------------------------------------------------------
//Control signals
        dut_run, 
        dut_busy,
        reset_b,  
        clk,
 
//---------------------------------------------------------------------------
//input and output SRAM interface
        dut_sram_write_address,
        dut_sram_write_data,
        dut_sram_write_enable,
        dut_sram_read_address,
        sram_dut_read_data,
//---------------------------------------------------------------------------
//weights SRAM interface                                                       
        dut_wmem_read_address,
        wmem_dut_read_data
);

    input dut_run,reset_b,clk;
    output dut_busy;
    output[11:0] dut_sram_write_address;
    output[15:0] dut_sram_write_data;
    output dut_sram_write_enable;
    output[11:0] dut_sram_read_address;
    input[15:0] sram_dut_read_data;
    output[11:0] dut_wmem_read_address;
    input[15:0] wmem_dut_read_data;


    // reg[11:0] dut_sram_write_address;
    // reg[15:0] dut_sram_write_data;
    // reg dut_sram_write_enable;
    // reg[11:0] dut_sram_read_address;
    // reg[11:0] dut_wmem_read_address;

    wire x_dim_zero_flag;
    wire x_dim_sec_flag;
    wire inc,PCout,dec;
    wire data_or_dim,x_or_y,weight_data_sel,y_sel;
    wire[1:0] sel;
    wire we;
    wire Out_PC_inc,Out_PC_out;
    wire weight_PC;
    // wire dut_busy;
    wire stopper;
    wire flush;

    PC u1(.clock(clk),.reset(reset_b),.inc(inc),.dec(dec),.flush_PC(flush),.PCoutenable(PCout),.PCout(dut_sram_read_address));

    datapath u2(
    .line_data_in(sram_dut_read_data),.weight_data_in(wmem_dut_read_data),
    .clock(clk),.reset(reset_b),
    .data_out(dut_sram_write_data),.x_dim_zero_flag(x_dim_zero_flag),.x_dim_sec_flag(x_dim_sec_flag),.stopper(stopper),
    //control
    .data_or_dim(data_or_dim),.x_or_y(x_or_y),.weight_data_sel(weight_data_sel),.y_sel(y_sel),.sel(sel),.flush(flush));  


    controller u3(
    .x_dim_zero_flag(x_dim_zero_flag),
    .x_dim_sec_flag(x_dim_sec_flag),
    .clock(clk),.reset(reset_b),
    .dut_run(dut_run),
    .stopper(stopper),
    .inc(inc),.PCout(PCout),.dec(dec),
    .data_or_dim(data_or_dim),.x_or_y(x_or_y),.weight_data_sel(weight_data_sel),.y_sel(y_sel),
    .sel(sel),
    .we(dut_sram_write_enable),
    .Out_PC_inc(Out_PC_inc),.Out_PC_out(Out_PC_out),
    .weight_PC(dut_wmem_read_address),
    .dut_busy(dut_busy),
    .flush(flush));

    PC u4(.clock(clk),.reset(reset_b),.inc(Out_PC_inc),.dec(1'b0),.flush_PC(flush),.PCoutenable(Out_PC_out),.PCout(dut_sram_write_address));
endmodule
