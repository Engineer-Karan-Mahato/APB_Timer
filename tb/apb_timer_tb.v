`timescale 1ns / 1ps

module apb_timer_tb;

            parameter WIDTH = 8;

            reg pclk;
            reg preset_n;
               
            reg psel;
            reg pwrite;
            reg penable;
            reg [7 : 0] paddr;
            reg [WIDTH - 1 : 0] pwdata;
                                  
            wire [WIDTH - 1 : 0] prdata;
            wire timer_done;

            apb_timer #(WIDTH)
                 timer_1 (
                                    .pclk(pclk),
                                    .preset_n(preset_n),
                                               
                                    .psel(psel),
                                    .pwrite(pwrite),
                                    .penable(penable),
                                    .paddr(paddr),
                                    .pwdata(pwdata),
                                                                  
                                    .prdata(prdata),
                                    .timer_done(timer_done)
                                );

            always #5 pclk = ~pclk;
            
            task apb_write( input [7:0] addr,  input [WIDTH - 1 : 0] data );
                begin
                    @(posedge pclk);
                    psel = 1;
                    pwrite = 1;
                    penable = 0;
                    paddr = addr;
                    pwdata = data;
                    
                    @(posedge  pclk);
                    penable = 1;
                    
                    @(posedge pclk);
                     psel = 0;
                     penable = 0;
                     pwrite = 0;
                end
            endtask
  
            task apb_read( input [7:0] addr );
                begin
                    @(posedge pclk);
                     psel = 1;
                     pwrite = 0;
                     penable = 0;
                     paddr = addr;
                        
                    @(posedge  pclk);
                     penable = 1;
                        
                    @(posedge pclk);
                     $display("Adress = %h,\t  Data = %d", paddr, prdata);
                        
                     @(posedge pclk);
                      psel = 0;
                      penable = 0;
                end
            endtask
            
            initial begin
                    pclk = 0;
                    preset_n = 0;
                    psel = 0;
                    pwrite = 0;
                    penable = 0;
                    paddr = 0;
                    pwdata = 0;
                    
                    #20;
                    preset_n = 1;
                    
                    apb_write(8'h00, 'd10);
                    apb_write(8'h04, 'd1);
                    
                    @( posedge timer_done );
                    
                    $display(" Timer completed at time = %0t ", $time);
                    
                    apb_read(8'h00);
                    apb_read(8'h04);
                    apb_read(8'h08);
                    apb_read(8'h0c);
                    
                    #40;
                    $finish;
            end
endmodule
