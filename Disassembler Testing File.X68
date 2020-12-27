*-----------------------------------------------------------
* Title      : testing
* Written by : Team: None of the Above
* Date       : 11/5/2020
* Description: Testing file for our final project
*-----------------------------------------------------------
START       ORG         $3000   *where data gets loaded into memory in disassembler

*-----------------------------------------------------
            CLR       D0
            CLR       (A2)
            CLR       (A3)+
            CLR.B     (A7)+
            CLR.W     D5
            CLR.L     -(A4)
            CLR       $1
            CLR.B     D3
            CLR.B     (A2)
            CLR.W     $23
            CLR.L     D3  
            CLR.L     (A5)+
            CLR.L     $1235 
            
            CMP.B       D1,D0
            CMP.W       A2,D1
            CMP.L       (A3),D2    
            CMP.B       (A4)+,D3 
            CMP.W       -(A5),D4  
            
            CMPA.W      D0,A0      
            CMPA.L      A0,A1      
            CMPA.W      (A1),A2    
            CMPA.L      (A2)+,A3   
            CMPA.W      -(A3),A4    
            CMPA.L      #1234,A7
            
            
            CMPI.W      #10,D1
            CMPI.B      #$12,(A3)
            CMPI.B      #$FF, -(A0)
            CMPI.W      #$1222,-(A5)
            
            CMPM.B      (A1)+,(A2)+
            CMPM.W      (A1)+,(A2)+
            CMPM.L      (A1)+,(A2)+
            
            BCHG    D2,D3
            BCHG    D1,(A1)
            BCHG    D3,(A2)+
            BCHG    D4,-(A3)   
            BCHG    #1234,D1
            BCHG    #5678,(A1)
            BCHG    #1234,(A2)+
            BCHG    #12345678,(A3)+
            
            BCLR  D1,D2
            BCLR  D1,(A1)
            BSET  D1,D2
            BSR     START
            BTST     D1,D2
            CHK     D0,D7
            
            
            
            SUBQ.B      #$1,D1
            SUBQ.W      #$2,D2
            SUBQ.L      #3,D3
            SUBQ.W      #$4,A0     
            SUBQ.L      #$5,A1
            SUBQ.L      #$6,A2
            SUBQ.B      #$7,(A0)   
            SUBQ.W      #$8,(A1)
            SUBQ.L      #1,(A2)
            SUBQ.B      #$2,(A2)+    
            SUBQ.W      #$3,(A3)+
            SUBQ.L      #$4,(A4)+
            SUBQ.B      #$5,-(A5)   
            SUBQ.W      #6,-(A6)
            SUBQ.L      #$7,-(A7)
            SUBQ.L      #$4,$12345
            SUBQ.L      #$8,$1
            
            SUBA.W      D0,A0
            SUBA.L      D1,A1 
            SUBA.W      A1,A2  
            SUBA.L      A2,A3
            SUBA.W      (A3),A3  
            SUBA.L      (A4),A4
            SUBA.W      (A5)+,A0  
            SUBA.L      (A6)+,A1
            SUBA.W      -(A0),A2   
            SUBA.L      -(A1),A3
            
 
            EORI.W      #10,D1
            EORI.B      #$12,(A3)
            EORI.W      #$FF,(A2)+
            EORI.B      #$FF, -(A0) 
            EORI.W      #$1222,-(A5)
            

            ANDI.W      #10,D1
            ANDI.B      #$12,(A3)
            ANDI.B      #$FF, (A0)+
            ANDI.W      #$1222,-(A5)
            
            
            CLR.B       D1
            CLR.L       D2
            CLR.L       (A1)
            
            ADDX.B      D1,D2
            ADDX.W      D1,D2
            ADDX.L      D1,D2
            DIVS.W      D1,D2
            EOR         D1,D2
            EXT         D1
            JMP         START
            LINK        A1,#50
            MULU        D1,D2
            RESET
            ROXL        D1,D2
            RTE
            RTR
            SWAP        D1
            
            
            
            
            *Legal instructions
            LEA         $8000,A0
            LEA         (A0),A1
            LEA         $800,A2
            LEA         (A1),A3
            LEA         (A3),A4
            LEA         (A4),A5
            LEA         (A6),A7
            LEA         (A7),A2
            LEA         (A2),A0        
            
            BEQ         $34
            BGT         $56
            BLE         $78
            
            SUB.B       D0,D7
            SUB.B       (A0),D1
            SUB.B       #123,D2
            SUB.B       (A1)+,D3
            SUB.B       -(A2),D4
            SUB.B       $1234,D5
            SUB.B       $12345678,D6
            SUB.B       D7,(A3)
            SUB.B       D0,-(A4)
            SUB.B       D0,(A5)+
            SUB.B       D0,$1111
            SUB.B       D0,$12345678
            
            SUB.W       D0,D7
            SUB.W       (A0),D1
            SUB.W       #123,D2
            SUB.W       (A1)+,D3
            SUB.W       -(A2),D4
            SUB.W       $1234,D5
            SUB.W       $12345678,D6
            SUB.W       D7,(A3)
            SUB.W       D0,-(A4)
            SUB.W       D0,(A5)+
            SUB.W       D0,$1111
            SUB.W       D0,$12345678
            
            SUB.L       D0,D7
            SUB.L       (A0),D1
            SUB.L       #123,D2
            SUB.L       (A1)+,D3
            SUB.L       -(A2),D4
            SUB.L       $1234,D5
            SUB.L       $12345678,D6
            SUB.L       D7,(A3)
            SUB.L       D0,-(A4)
            SUB.L       D0,(A5)+
            SUB.L       D0,$1111
            SUB.L       D0,$12345678
     
            ADD.B       D0,D7
            ADD.B       (A0),D1
            ADD.B       #123,D2
            ADD.B       (A1)+,D3
            ADD.B       -(A2),D4
            ADD.B       $1234,D5
            ADD.B       $12345678,D6
            ADD.B       D7,(A3)
            ADD.B       D0,-(A4)
            ADD.B       D0,(A5)+
            ADD.B       D0,$1111
            ADD.B       D0,$12345678
            
            ADD.W       D0,D7
            ADD.W       (A0),D1
            ADD.W       #123,D2
            ADD.W       (A1)+,D3
            ADD.W       -(A2),D4
            ADD.W       $1234,D5
            ADD.W       $12345678,D6
            ADD.W       D7,(A3)
            ADD.W       D0,-(A4)
            ADD.W       D0,(A5)+
            ADD.W       D0,$1111
            ADD.W       D0,$12345678
            
            ADD.L       D0,D7
            ADD.L       (A0),D1
            ADD.L       #123,D2
            ADD.L       (A1)+,D3
            ADD.L       -(A2),D4
            ADD.L       $1234,D5
            ADD.L       $12345678,D6
            ADD.L       D7,(A3)
            ADD.L       D0,-(A4)
            ADD.L       D0,(A5)+
            ADD.L       D0,$1111
            ADD.L       D0,$12345678
            
            ADDA.W      D0,A0
            ADDA.W      A1,A2
            ADDA.W      (A3)+,A4
            ADDA.W      -(A5),A6
            ADDA.W      #$AAAA,A0
            ADDA.W      $FFFF,A0
            ADDA.W      $11111111,A0
            
            ADDA.L      D0,A0
            ADDA.L      A1,A2
            ADDA.L      (A3)+,A4
            ADDA.L      -(A5),A6
            ADDA.L      #$AAAA,A0
            ADDA.L      $FFFF,A0
            ADDA.L      $11111111,A0
            
            ADDQ.B      #6,D2
            ADDQ.B      #4,(A0)
            ADDQ.B      #7,(A1)+
            ADDQ.B      #5,-(A2)
            ADDQ.B      #2,$5000
            ADDQ.B      #1,$0000FFFF
            
            ADD.W       #1234,D2
            ADD.W       #1001,(A0)
            ADD.W       #$FF,(A1)+
            ADD.W       #77,-(A2)
            ADD.W       #$90,$5000
            ADD.W       #$F,$FFFFFFFF           
            
            ADD.L       #12345678,D2
            ADD.L       #100,(A0)
            ADD.L       #$FFFF,(A1)+
            ADD.L       #77,-(A2)
            ADD.L       #$90,$5000
            ADD.L       #$F,$FFFFFFFF
            
            SUB.B       #123,D2
            SUB.B       #100,(A0)
            SUB.B       #$FF,(A1)+
            SUB.B       #77,-(A2)
            SUB.B       #$90,$5000
            SUB.B       #$F,$FFFFFFFF
            
            SUB.W       #123,D2
            SUB.W       #100,(A0)
            SUB.W       #$FF,(A1)+
            SUB.W       #77,-(A2)
            SUB.W       #$90,$5000
            SUB.W       #$F,$FFFFFFFF
            
            SUB.L       #12345678,D2
            SUB.L       #100,(A0)
            SUB.L       #$FFFF,(A1)+
            SUB.L       #77,-(A2)
            SUB.L       #$90,$5000
            SUB.L       #$F,$FFFFFFFF
        
            ADDQ.B      #1,D0
            ADDQ.B      #2,(A0)
            ADDQ.B      #3,(A1)+
            ADDQ.B      #4,-(A2)
            ADDQ.B      #5,$AAAA
            ADDQ.B      #7,$FFFFFFFF
            
            ADDQ.W      #1,D0
            ADDQ.W      #2,(A0)
            ADDQ.W      #3,(A1)+
            ADDQ.W      #4,-(A2)
            ADDQ.W      #5,$AAAA
            ADDQ.W      #$6,A4
            ADDQ.W      #7,$FFFFFFFF
            
            ADDQ.L      #1,D0
            ADDQ.L      #2,(A0)
            ADDQ.L      #3,(A1)+
            ADDQ.L      #4,-(A2)
            ADDQ.L      #5,$AAAA
            ADDQ.L      #$6,A4
            ADDQ.L      #7,$FFFFFFFF
            
            AND.B       D0,D1
            AND.B       (A0),D2
            AND.B       (A1)+,D3
            AND.B       -(A3),D5
            AND.B       $4000,D6
            AND.B       $12345678,D7
            AND.B       #$F,D7
            AND.B       D0,(A0)
            AND.B       #$F,(A1)+
            AND.B       #$F,-(A2)
            AND.B       D0,$4000
            AND.B       D1,$12345678 
            
            AND.W       D0,D1
            AND.W       (A0),D2
            AND.W       (A1)+,D3
            AND.W       -(A3),D5
            AND.W       $4000,D6
            AND.W       $12345678,D7
            AND.W       #$F,D7
            AND.W       D0,(A0)
            AND.W       #$F,(A1)+
            AND.W       #$F,-(A2)
            AND.W       D0,$4000
            AND.W       D1,$12345678
            
            AND.L       D0,D1
            AND.L       (A0),D2
            AND.L       (A1)+,D3
            AND.L       -(A3),D5
            AND.L       $4000,D6
            AND.L       $12345678,D7
            AND.L       #$F,D7
            AND.L       D0,(A0)
            AND.L       #$F,(A1)+
            AND.L       #$F,-(A2)
            AND.L       D0,$4000
            AND.L       D1,$12345678
            
           OR.B       D0,D1
            OR.B       (A0),D2
            OR.B       (A1)+,D3
            OR.B       -(A3),D5
            OR.B       $4000,D6
            OR.B       $12345678,D7
            OR.B       #$F,D7
            OR.B       D0,(A0)
            OR.B       #$F,(A1)+
            OR.B       #$F,-(A2)
            OR.B       (A1)+,D3
            OR.B       -(A1),D3
            OR.B       #$AF,-(A2)
            OR.B       D0,$4000
            OR.B       D1,$12345678 
            
            OR.W       D0,D1
            OR.W       (A0),D2
            OR.W       (A1)+,D3
            OR.W       -(A3),D5
            OR.W       $4000,D6
            OR.W       $12345678,D7
            OR.W       #$F,D7
            OR.W       D0,(A0)
            OR.W       (A1)+,D3
            OR.W       -(A1),D3
            OR.W       #$AAAF,-(A2)
            OR.W       #$F,(A1)+
            OR.W       #$F,-(A2)
            OR.W       D0,$4000
            OR.W       D1,$12345678
            
            OR.L       D0,D1
            OR.L       (A0),D2
            OR.L       (A1)+,D3
            OR.L       -(A3),D5
            OR.L       $4000,D6
            OR.L       $12345678,D7
            OR.L       #$F,D7
            OR.L       D0,(A0)
            OR.L       (A1)+,D3
            OR.L       -(A1),D3
            OR.L       #$AAAF,-(A2)
            OR.L       #$F,(A1)+
            OR.L       #$F,-(A2)
            OR.L       D0,$4000
            OR.L       D1,$12345678
            
            MOVE.B      D0,D1
            MOVE.B      D1,D0            
            MOVE.B      D2,D3
            MOVE.B      D3,D2            
            MOVE.B      D4,D5
            MOVE.B      D5,D4            
            MOVE.B      D6,D7
            MOVE.B      D7,D6
            MOVE.B      $1234,$5678            
            MOVE.B      $ABCD1234,$EFFE5678
            MOVE.B      #$69,D0
            MOVE.B      -(A1),D0
            MOVE.B      (A2)+,D0
            MOVE.B      (A3),D0
            
            MOVE.W      D0,D1
            MOVE.W      D1,D0            
            MOVE.W      D2,D3
            MOVE.W      D3,D2            
            MOVE.W      D4,D5
            MOVE.W      D5,D4            
            MOVE.W      D6,D7
            MOVE.W      D7,D6
            MOVE.W      $1234,$5678            
            MOVE.W      $ABCD1234,$EFFE5678
            MOVE.W      #$69,D0
            MOVE.W      -(A1),D0
            MOVE.W      (A2)+,D0
            MOVE.W      (A3),D0
            
            MOVE.L      D0,D1
            MOVE.L      D1,D0            
            MOVE.L      D2,D3
            MOVE.L      D3,D2            
            MOVE.L      D4,D5
            MOVE.L      D5,D4            
            MOVE.L      D6,D7
            MOVE.L      D7,D6
            MOVE.L      $1234,$5678            
            MOVE.L      $ABCD1234,$EFFE5678
            MOVE.L      #$69,D0
            MOVE.L      -(A1),D0
            MOVE.L      (A2)+,D0
            MOVE.L      (A3),D0
            
            MOVEA.W     D0,A0
            MOVEA.W     D1,A1
            MOVEA.W     D2,A2
            MOVEA.W     D3,A3
            MOVEA.W     D4,A4
            MOVEA.W     D5,A5
            MOVEA.W     D6,A6
            MOVEA.W     D7,A7
            MOVEA.W     A0,A1
            MOVEA.W     A1,A0
            MOVEA.W     A2,A3
            MOVEA.W     A3,A2
            MOVEA.W     A4,A5
            MOVEA.W     A5,A4
            MOVEA.W     A6,A7
            MOVEA.W     A7,A6
            MOVEA.W     (A0),A1
            MOVEA.W     (A1),A0
            MOVEA.W     (A2),A3
            MOVEA.W     (A3),A2
            MOVEA.W     (A4),A5
            MOVEA.W     (A5),A4
            MOVEA.W     (A6),A7
            MOVEA.W     (A7),A6
            MOVEA.W     (A0)+,A1
            MOVEA.W     (A1)+,A0
            MOVEA.W     (A2)+,A3
            MOVEA.W     (A3)+,A2
            MOVEA.W     (A4)+,A5
            MOVEA.W     (A5)+,A4
            MOVEA.W     (A6)+,A7
            MOVEA.W     (A7)+,A6
            MOVEA.W     -(A0),A1
            MOVEA.W     -(A1),A0
            MOVEA.W     -(A2),A3
            MOVEA.W     -(A3),A2
            MOVEA.W     -(A4),A5
            MOVEA.W     -(A5),A4
            MOVEA.W     -(A6),A7
            MOVEA.W     -(A7),A6
            MOVEA.W     $1234,A0
            MOVEA.W     $5678CDEF,A0
            MOVEA.W     #$ABCD,A0

            MOVEA.L     D0,A0
            MOVEA.L     D1,A1
            MOVEA.L     D2,A2
            MOVEA.L     D3,A3
            MOVEA.L     D4,A4
            MOVEA.L     D5,A5
            MOVEA.L     D6,A6
            MOVEA.L     D7,A7
            MOVEA.L     A0,A1
            MOVEA.L     A1,A0
            MOVEA.L     A2,A3
            MOVEA.L     A3,A2
            MOVEA.L     A4,A5
            MOVEA.L     A5,A4
            MOVEA.L     A6,A7
            MOVEA.L     A7,A6
            MOVEA.L     (A0),A1
            MOVEA.L     (A1),A0
            MOVEA.L     (A2),A3
            MOVEA.L     (A3),A2
            MOVEA.L     (A4),A5
            MOVEA.L     (A5),A4
            MOVEA.L     (A6),A7
            MOVEA.L     (A7),A6
            MOVEA.L     (A0)+,A1
            MOVEA.L     (A1)+,A0
            MOVEA.L     (A2)+,A3
            MOVEA.L     (A3)+,A2
            MOVEA.L     (A4)+,A5
            MOVEA.L     (A5)+,A4
            MOVEA.L     (A6)+,A7
            MOVEA.L     (A7)+,A6
            MOVEA.L     -(A0),A1
            MOVEA.L     -(A1),A0
            MOVEA.L     -(A2),A3
            MOVEA.L     -(A3),A2
            MOVEA.L     -(A4),A5
            MOVEA.L     -(A5),A4
            MOVEA.L     -(A6),A7
            MOVEA.L     -(A7),A6
            MOVEA.L     $1234,A0
            MOVEA.L     $5678CDEF,A0
            MOVEA.L     #$ABCD,A0
            
            BRA         $0            
            BRA         $1            
            BRA         $2            
            BRA         $3            
            BRA         $4            
            BRA         $F0            
            BRA         $F1            
            BRA         $F2            
            BRA         $F3            
            BRA         $F4            
            BRA         $F5
            BRA         $F6            
            BRA         $F7            
            BRA         $F8            
            BRA         $F9
            BRA         $FA            
            BRA         $FB            
            BRA         $FC            
            BRA         $FD            
            BRA         $FE            
            BRA         $FF
            
            MOVEM.W       D0-D7/A0-A7,(A0)
            MOVEM.W       D0-D7/A0-A7,-(A0)            
            MOVEM.L       D0-D7,$1234          
            MOVEM.L       D0-D7,$12345678
            
            LSL.B       #$01,D0
            LSL.B       #$02,D1
            LSL.B       #$03,D2
            LSL.B       #$04,D3
            LSL.B       #$05,D4
            LSL.B       #$06,D5
            LSL.B       #$07,D6
            LSL.B       D0,D7    
            LSL.B       D1,D7  
            LSL.B       D2,D7    
            LSL.B       D3,D7 
            LSL.B       D4,D7    
            LSL.B       D5,D7
            LSL.B       D6,D7    
            LSL.B       D7,D7   

            LSL.W       #$01,D0
            LSL.W       #$02,D1
            LSL.W       #$03,D2
            LSL.W       #$04,D3
            LSL.W       #$05,D4
            LSL.W       #$06,D5
            LSL.W       #$07,D6
            LSL.W       D0,D7    
            LSL.W       D1,D7  
            LSL.W       D2,D7    
            LSL.W       D3,D7 
            LSL.W       D4,D7    
            LSL.W       D5,D7
            LSL.W       D6,D7    
            LSL.W       D7,D7     
            
            LSL.W       $ABCD1234
            LSL.W       $20(A0)

            LSL.W       (A0)            
            LSL.W       -(A0)           
            LSL.W       (A0)+
            LSL.W       (A1)            
            LSL.W       -(A1)           
            LSL.W       (A1)+
            LSL.W       (A2)            
            LSL.W       -(A2)           
            LSL.W       (A2)+
            LSL.W       (A3)            
            LSL.W       -(A3)           
            LSL.W       (A3)+
            LSL.W       (A4)            
            LSL.W       -(A4)           
            LSL.W       (A4)+
            LSL.W       (A5)            
            LSL.W       -(A5)           
            LSL.W       (A5)+
            LSL.W       (A6)            
            LSL.W       -(A6)           
            LSL.W       (A6)+
            LSL.W       (A7)            
            LSL.W       -(A7)           
            LSL.W       (A7)+


            LSL.L       #$01,D0
            LSL.L       #$02,D1
            LSL.L       #$03,D2
            LSL.L       #$04,D3
            LSL.L       #$05,D4
            LSL.L       #$06,D5
            LSL.L       #$07,D6
            LSL.L       D0,D7    
            LSL.L       D1,D7  
            LSL.L       D2,D7    
            LSL.L       D3,D7 
            LSL.L       D4,D7    
            LSL.L       D5,D7
            LSL.L       D6,D7    
            LSL.L       D7,D7 

            LSR.B       #$01,D0
            LSR.B       #$02,D1
            LSR.B       #$03,D2
            LSR.B       #$04,D3
            LSR.B       #$05,D4
            LSR.B       #$06,D5
            LSR.B       #$07,D6
            LSR.B       D0,D7    
            LSR.B       D1,D7  
            LSR.B       D2,D7    
            LSR.B       D3,D7 
            LSR.B       D4,D7    
            LSR.B       D5,D7
            LSR.B       D6,D7    
            LSR.B       D7,D7   

            LSR.W       #$01,D0
            LSR.W       #$02,D1
            LSR.W       #$03,D2
            LSR.W       #$04,D3
            LSR.W       #$05,D4
            LSR.W       #$06,D5
            LSR.W       #$07,D6
            LSR.W       D0,D7    
            LSR.W       D1,D7  
            LSR.W       D2,D7    
            LSR.W       D3,D7 
            LSR.W       D4,D7    
            LSR.W       D5,D7
            LSR.W       D6,D7    
            LSR.W       D7,D7  

            LSR.W       $ABCD1234
            LSR.W       $20(A0)

            LSR.W       (A0)            
            LSR.W       -(A0)           
            LSR.W       (A0)+
            LSR.W       (A1)            
            LSR.W       -(A1)           
            LSR.W       (A1)+
            LSR.W       (A2)            
            LSR.W       -(A2)           
            LSR.W       (A2)+
            LSR.W       (A3)            
            LSR.W       -(A3)           
            LSR.W       (A3)+
            LSR.W       (A4)            
            LSR.W       -(A4)           
            LSR.W       (A4)+
            LSR.W       (A5)            
            LSR.W       -(A5)           
            LSR.W       (A5)+
            LSR.W       (A6)            
            LSR.W       -(A6)           
            LSR.W       (A6)+
            LSR.W       (A7)            
            LSR.W       -(A7)           
            LSR.W       (A7)+   

            LSR.L       #$01,D0
            LSR.L       #$02,D1
            LSR.L       #$03,D2
            LSR.L       #$04,D3
            LSR.L       #$05,D4
            LSR.L       #$06,D5
            LSR.L       #$07,D6
            LSR.L       D0,D7    
            LSR.L       D1,D7  
            LSR.L       D2,D7    
            LSR.L       D3,D7 
            LSR.L       D4,D7    
            LSR.L       D5,D7
            LSR.L       D6,D7    
            LSR.L       D7,D7  

            ASL.B       #$01,D0
            ASL.B       #$02,D1
            ASL.B       #$03,D2
            ASL.B       #$04,D3
            ASL.B       #$05,D4
            ASL.B       #$06,D5
            ASL.B       #$07,D6
            ASL.B       D0,D7    
            ASL.B       D1,D7  
            ASL.B       D2,D7    
            ASL.B       D3,D7 
            ASL.B       D4,D7    
            ASL.B       D5,D7
            ASL.B       D6,D7    
            ASL.B       D7,D7   

            ASL.W       #$01,D0
            ASL.W       #$02,D1
            ASL.W       #$03,D2
            ASL.W       #$04,D3
            ASL.W       #$05,D4
            ASL.W       #$06,D5
            ASL.W       #$07,D6
            ASL.W       D0,D7    
            ASL.W       D1,D7  
            ASL.W       D2,D7    
            ASL.W       D3,D7 
            ASL.W       D4,D7    
            ASL.W       D5,D7
            ASL.W       D6,D7    
            ASL.W       D7,D7   

            ASL.W       $ABCD1234
            ASL.W       $20(A0)

            ASL.W       (A0)            
            ASL.W       -(A0)           
            ASL.W       (A0)+
            ASL.W       (A1)            
            ASL.W       -(A1)           
            ASL.W       (A1)+
            ASL.W       (A2)            
            ASL.W       -(A2)           
            ASL.W       (A2)+
            ASL.W       (A3)            
            ASL.W       -(A3)           
            ASL.W       (A3)+
            ASL.W       (A4)            
            ASL.W       -(A4)           
            ASL.W       (A4)+
            ASL.W       (A5)            
            ASL.W       -(A5)           
            ASL.W       (A5)+
            ASL.W       (A6)            
            ASL.W       -(A6)           
            ASL.W       (A6)+
            ASL.W       (A7)            
            ASL.W       -(A7)           
            ASL.W       (A7)+  

            ASL.L       #$01,D0
            ASL.L       #$02,D1
            ASL.L       #$03,D2
            ASL.L       #$04,D3
            ASL.L       #$05,D4
            ASL.L       #$06,D5
            ASL.L       #$07,D6
            ASL.L       D0,D7    
            ASL.L       D1,D7  
            ASL.L       D2,D7    
            ASL.L       D3,D7 
            ASL.L       D4,D7    
            ASL.L       D5,D7
            ASL.L       D6,D7    
            ASL.L       D7,D7     

            ASR.B       #$01,D0
            ASR.B       #$02,D1
            ASR.B       #$03,D2
            ASR.B       #$04,D3
            ASR.B       #$05,D4
            ASR.B       #$06,D5
            ASR.B       #$07,D6
            ASR.B       D0,D7    
            ASR.B       D1,D7  
            ASR.B       D2,D7    
            ASR.B       D3,D7 
            ASR.B       D4,D7    
            ASR.B       D5,D7
            ASR.B       D6,D7    
            ASR.B       D7,D7   

            ASR.W       #$01,D0
            ASR.W       #$02,D1
            ASR.W       #$03,D2
            ASR.W       #$04,D3
            ASR.W       #$05,D4
            ASR.W       #$06,D5
            ASR.W       #$07,D6
            ASR.W       D0,D7    
            ASR.W       D1,D7  
            ASR.W       D2,D7    
            ASR.W       D3,D7 
            ASR.W       D4,D7    
            ASR.W       D5,D7
            ASR.W       D6,D7    
            ASR.W       D7,D7   

            ASR.W       $ABCD1234
            ASR.W       $20(A0)

            ASR.W       (A0)            
            ASR.W       -(A0)           
            ASR.W       (A0)+
            ASR.W       (A1)            
            ASR.W       -(A1)           
            ASR.W       (A1)+
            ASR.W       (A2)            
            ASR.W       -(A2)           
            ASR.W       (A2)+
            ASR.W       (A3)            
            ASR.W       -(A3)           
            ASR.W       (A3)+
            ASR.W       (A4)            
            ASR.W       -(A4)           
            ASR.W       (A4)+
            ASR.W       (A5)            
            ASR.W       -(A5)           
            ASR.W       (A5)+
            ASR.W       (A6)            
            ASR.W       -(A6)           
            ASR.W       (A6)+
            ASR.W       (A7)            
            ASR.W       -(A7)           
            ASR.W       (A7)+    

            ASR.L       #$01,D0
            ASR.L       #$02,D1
            ASR.L       #$03,D2
            ASR.L       #$04,D3
            ASR.L       #$05,D4
            ASR.L       #$06,D5
            ASR.L       #$07,D6
            ASR.L       D0,D7    
            ASR.L       D1,D7  
            ASR.L       D2,D7    
            ASR.L       D3,D7 
            ASR.L       D4,D7    
            ASR.L       D5,D7
            ASR.L       D6,D7    
            ASR.L       D7,D7

            ROL.B       #$01,D0
            ROL.B       #$02,D1
            ROL.B       #$03,D2
            ROL.B       #$04,D3
            ROL.B       #$05,D4
            ROL.B       #$06,D5
            ROL.B       #$07,D6
            ROL.B       D0,D7    
            ROL.B       D1,D7  
            ROL.B       D2,D7    
            ROL.B       D3,D7 
            ROL.B       D4,D7    
            ROL.B       D5,D7
            ROL.B       D6,D7    
            ROL.B       D7,D7     

            ROL.W       #$01,D0
            ROL.W       #$02,D1
            ROL.W       #$03,D2
            ROL.W       #$04,D3
            ROL.W       #$05,D4
            ROL.W       #$06,D5
            ROL.W       #$07,D6
            ROL.W       D0,D7    
            ROL.W       D1,D7  
            ROL.W       D2,D7    
            ROL.W       D3,D7 
            ROL.W       D4,D7    
            ROL.W       D5,D7
            ROL.W       D6,D7    
            ROL.W       D7,D7  
            
            ROL.W       $ABCD1234
            ROL.W       $20(A0)

            ROL.W       (A0)            
            ROL.W       -(A0)           
            ROL.W       (A0)+
            ROL.W       (A1)            
            ROL.W       -(A1)           
            ROL.W       (A1)+
            ROL.W       (A2)            
            ROL.W       -(A2)           
            ROL.W       (A2)+
            ROL.W       (A3)            
            ROL.W       -(A3)           
            ROL.W       (A3)+
            ROL.W       (A4)            
            ROL.W       -(A4)           
            ROL.W       (A4)+
            ROL.W       (A5)            
            ROL.W       -(A5)           
            ROL.W       (A5)+
            ROL.W       (A6)            
            ROL.W       -(A6)           
            ROL.W       (A6)+
            ROL.W       (A7)            
            ROL.W       -(A7)           
            ROL.W       (A7)+  

            ROL.L       #$01,D0
            ROL.L       #$02,D1
            ROL.L       #$03,D2
            ROL.L       #$04,D3
            ROL.L       #$05,D4
            ROL.L       #$06,D5
            ROL.L       #$07,D6
            ROL.L       D0,D7    
            ROL.L       D1,D7  
            ROL.L       D2,D7    
            ROL.L       D3,D7 
            ROL.L       D4,D7    
            ROL.L       D5,D7
            ROL.L       D6,D7    
            ROL.L       D7,D7  

            ROR.B       #$01,D0
            ROR.B       #$02,D1
            ROR.B       #$03,D2
            ROR.B       #$04,D3
            ROR.B       #$05,D4
            ROR.B       #$06,D5
            ROR.B       #$07,D6
            ROR.B       D0,D7    
            ROR.B       D1,D7  
            ROR.B       D2,D7    
            ROR.B       D3,D7 
            ROR.B       D4,D7    
            ROR.B       D5,D7
            ROR.B       D6,D7    
            ROR.B       D7,D7     


            ROR.W       $ABCD1234
            ROR.W       $20(A0)

            ROR.W       (A0)            
            ROR.W       -(A0)           
            ROR.W       (A0)+
            ROR.W       (A1)            
            ROR.W       -(A1)           
            ROR.W       (A1)+
            ROR.W       (A2)            
            ROR.W       -(A2)           
            ROR.W       (A2)+
            ROR.W       (A3)            
            ROR.W       -(A3)           
            ROR.W       (A3)+
            ROR.W       (A4)            
            ROR.W       -(A4)           
            ROR.W       (A4)+
            ROR.W       (A5)            
            ROR.W       -(A5)           
            ROR.W       (A5)+
            ROR.W       (A6)            
            ROR.W       -(A6)           
            ROR.W       (A6)+
            ROR.W       (A7)            
            ROR.W       -(A7)           
            ROR.W       (A7)+  

            ROR.L       #$01,D0
            ROR.L       #$02,D1
            ROR.L       #$03,D2
            ROR.L       #$04,D3
            ROR.L       #$05,D4
            ROR.L       #$06,D5
            ROR.L       #$07,D6
            ROR.L       D0,D7    
            ROR.L       D1,D7  
            ROR.L       D2,D7    
            ROR.L       D3,D7 
            ROR.L       D4,D7    
            ROR.L       D5,D7
            ROR.L       D6,D7    
            ROR.L       D7,D7
            
            JSR         $1234
            JSR         $ABCD5678
            JSR         (A1)
            NOP
            RTS

    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
