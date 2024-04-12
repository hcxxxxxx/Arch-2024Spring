`ifndef __FSM_SV
`define __FSM_SV

module FSM
    import common::*;
    import pipes::*;(
       input logic clk, reset,
       input u6 op, func,


    );

    parameter F = 3'b001;
    parameter D = 3'b010;
    parameter E = 3'b011;
    parameter M = 3'b100;
    parameter W = 3'b101;

    u3 state, next_state;

    always_ff @(posedge clk, posedge reset) begin
        if(reset) begin
            state <= F;
            next_state <= D;
        end
        else state <= next_state;
    end

    always_comb begin
        unique case(state)
            F: next_state = D;

            D: begin
                case(op)
                    F6_J: next_state = F;
                    F6_BEQ, F6_SW, F6_LW, F6_ADDI: next_state = E;
                    F6_R_TYPE: begin
                        if(func == F6_NOP) next_state = F;
                        else next_state = E;
                    end
                    default: next_state = F;
                endcase
            end

            E: begin
                case(op)
                    F6_BEQ: next_state = F;
                    F6_R_TYPE: next_state = W;
                    F6_SW, F6_LW: next_state = M;
                    default: next_state = F;
                endcase
            end

            M: begin
                case(op)
                    F6_SW: next_state = F;
                    F6_LW: next_state = W;
                    default: next_state = F;
                endcase
            end

            W: next_state = F;

            default: next_state = F;
        endcase
    end

endmodule


`endif
