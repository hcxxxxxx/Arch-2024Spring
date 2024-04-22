`ifndef __MEMORY_SV
`define __MEMORY_SV

module memory
    import common::*;
    import pipes::*;(
        /*input logic clk,
        input logic mem_write,
        input u32 alu_result, write_data,
        output u32 read_data*/
        input logic clk, memory_enable,
        input execute_data_t execute_data_reg,
        output memory_data_t memory_data_reg
    );

    execute_data_t dataEreg;

    always_ff @(posedge clk)begin
        if(memory_enable) dataEreg <= execute_data_reg;
        else dataEreg <= '0;
    end

    assign memory_data_reg.pc = dataEreg.pc;
    assign memory_data_reg.instruction = dataEreg.instruction;
    assign memory_data_reg.mem_to_reg = dataEreg.mem_to_reg;
    assign memory_data_reg.reg_dst = dataEreg.reg_dst;
    assign memory_data_reg.reg_write = dataEreg.reg_write;
    assign memory_data_reg.alu_result = dataEreg.alu_result;
    assign memory_data_reg.rs = dataEreg.rs;
    assign memory_data_reg.rt = dataEreg.rt;
    assign memory_data_reg.rd = dataEreg.rd;

endmodule

`endif
