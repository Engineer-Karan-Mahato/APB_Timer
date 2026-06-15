module apb_timer #( parameter WIDTH = 8)
                            (
                                  input pclk,
                                  input preset_n,
                                  
                                  input psel,
                                  input pwrite,
                                  input penable,
                                  input [7 : 0] paddr,
                                  input [WIDTH - 1 : 0] pwdata,
                                  
                                  output reg [WIDTH - 1 : 0] prdata,
                                  output reg timer_done
                            );

            reg [WIDTH - 1 : 0] load_reg;
            reg run_status;
            reg [WIDTH - 1 : 0] count_reg;

            always @( posedge pclk or negedge preset_n ) begin
                    // Reset logic 
                    if ( !preset_n ) begin
                            timer_done <= 0;
                            load_reg     <= 0;
                            run_status  <= 0;
                            count_reg   <= 0;
                    end
                    
                    else begin                    
                            // APB Write Operation
                            if ( psel && penable && pwrite ) begin
                                    case(paddr)
                                            8'h00:  begin
                                                            load_reg   <= pwdata;
                                                            count_reg <= pwdata;
                                                            timer_done <= 1'b0;
                                                        end
                                                        
                                            8'h04:  begin
                                                            run_status <= pwdata[0];
                                                            if ( pwdata[0] )
                                                                timer_done <= 1'b0;
                                                        end
                                    endcase
                            end
                            
                            // Timer Operation
                            else if ( run_status ) begin
                                    if ( count_reg > 0 ) begin
                                            count_reg <= count_reg - 1;
                                            
                                            timer_done <= 1'b0;
                                            run_status  <= 1'b1;
                                    end
                                    else begin
                                            count_reg   <= 0;
                                            timer_done <= 1'b1;
                                            run_status  <= 1'b0;
                                    end
                            end
                    end
            end
            
            always @(*) begin
                    prdata = 0;
                    
                    // APB Read Operation
                    if ( psel && penable && !pwrite ) begin
                            case(paddr)
                                    8'h00:  prdata = load_reg ;
                                        
                                    8'h04:  prdata = {{(WIDTH-1){1'b0}}, run_status} ;
                                                                                                                
                                    8'h08:  prdata = count_reg ;
                                    
                                    8'h0C: prdata = {{(WIDTH-1){1'b0}}, timer_done};
                                    
                                    default: prdata = 0;
                            endcase
                    end
            end

endmodule
