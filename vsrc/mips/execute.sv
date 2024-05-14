`ifndef __EXECUTE_SV
`define __EXECUTE_SV

module execute
    import common::*;
    import pipes::*;(
        input logic clk,
        input d_e_reg_t d_e_reg,
        input execute_forward_data_t execute_forward_data,
        output e_m_reg_t e_m_reg
    );

    //register
    d_e_reg_t d_e;
    always_ff @(posedge clk) begin
        d_e <= d_e_reg;
    end

    u32 src_a, src_b, src_b1, src_b2;
    u32 imm32x4;

    assign e_m_reg.pc_plus_4 = d_e.pc_plus_4;
    assign e_m_reg.write_data = src_b1;
    assign e_m_reg.reg_write = d_e.reg_write;
    assign e_m_reg.mem_to_reg = d_e.mem_to_reg;
    assign e_m_reg.mem_write = d_e.mem_to_reg;
    assign e_m_reg.branch = d_e.branch;

    assign src_b2 = d_e.imm32;
    assign imm32x4 = {d_e.imm32[29:0], 2'b00};
    assign e_m_reg.pc_branch = imm32x4 + d_e.pc_plus_4;

    alu alu(.alu_op(d_e.alu_op),
            .src_a(src_a),
            .src_b(src_b),
            .zero(e_m_reg.zero),
            .alu_result(e_m_reg.alu_result));

    Mux3 Mux3A(.in0(d_e.rd1), .in1(execute_forward_data.resultW),
               .in2(execute_forward_data.aluoutM),
               .Muxsel(execute_forward_data.forwardA),
               .out(src_a));
    Mux3 Mux3B(.in0(d_e.rd2), .in1(execute_forward_data.resultW),
               .in2(execute_forward_data.aluoutM),
               .Muxsel(execute_forward_data.forwardB), .out(src_b1));

    Mux2 Mux2A(.in0(d_e.rt), .in1(d_e.rd), .Muxsel(d_e.reg_dst), .out(e_m_reg.write_reg));
    Mux2 Mux2B(.in0(src_b1), .in1(src_b2), .Muxsel(d_e.alu_src), .out(src_b));

endmodule

module Mux3
    import common::*;
    import pipes::*;(
        input u32 in0, in1, in2,
        input u2 Muxsel,
        output u32 out
    );

    always_comb begin
        unique case(Muxsel)
            2'b00: out = in0;
            2'b01: out = in1;
            2'b10: out = in2;
            default: out = 32'b0;
        endcase
    end

endmodule

module Mux2
    import common::*;
    import pipes::*;(
        input u32 in0, in1,
        input logic Muxsel,
        output u32 out
    );

    always_comb begin
        unique case(Muxsel)
            1'b0: out = in0;
            1'b1: out = in1;
            default: out = 32'b0;
        endcase
    end

endmodule

`endif 
