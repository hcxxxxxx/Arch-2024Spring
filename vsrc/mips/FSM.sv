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
        /*unique case(op)
            //r-type
            F6_R_TYPE: begin
                if(func == F6_NOP) begin
                    case(state)
                        F: next_state = D;
                        D: next_state = F;
                        default: next_state = F;
                    endcase
                end
                
                else begin
                    case(state)
                        F: next_state = D;
                        D: next_state = E;
                        E: next_state = W;
                        W: next_state = F;
                        default: next_state = F;
                    endcase
                end
            end

            //addi
            F6_ADDI: begin
                case(state)
                    F: next_state = D;
                    D: next_state = E;
                    E: next_state = W;
                    W: next_state = F;
                    default: next_state = F;
                endcase
            end

            //branch
            F6_J: begin
                case(state)
                    F: next_state = D;
                    D: next_state = F;
                    default: next_state = F;
                endcase
            end

            F6_BEQ: begin
                case(state)
                    F: next_state = D;
                    D: next_state = E;
                    E: next_state = F;
                    default: next_state = F;
                endcase
            end

        endcase*/

        case(state)
            F: next_state = D;

            D: begin
                case(op)
                    //R-type
                    F6_R_TYPE: begin
                        if(func == F6_NOP) next_state = F;
                        else next_state = E;
                    end

                    //J
                    F6_J: next_state = F;

                    //BEQ, SW, LW
                    
                endcase
            end

            default: next_state = F;
        endcase
    end


   

endmodule


`endif
