`ifndef __DECODE_SV
`define __DECODE_SV

module decode
    import common::*;
    import pipes::*;(
        /*input word_t instruction,
        output u6 op, func,
        output creg_addr_t rs, rt, rd,
        output u16 imm,
        output u26 jump_index*/
        input logic clk, decode_enable,
        input fetch_data_t fetch_data_reg,
        output decode_data_t decode_data_reg
    );

    fetch_data_t dataFreg;
    u16 imm;

    always_ff @(posedge clk) begin
        if(decode_enable) begin
            dataFreg <= fetch_data_reg;
        end
        else begin
            decode_data_reg.jump <= fetch_data_reg.jump;
        end
        //else dataFreg <= '0;
    end

    assign imm = dataFreg.instruction[15:0];

    assign decode_data_reg.pc = dataFreg.pc;
    assign decode_data_reg.instruction = dataFreg.instruction;
    assign decode_data_reg.op = dataFreg.instruction[31:26];
    assign decode_data_reg.func = dataFreg.instruction[5:0]; //for r-type instructions
    assign decode_data_reg.rs = dataFreg.instruction[25:21];
    assign decode_data_reg.rt = dataFreg.instruction[20:16];
    assign decode_data_reg.rd = dataFreg.instruction[15:11];
    //assign decode_data_reg.imm = dataFreg.instruction[15:0];
    //assign decode_data_reg.jump_index = dataFreg.instruction[25:0];
    assign decode_data_reg.jump_address = {dataFreg.pc[31:28], dataFreg.instruction[25:0], 2'b00};
    //assign decode_data_reg.delay_slot = dataFreg.delay_slot;
    //assign decode_data_reg.jump = (dataFreg.instruction[31:26] == F6_J);

    always_comb begin
        if(dataFreg.instruction[31:26] == F6_BEQ) decode_data_reg.signimm = {{14{imm[15]}}, imm[15:0], 2'b00};
        else decode_data_reg.signimm = {{16{imm[15]}}, imm[15:0]};
    end

endmodule

`endif
