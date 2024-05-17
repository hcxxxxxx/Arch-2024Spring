`ifndef __HAZARD_SV
`define __HAZARD_SV

module hazard
    import common::*;
    import pipes::*;(
        input creg_addr_t rsD, rtD, rsE, rtE, write_reg_M, write_reg_W,
        input logic mem_to_reg_E, mem_to_reg_M, mem_to_reg_W, reg_write_M, reg_write_W,
        output hazard_data_t hazard_data
    );

    u5 judge;
    assign judge = {mem_to_reg_E, mem_to_reg_M, mem_to_reg_W, reg_write_M, reg_write_W};

    always_comb begin
        //default
        hazard_data.forwardA = 2'b00;
        hazard_data.forwardB = 2'b00;
        hazard_data.stallF = 1'b0;
        hazard_data.stallD = 1'b0;
        hazard_data.stallE = 1'b0;
        hazard_data.flushM = 1'b0;

        if(reg_write_W) begin //forward from writeback
            if(write_reg_W == rsE) hazard_data.forwardA = 2'b01;
            else if(write_reg_W == rtE) hazard_data.forwardB = 2'b01;
        end

        if(reg_write_M) begin //forward from memory
            if(mem_to_reg_M == 1'b0) begin
                if(write_reg_M == rsE) hazard_data.forwardA = 2'b10;
                else if(write_reg_M == rtE) hazard_data.forwardB = 2'b10;
            end
            else begin
                hazard_data.stallF = 1'b1;
                hazard_data.stallD = 1'b1;
                hazard_data.stallE = 1'b1;
                hazard_data.flushM = 1'b1;
                if(write_reg_M == rsE) hazard_data.forwardA = 2'b11;
                else if(write_reg_M == rtE) hazard_data.forwardB = 2'b11;
            end
        end
    end

endmodule

`endif