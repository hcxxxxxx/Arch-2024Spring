`ifndef __EXECUTE_SV
`define __EXECUTE_SV

module execute
    import common::*;
    import pipes::*;(
        input logic clk,
        input d_e_reg_t d_e_reg,
        input execute_forward_data_t execute_forward_data,
        input hazard_data_t hazard_data,
        output e_m_reg_t e_m_reg,
        output creg_addr_t rsE, rtE
    );

    //register
    d_e_reg_t d_e;
    always_ff @(posedge clk) begin
        if(!hazard_data.stallE) d_e <= d_e_reg;
    end

    u32 src_a, src_b, src_b1, src_b2;
    u32 imm32x4;

    assign e_m_reg.pc_plus_4 = d_e.pc_plus_4;
    assign e_m_reg.write_data = src_b1;
    assign e_m_reg.reg_write = d_e.reg_write;
    assign e_m_reg.mem_to_reg = d_e.mem_to_reg;
    assign e_m_reg.mem_write = d_e.mem_write;
    assign e_m_reg.branch = d_e.branch;
    assign e_m_reg.jump = d_e.jump;

    assign src_b2 = d_e.imm32;
    assign imm32x4 = {d_e.imm32[29:0], 2'b00};

    always_comb begin
        if(e_m_reg.jump) e_m_reg.pc_branch = {d_e.pc_plus_4[31:28], d_e.offset[25:0], 2'b00}; 
        else e_m_reg.pc_branch = imm32x4 + d_e.pc_plus_4;
    end

    assign rsE = d_e.rs;
    assign rtE = d_e.rt;

    alu alu(.alu_op(d_e.alu_op),
            .src_a(src_a),
            .src_b(src_b),
            .zero(e_m_reg.zero),
            .alu_result(e_m_reg.alu_result));

    Mux4 Mux4A(.in0(d_e.rd1), .in1(execute_forward_data.resultW),
               .in2(execute_forward_data.aluout), .in3(execute_forward_data.resultM),
               .Muxsel(hazard_data.forwardA),
               .out(src_a));
    Mux4 Mux4B(.in0(d_e.rd2), .in1(execute_forward_data.resultW),
               .in2(execute_forward_data.aluout), .in3(execute_forward_data.resultM),
               .Muxsel(hazard_data.forwardB), .out(src_b1));

    Mux2 Mux2A(.in0(d_e.rt), .in1(d_e.rd), .Muxsel(d_e.reg_dst), .out(e_m_reg.write_reg));
    Mux2 Mux2B(.in0(src_b1), .in1(src_b2), .Muxsel(d_e.alu_src), .out(src_b));

endmodule

module Mux4
    import common::*;
    import pipes::*;(
        input u32 in0, in1, in2, in3,
        input u2 Muxsel,
        output u32 out
    );

    always_comb begin
        unique case(Muxsel)
            2'b00: out = in0;
            2'b01: out = in1;
            2'b10: out = in2;
            2'b11: out = in3;
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
