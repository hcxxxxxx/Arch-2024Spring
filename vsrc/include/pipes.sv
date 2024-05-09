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

    //parameter u1 E = 1'b0;
    //parameter u1 M = 1'b1;

/* Define pipeline structures here */

    typedef struct packed {
        logic flush;
        logic stall;
    } hazard_data_item_t;

    typedef struct packed {
        hazard_data_item_t fetch;
        hazard_data_item_t decode;
        hazard_data_item_t execute;
        hazard_data_item_t memory;
        //hazard_data_item_t writeback;
    } hazard_data_t;

    typedef struct packed {
        u32 instruction;
        u32 pc, pc_plus_4;
    } f_d_reg_t;

    typedef struct packed {
        u32 instruction;
        u32 pc, pc_plus_4;
        u32 rd1, rd2;
        u16 imm16;
        u6 op, func;
        creg_addr_t rs, rt, rd;
    } d_e_reg_t;

    typedef struct packed {
        u32 instruction;
        u32 pc, pc_plus_4;
        logic mem_to_reg, mem_write, alu_src, reg_write, reg_dst;
        //u32 branch_address;
        //logic zero;
        //logic overflow;
        u32 alu_result;
        creg_addr_t rs, rt, rd;
    } e_m_reg_t;

    typedef struct packed {
        u32 instruction;
        u32 pc, pc_plus_4;
        logic mem_to_reg, reg_dst, reg_write;
        u32 alu_result;
        creg_addr_t rs, rt, rd;
    } m_w_reg_t;

endpackage

`endif
