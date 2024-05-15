`ifndef __PIPES_SV
`define __PIPES_SV

package pipes;
    import common::*;
    
/* Define instruction decoding rules here */

    parameter u6 F6_R_TYPE = 6'b000000;

    //No operation instruction
    parameter u6 F6_NOP = 6'b000000;

    //Operational instructions
    parameter u6 F6_ADD = 6'b100000;
    parameter u6 F6_SUB = 6'b100010;
    parameter u6 F6_AND = 6'b100100;
    parameter u6 F6_OR = 6'b100101;
    parameter u6 F6_SLT = 6'b101010;
    parameter u6 F6_ADDI = 6'b001000;

    //Memory access instructions
    parameter u6 F6_LW = 6'b100011;
    parameter u6 F6_SW = 6'b101011;

    //Branch instructions
    parameter u6 F6_J = 6'b000010;
    parameter u6 F6_BEQ = 6'b000100;

/* Define pipeline structures here */

    typedef struct packed {
        u32 pc_f, pc_d, pc_e, pc_m, pc_w;
    } pcs_t;

    typedef struct packed {
        logic stallF, stallD, stallE;
        logic flushM;
        u2 forwardA, forwardB;
    } hazard_data_t;

    typedef struct packed {
        u32 aluout, result;
    } execute_forward_data_t;

    typedef struct packed {
        u32 instruction;
        u32 pc_plus_4;
    } f_d_reg_t;

    typedef struct packed {
        u32 pc_plus_4;
        u32 imm32;
        u26 offset;
        u32 rd1, rd2;
        creg_addr_t rs, rt, rd;
        u6 alu_op;
        logic reg_write, mem_to_reg, mem_write, alu_src, reg_dst, branch, jump;
    } d_e_reg_t;

    typedef struct packed {
        u32 pc_plus_4;
        u32 alu_result;
        creg_addr_t write_reg;
        u32 write_data;
        logic reg_write, mem_to_reg, mem_write, branch, jump;
        logic zero;
        u32 pc_branch;
    } e_m_reg_t;

    typedef struct packed {
        logic mem_to_reg, reg_write;
        u32 alu_result;
        creg_addr_t write_reg;
        u32 read_data;
    } m_w_reg_t;

endpackage

`endif
