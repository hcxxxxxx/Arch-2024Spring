`ifndef __TOP_SV
`define __TOP_SV

module Top
    import common::*;(
        input logic clk, reset,
        output u2 result// prev_result,
        //output u32 pc
        /*output u1 delay_slot,
        output u1 branch, equal*/
        //output word_t [31:0] regs_tmp
    );
    
    u32 instruction, data_addr;
    word_t read_data, write_data;
    u1 write_enable;
    u32 pc;
    
    /* instantiate a core */
    core core(
        .clk(clk), .reset(reset),
        .instr_addr(pc), .instruction(instruction),
        .data_addr(data_addr), .write_enable(write_enable),
        .read_data(read_data), .write_data(write_data)/*,
        .delay_slot(delay_slot),
        .branch(branch), .equal(equal)*/
        //.regs_tmp(regs_tmp)
    );

    /* instantiate imem and dmem */
    imem imem(
        .pc(pc),
        .instruction(instruction)
    );
    dmem dmem(
        .clk(clk),
        .we(write_enable),
        .addr(data_addr),
        .write_data(write_data),
        .read_data(read_data)
    );

    // for test
    logic [1:0] prev_result;

    always_ff @(posedge clk/*, posedge reset*/) begin
        if (reset) begin
            result <= 2'b00;
            prev_result <= 2'b00;
        end 
        else begin
            if (prev_result == 2'b10 || prev_result == 2'b01) begin
                result <= prev_result;
            end 
            else begin
                case (pc)
                    PC_SUCCESS: begin
                        result <= 2'b10;
                    end
                    PC_FAILED1, PC_FAILED2, PC_FAILED3: begin
                        result <= 2'b01;
                    end
                    default: begin
                        result <= 2'b00;
                    end
                endcase
                prev_result <= result;
            end
        end
    end
    
endmodule

`endif
