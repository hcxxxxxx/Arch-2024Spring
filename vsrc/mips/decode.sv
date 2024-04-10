`ifndef __DECODE_SV
`define __DECODE_SV

module decode
    import common::*;
    import pipes::*;(
        input word_t instruction,
        output u6 op, func,
        output creg_addr_t rs, rt, rd,
        output u16 imm,
        output u26 jump_index
    );

    assign op = instruction[31:26];
    assign func = instruction[5:0]; //for r-type instructions
    assign rs = instruction[25:21];
    assign rt = instruction[20:16];
    assign rd = instruction[15:11];
    assign imm = instruction[15:0];
    assign jump_index = instruction[25:0];

endmodule

`endif
