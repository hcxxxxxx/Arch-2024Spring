`ifndef __HAZARD_SV
`define __HAZARD_SV

module hazard
    import common::*;
    import pipes::*;(
        input creg_addr_t rsD, rtD, rsE, rtE, write_reg_M, write_reg_W 
        input logic mem_to_reg_E, mem_to_reg_M, mem_to_reg_W, reg_write_M, reg_write_W,
        output hazard_data_t hazard_data
    );

    always_comb begin
        //default
        hazard_data.forwardA = 2'b00;
        hazard_data.forwardB = 2'b00;
        hazard_data.stallF = 1'b0;
        hazard_data.stallD = 1'b0;
        hazard_data.stallE = 1'b0;
        hazard_data.flushM = 1'b0;

        case({memtoregE, memtoregM, memtoregW, reg_writeM, reg_writeW})
            5'b00x1x: begin //addi addi
                if(write_reg_M == rsE) hazard_data.forwardA = 2'b10;
                else if(write_reg_M == rtE) hazard_data.forwardB = 2'b10;
            end
            5'b0x001: begin //addi xxx addi
                if(write_reg_W == rsE) hazard_data.forwardA = 2'b01;
                else if(write_reg_W == rtE) hazard_data.forwardB = 2'b01;
            end
            5'b01x1x: begin //lw addi
                hazard_data.stallF = 1'b1;
                hazard_data.stallD = 1'b1;
                hazard_data.stallE = 1'b1;
                hazard_data.flushM = 1'b1;
                if(write_reg_M == rsE) hazard_data.forwardA = 2'b01;
                else if(write_reg_M == rtE) hazard_data.forwardB = 2'b01;
            end
            5'b0x101: begin //lw xxx addi
                if(write_reg_W == rsE) hazard_data.forwardA = 2'b01;
                else if(write_reg_W == rtE) hazard_data.forwardB = 2'b01;
            end
            default: begin
                hazard_data.forwardA = 2'b00;
                hazard_data.forwardB = 2'b00;
                hazard_data.stallF = 1'b0;
                hazard_data.stallD = 1'b0;
                hazard_data.stallE = 1'b0;
                hazard_data.flushM = 1'b0;
            end
        endcase
    end

endmodule

`endif

//memtoregE, memtoregM, memtoregW, reg_writeM, reg_writeW

    //1
    //addi 
    //addi 00x1x

    //F D E M W
    //  F D E M W

    //2
    //addi
    //xxx
    //addi 0x001

    //F D E M W
    //    F D E M W

    //3
    //lw
    //addi 01x1x

    //F D E M W
    //  F D E M W

    //4
    //lw
    //xxx
    //addi 0x101

    //F D E M W
    //    F D E M W
