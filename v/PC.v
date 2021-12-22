module PC(clock,reset,inc,dec,flush_PC,PCoutenable,PCout);
    input clock;
    input inc;
    input dec;
    input reset;
    input PCoutenable;
    input flush_PC;
    output[11:0] PCout;

    

    reg[11:0] PCnext;
    wire[11:0] PC_current_data;


    always @(posedge clock or negedge reset) begin

        if(!reset)
            PCnext <= 12'b000000000000; 

        else if(flush_PC)
            PCnext <= 12'b0;

        else
        begin
            if(inc == 1'b1) begin
                PCnext <= PC_current_data + 1'b1;
            end 

            if(dec == 1'b1) begin
                PCnext <= PC_current_data - 1'b1;
            end

        end

        


    end

    assign PC_current_data = PCnext;    
    assign PCout = PCoutenable ? PCnext : 12'bz;

endmodule
