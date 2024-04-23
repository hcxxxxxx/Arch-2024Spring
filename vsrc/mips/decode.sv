`ifndef __DECODE_SV
`define __DECODE_SV

module decode
    import common::*;
    import pipes::*;(
        input logic clk, decode_enable,
        input u32 instruction,
        input fetch_data_t fetch_data_reg,
        output decode_data_t decode_data_reg,
        output u32 jump_address,
        output logic jump_judge
    );

    fetch_data_t dataFreg;
    u16 imm;

    always_ff @(posedge clk) begin
        if(decode_enable) begin
            jump_judge <= (fetch_data_reg.instruction[31:26] == F6_J);
            dataFreg <= fetch_data_reg;
            jump_address <= {fetch_data_reg.pc[31:28], fetch_data_reg.instruction[25:0], 2'b00};
        end
        //else dataFreg <= '0;
    end

    assign imm = dataFreg.instruction[15:0];

    assign decode_data_reg.pc = dataFreg.pc;
    assign decode_data_reg.instruction = dataFreg.instruction;
    assign decode_data_reg.op = dataFreg.instruction[31:26];
    assign decode_data_reg.func = dataFreg.instruction[5:0];
    assign decode_data_reg.rs = dataFreg.instruction[25:21];
    assign decode_data_reg.rt = dataFreg.instruction[20:16];
    assign decode_data_reg.rd = dataFreg.instruction[15:11];

    always_comb begin
        if(dataFreg.instruction[31:26] == F6_BEQ) decode_data_reg.signimm = {{14{imm[15]}}, imm[15:0], 2'b00};
        else decode_data_reg.signimm = {{16{imm[15]}}, imm[15:0]};
    end

endmodule

`endif
