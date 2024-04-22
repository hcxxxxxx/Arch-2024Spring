`ifndef __FSM_SV
`define __FSM_SV

module FSM
    import common::*;
    import pipes::*;(
       input logic clk, reset,
       input u32 instruction,
       output state_enable_t state_enable
    );

    parameter F_ = 3'b001;
    parameter D_ = 3'b010;
    parameter E_ = 3'b011;
    parameter M_ = 3'b100;
    parameter W_ = 3'b101;

    u3 state, next_state;
    u6 op, func;

    assign op = instruction[31:26];
    assign func = instruction[5:0];

    always_ff @(posedge clk, posedge reset) begin
        if(reset) begin
            state_enable.fetch_enable <= 1'b1;
            state_enable.decode_enable <= 1'b0;
            state_enable.execute_enable <= 1'b0;
            state_enable.memory_enable <= 1'b0;
            state_enable.writeback_enable <= 1'b0;
            state_enable.m_or_e <= 1'b0;
        end
        else state <= next_state;
    end

    always_comb begin
        unique case(state)
            F_: begin
                if(instruction == 32'b0) next_state = F_;
                else next_state = D_;
            end

            D_: begin
                case(op)
                    F6_J: next_state = F_;
                    F6_BEQ, F6_SW, F6_LW, F6_ADDI: next_state = E_;
                    F6_R_TYPE: begin
                        if(func == F6_NOP) next_state = F_;
                        else next_state = E_;
                    end
                    default: next_state = F_;
                endcase
            end

            E_: begin
                case(op)
                    F6_BEQ: next_state = F_;
                    F6_R_TYPE, F6_ADDI: begin
                        next_state = W_;
                        state_enable.m_or_e = E;
                    end
                    F6_SW, F6_LW: next_state = M_;
                    default: next_state = F_;
                endcase
            end

            M_: begin
                case(op)
                    F6_SW: next_state = F_;
                    F6_LW: begin
                        next_state = W_;
                        state_enable.m_or_e = M;
                    end
                    default: next_state = F_;
                endcase
            end

            W_: next_state = F_;

            default: next_state = F_;
        endcase
        state_enable.fetch_enable = (next_state == F_);
        state_enable.decode_enable = (next_state == D_);
        state_enable.execute_enable = (next_state == E_);
        state_enable.memory_enable = (next_state == M_);
        state_enable.writeback_enable = (next_state == W_);
    end

endmodule


`endif
