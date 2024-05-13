`ifndef __ALU_SV
`define __ALU_SV

module alu
    import common::*;
    import pipes::*;(
        input u6 alu_op,
        input u32 src_a, src_b,
        output logic zero,
        output u32 alu_result
    );

    assign zero = (src_a == src_b);

    always_comb begin
        case (alu_op)
            F6_ADD: alu_result = src_a + src_b;
            F6_SUB: alu_result = src_a - src_b;
            F6_AND: alu_result = src_a & src_b;
            F6_OR : alu_result = src_a | src_b;
            F6_SLT: alu_result = $signed(src_a) < $signed(src_b);
            F6_ADDI: alu_result = src_a + src_b;
            F6_LW: alu_result = src_a + src_b;
            F6_SW: alu_result = src_a + src_b;
            default: alu_result = 32'b0;
        endcase
    end

endmodule

`endif
