*-----------------------------------------------------------
* Title      : Memory Printer
* Written by : Team: None of the Above
* Date       : 11/5/2020
* Description: Prompts user to enter 2 memory addresses, and then prints all memory in between them.
*-----------------------------------------------------------
START:  ORG     $1000               *memory of program starts at $1000
        
        *sample bit of memory that program tests itself with
        ;CMP.B   #2,D0
        ;BEQ     EncodeChar
        
        *get MEMStart and MEMEnd, and store in their respective variables
BEGIN   LEA     MESSAGE1,A1         *print formatting message
        MOVE.B  #14,D0
        TRAP    #15
        
        NOP
        LEA     PROMPT1,A1          *print prompt 1
        TRAP    #15
        
        JSR     getHex              *get first address
        LEA     DOWNLINE,A1         *carriage return
        MOVE.B  #14,D0
        TRAP    #15
        MOVE.W  D1,MEMStart         *move address to MEMStart
        
        LEA     PROMPT2,A1          *print prompt 2
        MOVE.B  #14,D0              *Which of the following is true of experimental studies?
        TRAP    #15
        
        JSR     getHex              *get second address
        LEA     DOWNLINE,A1         *carriage return
        MOVE.B  #14,D0
        TRAP    #15
        MOVE.W  D1,MEMEnd           *move address to MEMEnd
        
        JSR     LOOPINI             *start loop, print memory between two user addresses to the console
        
        LEA     RESTART_PROMPT, A1
        MOVE.B  #14,D0              *for printing
        TRAP    #15
        
        MOVE.B  #5, D0              *read a character into D1
        TRAP    #15
        CMP.B   #'Y', D1             *check if input is Y(es)
        BEQ     RESTRT  
        CMP.B   #'y', D1             *check if input is y(es)
        BEQ     RESTRT  
        
        SIMHALT
        
RESTRT  LEA     DOWNLINE,A1         *carriage return
        MOVE.B  #14,D0
        TRAP    #15

        BRA     BEGIN
        
        
        RTS

*the below subroutines are just used for takign user input for the starting and ending memory address
*--------------------------------------------------------------------------------   
*this subroutine prompts the user for a hex word, and stores all the individual digits in D1,D2,D3,D4
*it then calls WtoHex which converts those 4 ASCII digits into an actual hex word. result is stored in D1
getHex  MOVE.B  #5,D0               *load task #5 ->  read a single character from the keyboard into D1
        TRAP    #15                 *take first character of single hex byte
        MOVE.B  D1,D2               *move first value to D2
        TRAP    #15                 *take second character of single hex byte
        MOVE.B  D1,D3               *move second value to D3
        TRAP    #15                 *take third character of single hex byte
        MOVE.B  D1,D4               *move third value to D4
        TRAP    #15                 *take fourth character of single hex byte
        MOVE.B  D1,D5               *move fourth value to D5
        JSR     WtoHex              *convert these ASCII digits into an actual hex word, stores result at D1
        RTS                         *exit subroutine
*stands for Word to Hexadecimal, converts an entire ASCII representation of a hex word into hex
*digits must be at D2,D3,D4,D5. Result is stored at memory address $A000
WtoHex  MOVE.B  D2,D6               *move first value to read position
        JSR     AtoH                *convert it
        MOVE.B  D6,D2               *move result to D2
        MOVE.B  D3,D6               *move second value to read position
        JSR     AtoH                *convert it
        MOVE.B  D6,D3               *move result to D3
        MOVE.B  D4,D6               *move third value to read position
        JSR     AtoH                *convert it
        MOVE.B  D6,D4               *move result to D4
        MOVE.B  D5,D6               *move fourth value to read position
        JSR     AtoH                *convert it
        MOVE.B  D6,D5               *move result to D5
        
        ;now is the time to see whether there was an invalid input for any of these
        CMP.W   #15, D2             *for each result, check if it is over 15
        BGT     INV_INP
        CMP.W   #15, D3             *for each result, check if it is over 15
        BGT     INV_INP
        CMP.W   #15, D4             *for each result, check if it is over 15
        BGT     INV_INP
        CMP.W   #15, D5             *for each result, check if it is over 15
        BGT     INV_INP
            
        
        LSL.B   #4,D2               *shift first hex value one byte to the left
        ADD.B   D2,D3               *add the two hex bytes together
        LSL.B   #4,D4               *shift third hex value one byte to the left
        ADD.B   D4,D5               *add the two hex bytes together
        LSL.W   #8,D3               *shift first two hex digits 8 bits to the left
        ADD.W   D3,D5               *add first two hex digits to last two hex digits
        MOVE.W  D5,D1               *move result to D1
        MOVE.W  #$0000,D2           *empty D2
        MOVE.W  #$0000,D3           *empty D3
        MOVE.W  #$0000,D4           *empty D4
        MOVE.W  #$0000,D5           *empty D5
        
        ;final check for correct memory range - TODO: make sure this is necessary
        CMP.W   MIN_ADDR, D1
        BLT     INV_INP             *invalid if less than minimum
        CMP.W   MAX_ADDR, D1
        BGT     INV_INP             *invalid if greater than maximum
        
        
        
        RTS                         *exit subroutine
        
        
        
INV_INP MOVE.B  #14,D0              *for printing
        LEA     DOWNLINE,A1         *carriage return
        TRAP    #15
        LEA     INVALID_ADDR, A1    *inform user of invalid memory input
        TRAP    #15
        BRA     BEGIN
        
        
*stands for ASCII to Hexadecimal
*this subroutine takes single ASCII character at D6, converts it to hex, and then replaces D6 with the result
AtoH    CMPI.B  #$30,D6             *Numeric of Alpha
        CMP.B   #$39,D6             *$30 - $39 for number
        BGT.B   ALPHA
        SUBI.B  #$30,D6
        RTS                         *exit subroutine
ALPHA   CMPI.B  #$41,D6
        CMPI.B  #$46,D6
        SUBI.B  #$37,D6
        RTS                         *exit subroutine
*--------------------------------------------------------------------------------


*the below subroutines are used for looping over the users memory addresses and printing the memory between them to the console
*--------------------------------------------------------------------------------
*this subroutine is the main memory loop
LOOPINI MOVE.L  #$00000000,D1       *clear D1
        MOVE.W  MEMStart,A2         *move starting memory address to A2
        MOVE.W  MEMEnd,A3           *load ending memory address to A3
        JSR     LOOP
        BRA     EncodeChar
        RTS

LOOP    CMP.W   A2,A3               *have we reached the end of the loop?
        BEQ     DONE                *if so, exit
        CMP.W   A2,A3               *have we gone past the end of the loop?
        BLT     DONE                *if so, exit
        
        
        ;before output we need to see if we've looped enough times to be 1 visible page worth of looping
        MOVE.W  CUR_PRNTD_LNS, D0
        CMP.W   LINES_PER_SCRN, D0
        BNE     LN_PRTD             *break if no need for user hitting enter
        LEA     NEXT_PG_PROMPT, A1
        MOVE.B  #14, D0             *code for displaying the prompt
        TRAP    #15
        MOVE.B  #5, D0              *read an unused character into D1
        TRAP    #15
        
        LEA     DOWNLINE,A1         *carriage return
        MOVE.B  #14,D0
        TRAP    #15
        MOVE.W  #0, CUR_PRNTD_LNS
LN_PRTD ADD.W   #1, CUR_PRNTD_LNS       
        
        ; first thing for proper output is to always print the address even if it's going to be invalid
        MOVE.L  A2, D1              *D1.L will print
        MOVE.B  #16, D2             *specifies base 16 printing
        MOVE.B  #15, D0             *trap #15
        TRAP    #15                 *display the address
        MOVE.L  #9,D1               *the number 9 is the ASCII tab character
        MOVE.B  #6, D0              *trap #6 to show the one character
        TRAP    #15
        
        MOVE.B  (A2),D1             *move memory at current address to D1
        JSR     NEXTB               *get next byte of opcode word and store all at D1, also advance A2 by 1
        JSR     OPDec               *try to decode instruction
        ADD     #1,A2               *increment current memory address
        BRA     LOOP                *continue looping
        
NOVALUE ADD     #1,A2               *increment current memory address
        BRA     LOOP                *re-enter loop
        
*this subroutine reads the next byte of the opcode word, and advances current memory address by 1
NEXTB   LSL.W   #8,D1               *shift firt byte to the left 2 digits
        ADD     #1,A2               *advance A2 by 1
        MOVE.B  (A2),D1             *move next byte of opcode word into D1
        RTS         
        
DONE    RTS                         *exit loop, finished
*--------------------------------------------------------------------------------




*--------------------------------------------------------------------------------
*this subroutine is for decoding OPcode word
OPDec   JSR     DIGIT1              *isolate first digit of opcode word at D0
        LEA     GOOD_BUFFER,A4      *load good buffer to A4
        LEA     BAD_BUFFER,A5       *load bad buffer to A5
        MOVE.W  D1,OPCode           *store opcode for printing later
        JSR     JumpTable           *enter jump table after
        MOVE.B  #$00,(A4)           *signifies end of good buffer
        LEA     GOOD_BUFFER,A1      *prepare to print GOOD_BUFFER
        CMP.B   #$01,INVALID_PTR    *check to see if input was invalid
        BEQ     PDATA               *branch to printing data
        MOVE.B  #13,D0              *prepare to print GOOD_BUFFER
        TRAP    #15                 *print GOOD_BUFFER
        RTS
        
DIGIT1  MOVE.W  D1,D0
        LSR.W   #8,D0
        LSR.W   #4,D0
        RTS

DATA    MOVE.B  #'D',(A5)+ * D      *load text to buffer
        MOVE.B  #'A',(A5)+ * A      *load text to buffer
        MOVE.B  #'T',(A5)+ * T      *load text to buffer
        MOVE.B  #'A',(A5)+ * A      *load text to buffer
        RTS


        
PDATA   MOVE.B  #$00,INVALID_PTR
        JSR     DATA                *load ascii for data to bad buffer
        JSR     HEXOP
        MOVE.B  #$00,(A5)           *signifies end of bad buffer
        LEA     BAD_BUFFER ,A1
        MOVE.B  #13,D0
        TRAP    #15
        MOVE.L  #0,(A6)             *reset invalid condition to false
        CLR     (A6)
        RTS
        
HEXOP   MOVE.W  OPCode,D6
        MOVE.B  #9,(A5)+          * tab
        MOVE.B  #'$',(A5)+          * $
        JSR     BAddWord
        RTS    

*--------------------------------------------------------------------------------
JumpTable       CMP.B   #1,D0
                BEQ     CODE0001    *MOVE.B
                CMP.B   #2,D0
                BEQ     CODE0010    *MOVE.L/MOVEA.L
                CMP.B   #3,D0
                BEQ     CODE0011    *MOVE.W/MOVEA.W
                CMP.B   #4,D0
                BEQ     CODE0100    *LEA, RTS, NOP, JSR, NOT, MOVEM
                CMP.B   #5,D0
                BEQ     CODE0101    *ADDQ/SUB
                CMP.B   #6,D0
                BEQ     CODE0110    *BRA,BGE,BLE,BEQ
                CMP.B   #7,D0
                BEQ     CODE0111    *MOVEQ
                CMP.B   #8,D0
                BEQ     CODE1000    *OR
                CMP.B   #9,D0
                BEQ     CODE1001    *SUB/SUBX
                CMP.B   #12,D0
                BEQ     CODE1100    *AND
                CMP.B   #13,D0
                BEQ     CODE1101    *ADD/ADDA/ADDQ
                CMP.B   #14,D0
                BEQ     CODE1110    *Shift/Rotate
                BRA     INVALID
                
Exit            RTS                 *used to exit subroutines gracefully

* Signals that a function is invalid and should be read as data
INVALID         MOVE.B  #$01,INVALID_PTR
                RTS                 
*--------------------------------------------------------------------------------
CODE0001        JSR     SPLIT               *get EA information into D2 - D5
                MOVE.B  #'M',(A4)+ * M      *load text to buffer
                MOVE.B  #'O',(A4)+ * O
                MOVE.B  #'V',(A4)+ * V
                MOVE.B  #'E',(A4)+ * E
                MOVE.B  #'.',(A4)+ * .
                MOVE.B  #'B',(A4)+ * B
                MOVE.B  #9,(A4)+ *
                
                MOVE.B  #1,D7               *signify what size instruction is in the case of reading extra memory
                MOVE.B  D4,D0               *move bits to proper position
                MOVE.B  D5,D1               *
                JSR     MOVETable           *enter EA decoding jump table
                MOVE.B  #',',(A4)+ * ,
                MOVE.B  D3,D0               *move bits to proper position
                MOVE.B  D2,D1               *
                JSR     MOVETable           *enter EA decoding jump table
                RTS
*--------------------------------------------------------------------------------
CODE0010        JSR     SPLIT               *get EA information into D2 - D5
                MOVE.B  #'M',(A4)+ * M      *load text to buffer
                MOVE.B  #'O',(A4)+ * O
                MOVE.B  #'V',(A4)+ * V
                MOVE.B  #'E',(A4)+ * E
                CMP.B   #1,D3               *is destination mode equal to 1?
                BEQ     moveal              *if so, its a MOVEA.L, branch to moveal
                MOVE.B  #'.',(A4)+ * .      *if not, its a MOVE.L, dont branch
                MOVE.B  #'L',(A4)+ * L
                MOVE.B  #9,(A4)+ *
                
                MOVE.B  #2,D7               *signify what size instruction is in the case of reading extra memory
                MOVE.B  D4,D0               *move bits to proper position
                MOVE.B  D5,D1               *
                JSR     MOVETable           *enter EA decoding jump table
                MOVE.B  #',',(A4)+ * ,
                MOVE.B  D3,D0               *move bits to proper position
                MOVE.B  D2,D1               *
                JSR     MOVETable           *enter EA decoding jump table
                RTS
moveal          MOVE.B  #'A',(A4)+ * A      *adding to make it MOVEA.L
                MOVE.B  #'.',(A4)+ * .
                MOVE.B  #'L',(A4)+ * L
                MOVE.B  #9,(A4)+ *
                
                MOVE.B  #2,D7               *signify what size instruction is in the case of reading extra memory
                MOVE.B  D4,D0               *move bits to proper position
                MOVE.B  D5,D1               *
                JSR     MOVETable           *enter EA decoding jump table
                MOVE.B  #',',(A4)+ * ,
                MOVE.B  D3,D0               *move bits to proper position
                MOVE.B  D2,D1               *
                JSR     MOVETable           *enter EA decoding jump table
                RTS
*--------------------------------------------------------------------------------
CODE0011        JSR     SPLIT               *get EA information into D2 - D5
                MOVE.B  #'M',(A4)+ * M      *load text to buffer
                MOVE.B  #'O',(A4)+ * O
                MOVE.B  #'V',(A4)+ * V
                MOVE.B  #'E',(A4)+ * E
                CMP.B   #1,D3               *is destination mode equal to 1?
                BEQ     moveaw              *if so, its a MOVEA.W, branch to moveal
                MOVE.B  #'.',(A4)+ * .      *if not, its a MOVE.W, dont branch
                MOVE.B  #'W',(A4)+ * W
                MOVE.B  #9,(A4)+ *
                
                MOVE.B  #3,D7               *signify what size instruction is in the case of reading extra memory
                MOVE.B  D4,D0               *move bits to proper position
                MOVE.B  D5,D1               *
                JSR     MOVETable           *enter EA decoding jump table
                MOVE.B  #',',(A4)+ * ,
                MOVE.B  D3,D0               *move bits to proper position
                MOVE.B  D2,D1               *
                JSR     MOVETable           *enter EA decoding jump table
                RTS
moveaw          MOVE.B  #'A',(A4)+ * A      *adding to make it MOVEA.W
                MOVE.B  #'.',(A4)+ * .
                MOVE.B  #'W',(A4)+ * W
                MOVE.B  #9,(A4)+ *
                
                MOVE.B  #2,D7               *signify what size instruction is in the case of reading extra memory   
                MOVE.B  D4,D0               *move bits to proper position
                MOVE.B  D5,D1               *
                JSR     MOVETable           *enter EA decoding jump table
                MOVE.B  #',',(A4)+ * ,
                MOVE.B  D3,D0               *move bits to proper position
                MOVE.B  D2,D1               *
                JSR     MOVETable           *enter EA decoding jump table
                RTS
*--------------------------------------------------------------------------------
CODE0100        CMP.W   #$4E71,D1           *is this a NOP instruction?
                BEQ     NOPEncode           *if so, branch to nop encode
                CMP.W   #$4E75,D1           *is this a RTS instruction?
                BEQ     RTSEncode           *if so, branch to RTS encode
                MOVE.W  D1,D2               *manipulate data to check for TRAP
                LSR.W   #4,D2               *
                CMP.W   #$04E4,D2           *is this a trap task?
                BEQ     TRAPEncode          *if so, branch to TRAPEncode
                MOVE.W  D1,D2               *manipulate data to check for JSR
                LSR.W   #6,D2               *
                CMP.W   #$013A,D2           *is this in fact, a JSR instruction?
                BEQ     JSREncode           *if so, branch to JSREncode
                MOVE.W  D1,D2               *manipulate data to check for NOT
                LSR.W   #8,D2               *
                CMP.B   #$46,D2             *is the instruction a NOT?
                BEQ     NOTEncode           *if so, branch to NOTEncode
                BRA     MOVEMstart          *if not, continue decoding
NOPEncode       MOVE.B  #'N',(A4)+ * N
                MOVE.B  #'O',(A4)+ * O
                MOVE.B  #'P',(A4)+ * P
                RTS                         *instruction decoded
RTSEncode       MOVE.B  #'R',(A4)+ * R
                MOVE.B  #'T',(A4)+ * T
                MOVE.B  #'S',(A4)+ * S
                RTS                         *instruction decoded
TRAPEncode      MOVE.B  #'T',(A4)+ * T
                MOVE.B  #'R',(A4)+ * R
                MOVE.B  #'A',(A4)+ * A
                MOVE.B  #'P',(A4)+ * P
                MOVE.B  #9,(A4)+ * 
                MOVE.B  #'#',(A4)+ * #
                MOVE.B  #'$',(A4)+ * $
                LSL.W   #8,D1               *isolate vector bit
                LSL.W   #4,D1               *
                LSR.W   #8,D1               *
                LSR.W   #4,D1               *
                JSR     EncodeChar          *encode vector bit
                RTS                         *instruction decoded
LEAEncode       MOVE.B  #'L',(A4)+ * L
                MOVE.B  #'E',(A4)+ * E
                MOVE.B  #'A',(A4)+ * A
                MOVE.B  #9,(A4)+ *
                MOVE.B  D4,D0
                MOVE.B  D5,D1
                JSR     LEAJumpTable        *jump to LEA specific jump table
                MOVE.B  #',',(A4)+ * ,
                MOVE.B  #'A',(A4)+ * A
                MOVE.B  D2,D1               *move register data to D1 so it can work with subroutine
                JSR     EncodeChar          *add register number to buffer
                RTS
JSREncode       MOVE.B  #'J',(A4)+ * J
                MOVE.B  #'S',(A4)+ * S
                MOVE.B  #'R',(A4)+ * R
                MOVE.B  #9,(A4)+ * 
                JSR     SPLIT               *split bits to get information easier to work with
                MOVE.B  D4,D0               *move data to correct spots to work with jump table
                MOVE.B  D5,D1               *
                JSR     LEAJumpTable        *decode EA part
                RTS
NOTEncode       MOVE.B  #'N',(A4)+ * J
                MOVE.B  #'O',(A4)+ * S
                MOVE.B  #'T',(A4)+ * R
                MOVE.B  #'.',(A4)+ * .
                JSR     SPLIT               *split up last 3 digits of opcode word
                CMP.B   #0,D3               *is the size byte?
                BEQ     NOTByte             *
                CMP.B   #1,D3               *is the size word?
                BEQ     NOTWord             *
                CMP.B   #2,D3               *is the size long?
                BEQ     NOTLong             *
                BRA     INVALID             *invalid instruction
NOTByte         MOVE.B  #'B',(A4)+ * B
                MOVE.B  #1,D7
                BRA     NOTContinue
NOTWord         MOVE.B  #'W',(A4)+ * B
                MOVE.B  #3,D7
                BRA     NOTContinue
NOTLong         MOVE.B  #'L',(A4)+ * B
                MOVE.B  #2,D7
                BRA     NOTContinue
NOTContinue     MOVE.B  #9,(A4)+ * tab
                MOVE.B  D4,D0               *move mode info to D0
                MOVE.B  D5,D1               *move register info to D1
                JSR     NOTJumpTable        *jump to specific NOT jump table
                RTS                         *instruction decoded
NOTJumpTable    CMP.B   #0,D0               *is the mode designating An?
                BEQ     Dn                  *if so, branch to custom LEA subroutine
                CMP.B   #2,D0               *(An)?
                BEQ     AnIndirect
                CMP.B   #3,D0               *(An)+?
                BEQ     AnIncrement
                CMP.B   #4,D0               *-(An)?
                BEQ     AnDecrement
                CMP.B   #7,D0               *is the mode designating either a absolute word or long?
                BEQ     CheckReg            *if so, use generic CheckReg subroutine
                BRA     INVALID             *if reached, instruction is invalid
LEAJumpTable    CMP.B   #2,D0               *is the mode designating An?
                BEQ     AnIndirect          *if so, branch to custom LEA subroutine
                CMP.B   #7,D0               *is the mode designating either a absolute word or long?
                BEQ     CheckReg            *if so, use generic CheckReg subroutine
                BRA     INVALID             *if reached, instruction is invalid
MOVEMstart      JSR     SPLIT               *get EA information into D2-D5
                CMP.B   #7,D3               *is this actually a LEA instruction?
                BEQ     LEAEncode           *if so, branch to LEAEncode
                JSR     READW               *read register list data
                MOVE.W  D6,MoveMData        *store register list data
                MOVE.B  #'M',(A4)+ * M      *load text to buffer
                MOVE.B  #'O',(A4)+ * O
                MOVE.B  #'V',(A4)+ * V
                MOVE.B  #'E',(A4)+ * E
                MOVE.B  #'M',(A4)+ * M
                MOVE.B  #'.',(A4)+ * .
                CMP.B   #4,D2               *check to see if actually a movem
                BLT     INVALID 
                MOVE.B  D3,D6               *copy D3 to D6
                LSL.B   #7,D6               *isolate "Size" bit
                LSR.B   #7,D6               *
                CMP.B   #1,D6               *is the size long?
                BEQ     moveml              *if so branch off
                MOVE.B  #'W',(A4)+ * W      *if not add W
                BRA     movemcontinue       *continue
moveml          MOVE.B  #'L',(A4)+ * L      *add L
                BRA     movemcontinue       *continue
movemcontinue   MOVE.B  #9,(A4)+ *        *
                MOVE.B  D2,D6               *copy D2 to D6
                LSR.B   #1,D6               *isolate direction bit
                LSL.B   #7,D6               *
                LSR.B   #7,D6               *
                CMP.B   #1,D6               *is the mode memory to register?
                BEQ     MtoRMode            *if so, jump to correct jump table
                BRA     RtoMMode            *else the mode must bo register to memory
MtoRMode        MOVE.B  D5,D1               *copy over EA register
                MOVE.B  D4,D0               *copy over EA mode
                JSR     movemMtoRtable      *decode EA first
                MOVE.B  #',',(A4)+ * ,
                
                JSR     splitUpWord         *splits up word at D6 into single hex digits that will be placed at D2-D5
                MOVE.B  #15,D7              *move counter variable to D7
                MOVE.B  D2,D0               *decode first 4 bits of register info
                JSR     decodeMRDigit       *
                MOVE.B  D3,D0               *decode second 4 bits of register info
                JSR     decodeMRDigit       *
                MOVE.B  D4,D0               *decode third 4 bits of register info
                JSR     decodeMRDigit       *
                MOVE.B  D5,D0               *decode fourth 4 bits of register info
                JSR     decodeMRDigit       *
                SUB.B   #'/',-(A4) * /
                RTS                         *instruction decoded
RtoMMode        CMP.B   #4,D4
                BEQ     RMAltDecode         *decodes using alternate table
                BRA     RMRegDecode         *decodes using regular table

RMRegDecode     JSR     splitUpWord         *splits up word at D6 into single hex digits that will be placed at D2-D5
                MOVE.B  #15,D7              *move counter variable to D7
                MOVE.B  D2,D0               *decode first 4 bits of register info
                JSR     decodeMRDigit       *
                MOVE.B  D3,D0               *decode second 4 bits of register info
                JSR     decodeMRDigit       *
                MOVE.B  D4,D0               *decode third 4 bits of register info
                JSR     decodeMRDigit       *
                MOVE.B  D5,D0               *decode fourth 4 bits of register info
                JSR     decodeMRDigit       *
                BRA     RMContinue          *continue decoding

RMAltDecode     JSR     splitUpWord         *splits up word at D6 into single hex digits that will be placed at D2-D5
                MOVE.B  #15,D7              *move counter variable to D7
                MOVE.B  D2,D0               *decode first 4 bits of register info
                JSR     decodeRMDigit       *
                MOVE.B  D3,D0               *decode second 4 bits of register info
                JSR     decodeRMDigit       *
                MOVE.B  D4,D0               *decode third 4 bits of register info
                JSR     decodeRMDigit       *
                MOVE.B  D5,D0               *decode fourth 4 bits of register info
                JSR     decodeRMDigit       *
                BRA     RMContinue          *continue decoding
                
RMContinue      SUB.B   #'/',-(A4) * /
                MOVE.B  #',',(A4)+ * ,
                MOVE.W  OPCode,D1           *get opcode from stored variable
                JSR     SPLIT               *split up opcode for decoding
                MOVE.B  D5,D1               *copy over EA register
                MOVE.B  D4,D0               *copy over EA mode
                JSR     movemRtoMtable      *decode EA last
                
                RTS                         *instruction decoded
movemMtoRtable  CMP.B   #2,D0               *2?
                BEQ     AnIndirect          *address register indirect
                CMP.B   #3,D0               *3?
                BEQ     AnIncrement         *address register with post increment
                CMP.B   #7,D0               *7?
                BEQ     CheckReg            *branch for further checking, either absolute or immediate data
                BRA     INVALID             *invalid instruction if this point is reached
movemRtoMtable  CMP.B   #2,D0               *2?
                BEQ     AnIndirect          *address register indirect
                CMP.B   #4,D0               *4?
                BEQ     AnDecrement         *address register with pre decrement
                CMP.B   #7,D0               *7?
                BEQ     CheckReg            *branch for further checking, either absolute or immediate data
                BRA     INVALID             *invalid instruction if this point is reached
splitUpWord     MOVE.W  MoveMData,D2        *copy data to each register
                MOVE.W  MoveMData,D3        *
                MOVE.W  MoveMData,D4        *
                MOVE.W  MoveMData,D5        *
                LSR.W   #8,D2               *isolate first digit
                LSR.W   #4,D2
                LSL.W   #4,D3               *isolate second digit
                LSR.W   #8,D3               *
                LSR.W   #4,D3               *
                LSL.W   #8,D4               *isolate third digit
                LSR.W   #8,D4               *
                LSR.W   #4,D4               *
                LSL.W   #8,D5               *isolate fourth digit 
                LSL.W   #4,D5               *
                LSR.W   #4,D5               *
                LSR.W   #8,D5               *
                RTS
*this subroutine is the jump table for decoding memory to register list of registers for movem
decodeMRDigit   CMP.B   #15,D0              *decodes register information of a single hex digit, looks at D0
                BEQ     MRseqF              *memory to register sequence for F
                CMP.B   #14,D0
                BEQ     MRseqE              *memory to register sequence for E
                CMP.B   #13,D0
                BEQ     MRseqD              *memory to register sequence for D
                CMP.B   #12,D0
                BEQ     MRseqC              *memory to register sequence for C
                CMP.B   #11,D0
                BEQ     MRseqB              *memory to register sequence for B
                CMP.B   #10,D0
                BEQ     MRseqA              *memory to register sequence for A
                CMP.B   #9,D0
                BEQ     MRseq9              *memory to register sequence for 9
                CMP.B   #8,D0
                BEQ     MRseq8              *memory to register sequence for 8
                CMP.B   #7,D0
                BEQ     MRseq7              *memory to register sequence for 7
                CMP.B   #6,D0
                BEQ     MRseq6              *memory to register sequence for 6
                CMP.B   #5,D0
                BEQ     MRseq5              *memory to register sequence for 5
                CMP.B   #4,D0
                BEQ     MRseq4              *memory to register sequence for 4
                CMP.B   #3,D0
                BEQ     MRseq3              *memory to register sequence for 3
                CMP.B   #2,D0
                BEQ     MRseq2              *memory to register sequence for 2
                CMP.B   #1,D0
                BEQ     MRseq1              *memory to register sequence for 1
                CMP.B   #0,D0
                BEQ     MRseq0              *memory to register sequence for 0
                BRA     INVALID             *invalid instruction
MRseq0          SUB.B   #4,D7               *decoding memory to register sequence 0
                RTS
MRseq1          SUB.B   #3,D7               *decoding memory to register sequence 1
                JSR     addMRRegister
                RTS
MRseq2          SUB.B   #2,D7               *decoding memory to register sequence 2
                JSR     addMRRegister
                SUB.B   #1,D7
                RTS
MRseq3          SUB.B   #3,D7               *decoding memory to register sequence 3
                JSR     addMRRegister
                JSR     addMRRegister
                RTS
MRseq4          SUB.B   #1,D7               *decoding memory to register sequence 4
                JSR     addMRRegister
                SUB.B   #2,D7
                RTS
MRseq5          SUB.B   #1,D7               *decoding memory to register sequence 5
                JSR     addMRRegister
                SUB.B   #1,D7
                JSR     addMRRegister
                RTS
MRseq6          SUB.B   #1,D7               *decoding memory to register sequence 6
                JSR     addMRRegister
                JSR     addMRRegister
                SUB.B   #1,D7
                RTS
MRseq7          SUB.B   #1,D7               *decoding memory to register sequence 7
                JSR     addMRRegister
                JSR     addMRRegister
                JSR     addMRRegister
                RTS
MRseq8          JSR     addMRRegister       *decoding memory to register sequence 8
                SUB.B   #3,D7           
                RTS
MRseq9          JSR     addMRRegister       *decoding memory to register sequence 9
                SUB.B   #2,D7
                JSR     addMRRegister
                RTS
MRseqA          JSR     addMRRegister       *decoding memory to register sequence A
                SUB.B   #1,D7
                JSR     addMRRegister
                SUB.B   #1,D7
                RTS
MRseqB          JSR     addMRRegister       *decoding memory to register sequence B
                SUB.B   #1,D7
                JSR     addMRRegister
                JSR     addMRRegister
                RTS
MRseqC          JSR     addMRRegister       *decoding memory to register sequence C
                JSR     addMRRegister
                SUB.B   #2,D7
                RTS
MRseqD          JSR     addMRRegister       *decoding memory to register sequence D
                JSR     addMRRegister
                SUB.B   #1,D7
                JSR     addMRRegister
                RTS
MRseqE          JSR     addMRRegister       *decoding memory to register sequence E
                JSR     addMRRegister
                JSR     addMRRegister
                SUB.B   #1,D7
                RTS
MRseqF          JSR     addMRRegister       *decoding memory to register sequence F
                JSR     addMRRegister
                JSR     addMRRegister
                JSR     addMRRegister
                RTS
*this subroutine is the jump table for decoding register to memory list of registers for movem                
decodeRMDigit   CMP.B   #15,D0              *decodes register information of a single hex digit, looks at D0
                BEQ     RMseqF              *memory to register sequence for F
                CMP.B   #14,D0
                BEQ     RMseqE              *memory to register sequence for E
                CMP.B   #13,D0
                BEQ     RMseqD              *memory to register sequence for D
                CMP.B   #12,D0
                BEQ     RMseqC              *memory to register sequence for C
                CMP.B   #11,D0
                BEQ     RMseqB              *memory to register sequence for B
                CMP.B   #10,D0
                BEQ     RMseqA              *memory to register sequence for A
                CMP.B   #9,D0
                BEQ     RMseq9              *memory to register sequence for 9
                CMP.B   #8,D0
                BEQ     RMseq8              *memory to register sequence for 8
                CMP.B   #7,D0
                BEQ     RMseq7              *memory to register sequence for 7
                CMP.B   #6,D0
                BEQ     RMseq6              *memory to register sequence for 6
                CMP.B   #5,D0
                BEQ     RMseq5              *memory to register sequence for 5
                CMP.B   #4,D0
                BEQ     RMseq4              *memory to register sequence for 4
                CMP.B   #3,D0
                BEQ     RMseq3              *memory to register sequence for 3
                CMP.B   #2,D0
                BEQ     RMseq2              *memory to register sequence for 2
                CMP.B   #1,D0
                BEQ     RMseq1              *memory to register sequence for 1
                CMP.B   #0,D0
                BEQ     RMseq0              *memory to register sequence for 0
                BRA     INVALID             *invalid instruction
RMseq0          SUB.B   #4,D7               *decoding memory to register sequence 0
                RTS
RMseq1          SUB.B   #3,D7               *decoding memory to register sequence 1
                JSR     addRMRegister
                RTS
RMseq2          SUB.B   #2,D7               *decoding memory to register sequence 2
                JSR     addRMRegister
                SUB.B   #1,D7
                RTS
RMseq3          SUB.B   #3,D7               *decoding memory to register sequence 3
                JSR     addRMRegister
                JSR     addRMRegister
                RTS     
RMseq4          SUB.B   #1,D7               *decoding memory to register sequence 4
                JSR     addRMRegister
                SUB.B   #2,D7
                RTS
RMseq5          SUB.B   #1,D7               *decoding memory to register sequence 5
                JSR     addRMRegister
                SUB.B   #1,D7
                JSR     addRMRegister
                RTS
RMseq6          SUB.B   #1,D7               *decoding memory to register sequence 6
                JSR     addRMRegister
                JSR     addRMRegister
                SUB.B   #1,D7
                RTS
RMseq7          SUB.B   #1,D7               *decoding memory to register sequence 7
                JSR     addRMRegister
                JSR     addRMRegister
                JSR     addRMRegister
                RTS
RMseq8          JSR     addRMRegister       *decoding memory to register sequence 8
                SUB.B   #3,D7
                RTS
RMseq9          JSR     addRMRegister       *decoding memory to register sequence 9
                SUB.B   #2,D7
                JSR     addRMRegister
                RTS
RMseqA          JSR     addRMRegister       *decoding memory to register sequence A
                SUB.B   #1,D7
                JSR     addRMRegister
                SUB.B   #1,D7
                RTS
RMseqB          JSR     addRMRegister       *decoding memory to register sequence B
                SUB.B   #1,D7
                JSR     addRMRegister
                JSR     addRMRegister
                RTS
RMseqC          JSR     addRMRegister       *decoding memory to register sequence C
                JSR     addRMRegister
                SUB.B   #2,D7
                RTS
RMseqD          JSR     addRMRegister       *decoding memory to register sequence D
                JSR     addRMRegister
                SUB.B   #1,D7
                JSR     addRMRegister
                RTS
RMseqE          JSR     addRMRegister       *decoding memory to register sequence E
                JSR     addRMRegister
                JSR     addRMRegister
                SUB.B   #1,D7
                RTS
RMseqF          JSR     addRMRegister       *decoding memory to register sequence F
                JSR     addRMRegister
                JSR     addRMRegister
                JSR     addRMRegister
                RTS
*this is the jump table for adding a register to the register list for memory to register                
addMRRegister   CMP.B   #15,D7              *if value is F
                BEQ     addA7               *add A7 to the register list
                CMP.B   #14,D7              *if value is E
                BEQ     addA6               *add A6 to the register list
                CMP.B   #13,D7              *if value is D
                BEQ     addA5               *add A5 to the register list
                CMP.B   #12,D7              *if value is C
                BEQ     addA4               *add A4 to the register list
                CMP.B   #11,D7              *if value is B
                BEQ     addA3               *add A3 to the register list
                CMP.B   #10,D7              *if value is A
                BEQ     addA2               *add A2 to the register list
                CMP.B   #9,D7               *if value is 9
                BEQ     addA1               *add A1 to the register list
                CMP.B   #8,D7               *if value is 8
                BEQ     addA0               *add A0 to the register list
                CMP.B   #7,D7               *if value is 7
                BEQ     addD7               *add D7 to the register list
                CMP.B   #6,D7               *if value is 6
                BEQ     addD6               *add D6 to the register list
                CMP.B   #5,D7               *if value is 5
                BEQ     addD5               *add D5 to the register list
                CMP.B   #4,D7               *if value is 4
                BEQ     addD4               *add D4 to the register list
                CMP.B   #3,D7               *if value is 3
                BEQ     addD3               *add D3 to the register list
                CMP.B   #2,D7               *if value is 2
                BEQ     addD2               *add D2 to the register list
                CMP.B   #1,D7               *if value is 1
                BEQ     addD1               *add D2 to the register list
                CMP.B   #0,D7               *if value is 0
                BEQ     addD0               *add D0 to the register list
                BRA     INVALID             *invalid instruction
*this is the jump table for adding a register to the register list for register to memory
addRMRegister   CMP.B   #15,D7              *if value is F
                BEQ     addD0               *add D0 to the register list
                CMP.B   #14,D7              *if value is E
                BEQ     addD1               *add D1 to the register list
                CMP.B   #13,D7              *if value is D
                BEQ     addD2               *add D2 to the register list
                CMP.B   #12,D7              *if value is C
                BEQ     addD3               *add D3 to the register list
                CMP.B   #11,D7              *if value is B
                BEQ     addD4               *add D4 to the register list
                CMP.B   #10,D7              *if value is A
                BEQ     addD5               *add D5 to the register list
                CMP.B   #9,D7               *if value is 9
                BEQ     addD6               *add D6 to the register list
                CMP.B   #8,D7               *if value is 8
                BEQ     addD7               *add D7 to th register list
                CMP.B   #7,D7               *if value is 7
                BEQ     addA0               *add A0 to the register list
                CMP.B   #6,D7               *if value is 6
                BEQ     addA1               *add A1 to the register list
                CMP.B   #5,D7               *if value is 5
                BEQ     addA2               *add A2 to the register list
                CMP.B   #4,D7               *if value is 4
                BEQ     addA3               *add A3 to the register list
                CMP.B   #3,D7               *if value is 3
                BEQ     addA4               *add A4 to the register list
                CMP.B   #2,D7               *if value is 2
                BEQ     addA5               *add A5 to the register list
                CMP.B   #1,D7               *if value is 1
                BEQ     addA6               *add A6 to the register list
                CMP.B   #0,D7               *if value is 0
                BEQ     addA7               *add A7 to the register list
                BRA     INVALID             *invalid instruction
addA7           MOVE.B  #'A',(A4)+ * A
                MOVE.B  #$07,D1
                JSR     EncodeChar
                MOVE.B  #'/',(A4)+ * /
                SUB.B   #1,D7
                RTS
addA6           MOVE.B  #'A',(A4)+ * A
                MOVE.B  #$06,D1
                JSR     EncodeChar
                MOVE.B  #'/',(A4)+ * /
                SUB.B   #1,D7
                RTS
addA5           MOVE.B  #'A',(A4)+ * A
                MOVE.B  #$05,D1
                JSR     EncodeChar
                MOVE.B  #'/',(A4)+ * /
                SUB.B   #1,D7
                RTS
addA4           MOVE.B  #'A',(A4)+ * A
                MOVE.B  #$04,D1
                JSR     EncodeChar
                MOVE.B  #'/',(A4)+ * /
                SUB.B   #1,D7
                RTS
addA3           MOVE.B  #'A',(A4)+ * A
                MOVE.B  #$03,D1
                JSR     EncodeChar
                MOVE.B  #'/',(A4)+ * /
                SUB.B   #1,D7
                RTS
addA2           MOVE.B  #'A',(A4)+ * A
                MOVE.B  #$02,D1
                JSR     EncodeChar
                MOVE.B  #'/',(A4)+ * /
                SUB.B   #1,D7
                RTS
addA1           MOVE.B  #'A',(A4)+ * A
                MOVE.B  #$01,D1
                JSR     EncodeChar
                MOVE.B  #'/',(A4)+ * /
                SUB.B   #1,D7
                RTS
addA0           MOVE.B  #'A',(A4)+ * A
                MOVE.B  #$00,D1
                JSR     EncodeChar
                MOVE.B  #'/',(A4)+ * /
                SUB.B   #1,D7
                RTS
addD7           MOVE.B  #'D',(A4)+ * D
                MOVE.B  #$07,D1
                JSR     EncodeChar
                MOVE.B  #'/',(A4)+ * /
                SUB.B   #1,D7
                RTS
addD6           MOVE.B  #'D',(A4)+ * D
                MOVE.B  #$06,D1
                JSR     EncodeChar
                MOVE.B  #'/',(A4)+ * /
                SUB.B   #1,D7
                RTS
addD5           MOVE.B  #'D',(A4)+ * D
                MOVE.B  #$05,D1
                JSR     EncodeChar
                MOVE.B  #'/',(A4)+ * /
                SUB.B   #1,D7
                RTS
addD4           MOVE.B  #'D',(A4)+ * D
                MOVE.B  #$04,D1
                JSR     EncodeChar
                MOVE.B  #'/',(A4)+ * /
                SUB.B   #1,D7
                RTS
addD3           MOVE.B  #'D',(A4)+ * D
                MOVE.B  #$03,D1
                JSR     EncodeChar
                MOVE.B  #'/',(A4)+ * /
                SUB.B   #1,D7
                RTS
addD2           MOVE.B  #'D',(A4)+ * D
                MOVE.B  #$02,D1
                JSR     EncodeChar
                MOVE.B  #'/',(A4)+ * /
                SUB.B   #1,D7
                RTS
addD1           MOVE.B  #'D',(A4)+ * D
                MOVE.B  #$01,D1
                JSR     EncodeChar
                MOVE.B  #'/',(A4)+ * /
                SUB.B   #1,D7
                RTS
addD0           MOVE.B  #'D',(A4)+ * D
                MOVE.B  #$00,D1
                JSR     EncodeChar
                MOVE.B  #'/',(A4)+ * /
                SUB.B   #1,D7
                RTS
*--------------------------------------------------------------------------------

****;ADDQ p115 bit 8=0   SUBQ p285 bit 8=1
CODE0101        JSR     SPLIT       ;Bits 012 are in D5, 345 are in D4, [678 are in D3], and 91011 are in D2
                MOVE.W  D3,D1       ;move bits 8, 7, 6 into D1
                LSR.W   #2,D1       ;move bit 8 into the 0ith position (right most)

                CMP.W   #$0,D1      ;compare bit 8 to see if its a 0
                BEQ     ADDQ_SUB    ;if bit 8 is a 0, then branch to the ADDQ subroutine         
                BRA     INVALID     ;

ADDQ_SUB        MOVE.B  #'A',(A4)+  ;place ADDQ into the stack to be printed out
                MOVE.B  #'D',(A4)+  ;
                MOVE.B  #'D',(A4)+  ;
                MOVE.B  #'Q',(A4)+  ;
                MOVE.B  #'.',(A4)+  ;
                JSR     GET_LETTER
                MOVE.B  #9,(A4)+    ;
                MOVE.B  #'#',(A4)+  ;
                MOVE.W  D2,D1
                JSR     EncodeChar
                MOVE.B  #',',(A4)+  ;
                JSR     ADDQEA
                
                RTS

***TODO: DO WE NEED THIS?
SUBQ_SUB        MOVE.B  #'S',(A4)+  ;place SUBQ into the stack to be printed out
                MOVE.B  #'U',(A4)+  ;
                MOVE.B  #'B',(A4)+  ;
                MOVE.B  #'Q',(A4)+  ;
                MOVE.B  #'.',(A4)+  ;
                JSR     GET_LETTER
                RTS
                
* bits 7 and 6 determine if its a b,w,l    00 Byte   01 Word    10 Long
GET_LETTER      MOVE.W  D3,D1       ;move D3 back into D1   bits 8, 7, 6
                AND.W   #%011,D1    ;gits rid of bit 8 but keeps 7 and 6
                
                CMP.W   #$0,D1      ;if all zero's than its a byte
                BEQ     PRINT_B_SUB ;prints out a B
                CMP.W   #$1,D1      ;if its 1 than its a word
                BEQ     PRINT_W_SUB ;prints out a W
                CMP.W   #$2,D1      ;if its 2 than its a long
                BEQ     PRINT_L_SUB ;prints out a L
                RTS

PRINT_B_SUB     MOVE.B  #'B',(A4)+  ;adds the letter B to the stack to print
                MOVE.B  #0,D7       * moves size onto d7 for later use 
                RTS
PRINT_W_SUB     MOVE.B  #'W',(A4)+  ;adds the letter W to the stack to print
                MOVE.B  #1,D7       * moves size onto d7 for later use 
                RTS
PRINT_L_SUB     MOVE.B  #'L',(A4)+  ;adds the letter L to the stack to print
                MOVE.B  #2,D7       * moves size onto d7 for later use 
                RTS


*--------------------------------------------------------------------------------
CODE0110        MOVE.W  D1,D2               *manipulate data to check if this is a BRA instruction
                LSR.W   #8,D2               *
                CMP.B   #$0060,D2           *is this a BRA instruction?
                BEQ     BRAEncode           *if so, branch to BRAEncode
                CMP.B   #$67,D2             *is this a BEQ instruction?
                BEQ     BEQEncode           *if so, branch to BEQEncode
                CMP.B   #$6F,D2             *is this a BEQ instruction?
                BEQ     BLEEncode           *if so, branch to BEQEncode
                CMP.B   #$6E,D2             *is this a BEQ instruction?
                BEQ     BGTEncode           *if so, branch to BEQEncode
                BRA     INVALID
                
BRAEncode       MOVE.B  #'B',(A4)+ * B
                MOVE.B  #'R',(A4)+ * R
                MOVE.B  #'A',(A4)+ * A
                MOVE.B  #9,(A4)+ * 
                MOVE.B  #'$',(A4)+ * $
                CMP.B   #$00,D1             *is the addressing mode sixteen bits?
                BEQ     SixteenBit          *branch to sixteen
                CMP.B   #$FF,D1             *is the addressing mode thirty two bits?
                BEQ     ThirtyTwoBit        *branch to thirty two
                BRA     EightBit            *default branch to eight bit
BEQEncode       MOVE.B  #'B',(A4)+ * B
                MOVE.B  #'E',(A4)+ * R
                MOVE.B  #'Q',(A4)+ * A
                MOVE.B  #9,(A4)+ * 
                MOVE.B  #'$',(A4)+ * $
                CMP.B   #$00,D1             *is the addressing mode sixteen bits?
                BEQ     SixteenBit          *branch to sixteen
                CMP.B   #$FF,D1             *is the addressing mode thirty two bits?
                BEQ     ThirtyTwoBit        *branch to thirty two
                BRA     EightBit            *default branch to eight bit
BLEEncode       MOVE.B  #'B',(A4)+ * B
                MOVE.B  #'L',(A4)+ * L
                MOVE.B  #'E',(A4)+ * E
                MOVE.B  #9,(A4)+ * 
                MOVE.B  #'$',(A4)+ * $
                CMP.B   #$00,D1             *is the addressing mode sixteen bits?
                BEQ     SixteenBit          *branch to sixteen
                CMP.B   #$FF,D1             *is the addressing mode thirty two bits?
                BEQ     ThirtyTwoBit        *branch to thirty two
                BRA     EightBit            *default branch to eight bit
BGTEncode       MOVE.B  #'B',(A4)+ * B
                MOVE.B  #'G',(A4)+ * G
                MOVE.B  #'T',(A4)+ * T
                MOVE.B  #9,(A4)+ * 
                MOVE.B  #'$',(A4)+ * $
                CMP.B   #$00,D1             *is the addressing mode sixteen bits?
                BEQ     SixteenBit          *branch to sixteen
                CMP.B   #$FF,D1             *is the addressing mode thirty two bits?
                BEQ     ThirtyTwoBit        *branch to thirty two
                BRA     EightBit            *default branch to eight bit
EightBit        MOVE.W  D1,D2               *copy opcode word to D2
                ANDI.W  #$00FF,D1           *mask out first two characters
                LSR.W   #4,D1               *isolate first digit
                JSR     EncodeChar          *encode first digit
                MOVE.W  D2,D1               *copy over opcode word
                ANDI.W  #$000F,D1           *mask our first three characters
                LSL.W   #8,D1               *
                LSL.W   #4,D1               *
                LSR.W   #8,D1               *
                LSR.W   #4,D1               *
                JSR     EncodeChar          *encode second digit
                RTS                         *instruction decoded
SixteenBit      JSR     ReadW               *read the next word of data to D6
                JSR     AddWord             *add word to buffer
                RTS
ThirtyTwoBit    JSR     ReadL               *read the next long of data to D6
                JSR     AddLong             *add long to buffer
                RTS
*--------------------------------------------------------------------------------
CODE0111        JSR     SPLIT               *get EA information into D2 - D5
                MOVE.B  #'M',(A4)+ * M      *load text to buffer
                MOVE.B  #'O',(A4)+ * O
                MOVE.B  #'V',(A4)+ * V
                MOVE.B  #'E',(A4)+ * E
                MOVE.B  #'Q',(A4)+ * Q
                MOVE.B  #9,(A4)+ * 
                MOVE.B  #'#',(A4)+ * #
                MOVE.B  #'$',(A4)+ * $
                *manipulate bits to get data value
                LSL.B   #6,D3               *isolate bits 7 and 6
                LSL.B   #3,D4               *isolate bits 5, 4, and 3
                ADD.B   D4,D5               *add D4 to D5
                ADD.B   D3,D5               *add D3 to D5
                MOVE.W  D5,D6               *move data to D6
                MOVE.W  #$0000,D1           *clear D1
                JSR     AddByte             *add byte of data to good buffer
                
                MOVE.B  #',',(A4)+ * ,      
                MOVE.B  #'D',(A4)+ * D
                MOVE.B  D2,D1               *move data register # to D1
                JSR     EncodeChar          *add data register # to buffer     
                
                BRA     Exit
*--------------------------------------------------------------------------------

CODE1000        JSR     SPLIT           *split up last 3 digits of opcode word
                MOVE.B  #'O',(A4)+ * A
                MOVE.B  #'R',(A4)+ * N
                MOVE.B  #'.',(A4)+ * .
                CMP.B   #0,D3
                BEQ     ORDnLastByte    *Dn last byte
                CMP.B   #1,D3
                BEQ     ORDnLastWord    *Dn last word
                CMP.B   #2,D3
                BEQ     ORDnLastLong    *Dn last long
                CMP.B   #4,D3
                BEQ     ORDnFirstByte   *Dn first byte
                CMP.B   #5,D3
                BEQ     ORDnFirstWord   *Dn first word
                CMP.B   #6,D3
                BEQ     ORDnFirstLong   *Dn first long
                BRA     INVALID         *invalid instruction
ORDnLastByte    MOVE.B  #'B',(A4)+ * B
                MOVE.B  #9,(A4)+   * tab
                MOVE.B  #1,D7           *move size to D7
                MOVE.B  D4,D0           *move mode info to D0
                MOVE.B  D5,D1           *move register info to D1
                JSR     ORDecodeEAPart  *decode EA
                MOVE.B  #',',(A4)+ * ,
                JSR     ORDecodeREGPart *decode REG
                RTS
ORDnLastWord    MOVE.B  #'W',(A4)+ * W
                MOVE.B  #9,(A4)+   * tab
                MOVE.B  #3,D7           *move size to D7
                MOVE.B  D4,D0           *move mode info to D0
                MOVE.B  D5,D1           *move register info to D1
                JSR     ORDecodeEAPart  *decode EA
                MOVE.B  #',',(A4)+ * ,
                JSR     ORDecodeREGPart *decode REG
                RTS
ORDnLastLong    MOVE.B  #'L',(A4)+ * L
                MOVE.B  #9,(A4)+   * tab
                MOVE.B  #2,D7           *move size to D7
                MOVE.B  D4,D0           *move mode info to D0
                MOVE.B  D5,D1           *move register info to D1
                JSR     ORDecodeEAPart  *decode EA
                MOVE.B  #',',(A4)+ * ,
                JSR     ORDecodeREGPart *decode REG
                RTS
ORDnFirstByte   MOVE.B  #'B',(A4)+ * B
                MOVE.B  #9,(A4)+   * tab
                JSR     ORDecodeREGPart *decode REG
                MOVE.B  #',',(A4)+ * ,
                MOVE.B  #1,D7           *move size to D7
                MOVE.B  D4,D0           *move mode info to D0
                MOVE.B  D5,D1           *move register info to D1
                JSR     ORDecodeEAPart  *decode EA
                RTS
ORDnFirstWord   MOVE.B  #'W',(A4)+ * W
                MOVE.B  #9,(A4)+   * tab
                JSR     ORDecodeREGPart *decode REG
                MOVE.B  #',',(A4)+ * ,
                MOVE.B  #3,D7           *move size to D7
                MOVE.B  D4,D0           *move mode info to D0
                MOVE.B  D5,D1           *move register info to D1
                JSR     ORDecodeEAPart  *decode EA
                RTS
ORDnFirstLong   MOVE.B  #'L',(A4)+ * L
                MOVE.B  #9,(A4)+   * tab
                JSR     ORDecodeREGPart *decode REG
                MOVE.B  #',',(A4)+ * ,
                MOVE.B  #2,D7           *move size to D7
                MOVE.B  D4,D0           *move mode info to D0
                MOVE.B  D5,D1           *move register info to D1
                JSR     ORDecodeEAPart  *decode EA
                RTS
ORDecodeEAPart  CMP.B   #0,D0           *Dn?
                BEQ     Dn
                CMP.B   #2,D0           *(An)?
                BEQ     AnIndirect
                CMP.B   #3,D0           *(An)+?
                BEQ     AnIncrement
                CMP.B   #4,D0           *-(An)?
                BEQ     AnDecrement
                CMP.B   #7,D0           *abs word/long, imm?
                BEQ     CheckReg
                BRA     INVALID
ORDecodeREGPart MOVE.B  #'D',(A4)+ * D
                MOVE.B  D2,D1           *move reg # to D1
                JSR     EncodeChar      *add register number to buffer
                RTS
                
*--------------------------------------------------------------------------------


*SUB p278       SUBA p281       SUBX p288       (not subi, not subq)
* for now I am only going to do SUB.
CODE1001        JSR     SPLIT       ;Bits 012 are in D5, 345 are in D4, 678 are in D3, and 9,10,11 are in D2
                MOVE.B  #'S',(A4)+  ;place SUB into the stack to be printed out
                MOVE.B  #'U',(A4)+  ;
                MOVE.B  #'B',(A4)+  ;
                JSR     OR_OPMOD_TABLE
                RTS
               
                
OR_OPMOD_TABLE MOVE.W  D3,D1        ;move D3 back into D1   bits 8, 7, 6
                CMP.W   #$0,D1      ;if its 0 (000) than its a Byte    Dn - <ea>  -> Dn
                BEQ     B_EADN ;
                CMP.W   #$1,D1      ;if its 1 (001) than its a Word    Dn - <ea>  -> Dn
                BEQ     W_EADN ;
                CMP.W   #$2,D1      ;if its 2 (010) than its a Long    Dn - <ea>  -> Dn
                BEQ     L_EADN ;
                
                CMP.W   #$4,D1      ;if its 4 (100) than its a Bite    <ea> -Dn -> <ea>
                BEQ     B_DNEA ;
                CMP.W   #$5,D1      ;if its 5 (101) than its a Word    <ea> -Dn -> <ea>
                BEQ     W_DNEA ;
                CMP.W   #$6,D1      ;if its 6 (110) than its a Long    <ea> -Dn -> <ea>
                BEQ     L_DNEA ;
                
                CMP.W   #$7,D1      ;if its 7 (111) than its an error
                BRA     INVALID
                CMP.W   #$3,D1      ;if its 3 (011) than its an error
                BRA     INVALID
                RTS
        
*****NOT USED ****************************************************                
EA_JUMPTABLE    JSR     SPLIT       ;Bits 012 are in D5, [345 are in D4], 678 are in D3, and 9,10,11 are in D2
                MOVE.W  D4,D1       ;move the EA mode bits into D1
                CMP.W   #$0,D1      ;000 means Dn
                BEQ     EA_000      ;
                CMP.W   #$1,D1      ;001 means An
                BEQ     EA_001      ;
                CMP.W   #$2,D1      ;010 means (An)
                BEQ     EA_010      ;
                CMP.W   #$3,D1      ;011 means (An)+
                BEQ     EA_011      ;
                CMP.W   #$4,D1      ;100 means -(An)
                BEQ     EA_100      ;
                CMP.W   #$7,D1      ;111 means it could be (xxx).W  (xxx).L  or #<data>  depending on register
                BEQ     EA_111      ;
                RTS
                
EA_000          *MOVE.B  #'Dn',(A4)+ ;Add Dn to the stack to print
                *MOVE.W  D5,D1       ;move the EA register bitrs into D1
                *MOVE.B  #D1,(A4)+   ;move the number contained in D1 to the A4 stack   //not sure if this is correct???  xxxxxxxxxx
                RTS

EA_001          RTS
EA_010          RTS
EA_011          RTS
EA_100          RTS

    
EA_111          MOVE.W  D5,D1       ;move the EA register bitrs into D1
                CMP.W   #$0,D1      ;(xxx).W
                *BEQ     xxxxx       ; branch to something that will print out (xxx).W   ???????xxxxxxx
                
                RTS

*--------------------------------------------------------------------------------
CODE1100        JSR     SPLIT           *split up last 3 digits of opcode word
                MOVE.B  #'A',(A4)+ * A
                MOVE.B  #'N',(A4)+ * N
                MOVE.B  #'D',(A4)+ * D
                MOVE.B  #'.',(A4)+ * .
                CMP.B   #0,D3
                BEQ     DnLastByte      *Dn last byte
                CMP.B   #1,D3
                BEQ     DnLastWord      *Dn last word
                CMP.B   #2,D3
                BEQ     DnLastLong      *Dn last long
                CMP.B   #4,D3
                BEQ     DnFirstByte     *Dn first byte
                CMP.B   #5,D3
                BEQ     DnFirstWord     *Dn first word
                CMP.B   #6,D3
                BEQ     DnFirstLong     *Dn first long
                BRA     INVALID         *invalid instruction
DnLastByte      MOVE.B  #'B',(A4)+ * B
                MOVE.B  #9,(A4)+   * tab
                MOVE.B  #1,D7           *move size to D7
                MOVE.B  D4,D0           *move mode info to D0
                MOVE.B  D5,D1           *move register info to D1
                JSR     DecodeEAPart    *decode EA
                MOVE.B  #',',(A4)+ * ,
                JSR     DecodeREGPart   *decode REG
                RTS
DnLastWord      MOVE.B  #'W',(A4)+ * W
                MOVE.B  #9,(A4)+   * tab
                MOVE.B  #3,D7           *move size to D7
                MOVE.B  D4,D0           *move mode info to D0
                MOVE.B  D5,D1           *move register info to D1
                JSR     DecodeEAPart    *decode EA
                MOVE.B  #',',(A4)+ * ,
                JSR     DecodeREGPart   *decode REG
                RTS
DnLastLong      MOVE.B  #'L',(A4)+ * L
                MOVE.B  #9,(A4)+   * tab
                MOVE.B  #2,D7           *move size to D7
                MOVE.B  D4,D0           *move mode info to D0
                MOVE.B  D5,D1           *move register info to D1
                JSR     DecodeEAPart    *decode EA
                MOVE.B  #',',(A4)+ * ,
                JSR     DecodeREGPart   *decode REG
                RTS
DnFirstByte     MOVE.B  #'B',(A4)+ * B
                MOVE.B  #9,(A4)+   * tab
                JSR     DecodeREGPart   *decode REG
                MOVE.B  #',',(A4)+ * ,
                MOVE.B  #1,D7           *move size to D7
                MOVE.B  D4,D0           *move mode info to D0
                MOVE.B  D5,D1           *move register info to D1
                JSR     DecodeEAPart    *decode EA
                RTS
DnFirstWord     MOVE.B  #'W',(A4)+ * W
                MOVE.B  #9,(A4)+   * tab
                JSR     DecodeREGPart   *decode REG
                MOVE.B  #',',(A4)+ * ,
                MOVE.B  #3,D7           *move size to D7
                MOVE.B  D4,D0           *move mode info to D0
                MOVE.B  D5,D1           *move register info to D1
                JSR     DecodeEAPart    *decode EA
                RTS
DnFirstLong     MOVE.B  #'L',(A4)+ * L
                MOVE.B  #9,(A4)+   * tab
                JSR     DecodeREGPart   *decode REG
                MOVE.B  #',',(A4)+ * ,
                MOVE.B  #2,D7           *move size to D7
                MOVE.B  D4,D0           *move mode info to D0
                MOVE.B  D5,D1           *move register info to D1
                JSR     DecodeEAPart    *decode EA
                RTS
DecodeEAPart    CMP.B   #0,D0           *Dn?
                BEQ     Dn
                CMP.B   #2,D0           *(An)?
                BEQ     AnIndirect
                CMP.B   #3,D0           *(An)+?
                BEQ     AnIncrement
                CMP.B   #4,D0           *-(An)?
                BEQ     AnDecrement
                CMP.B   #7,D0           *abs word/long, imm?
                BEQ     CheckReg
                BRA     INVALID
DecodeREGPart   MOVE.B  #'D',(A4)+ * D
                MOVE.B  D2,D1           *move reg # to D1
                JSR     EncodeChar      *add register number to buffer
                RTS
                
*--------------------------------------------------------------------------------

*This was removed, not sure if that was a mistake, or is there something wrong with the below code
;with this code it is ADDA or ADD (both are technically just ADD)       p108
*ADDA if the destination is an Address register
CODE1101        JSR     SPLIT       ;Bits 012 are in D5, 345 are in D4, 678 are in D3, and 9,10,11 are in D2
                MOVE.W  D3,D1       ;move bits 8, 7, 6 into D1
                
                *MOVE.B  #' ',(A4)+  ;
                *MOVE.B  #' ',(A4)+  ;
                MOVE.B  #'A',(A4)+  ;
                MOVE.B  #'D',(A4)+  ;
                MOVE.B  #'D',(A4)+  ;
                JSR     ADD_OPMOD_TABLE
                RTS

ADD_OPMOD_TABLE MOVE.W  D3,D1       ;move bits 8, 7, 6 into D1

                CMP.W   #$0,D1      ;if its 0 (000) than its a Byte    <ea> + Dn -> Dn   
                BEQ     B_EADN  ;
                CMP.W   #$1,D1      ;if its 1 (001) than its a Word    <ea> + Dn -> Dn   
                BEQ     W_EADN  ;
                CMP.W   #$2,D1      ;if its 2 (010) than its a Long    <ea> + Dn -> Dn   
                BEQ     L_EADN  ;
                
                CMP.W   #$4,D1      ;if its 4 (100) than its a Bite    Dn + <ea> -> <ea>
                BEQ     B_DNEA  ;
                CMP.W   #$5,D1      ;if its 5 (101) than its a Word    Dn + <ea> -> <ea>
                BEQ     W_DNEA  ;
                CMP.W   #$6,D1      ;if its 6 (110) than its a Long    Dn + <ea> -> <ea>
                BEQ     L_DNEA  ;
                
                CMP.W   #$3,D1      ;if its 3 (011) than its an ADDA WORD
                BEQ     ADDA_W
                CMP.W   #$7,D1      ;if its 7 (111) than its an ADDA Long 
                BEQ     ADDA_L
                BRA     INVALID
                RTS

* TODO: temporary headers to prevent error messages on compilation 
B_EADN          MOVE.B  #'.',(A4)+  ;
                MOVE.B  #'B',(A4)+  ;
                MOVE.B  #9,(A4)+  ;tab
                MOVE.W  #0,D7               *signify what size instruction is in the case of reading extra memory
                JSR     EADN
                RTS
                
W_EADN          MOVE.B  #'.',(A4)+  ;
                MOVE.B  #'W',(A4)+  ;
                MOVE.B  #9,(A4)+  ;tab
                MOVE.W  #1,D7               *signify what size instruction is in the case of reading extra memory
                JSR     EADN
                RTS        
         
L_EADN          MOVE.B  #'.',(A4)+  ;
                MOVE.B  #'L',(A4)+  ;
                MOVE.B  #9,(A4)+  ;tab
                MOVE.W  #2,D7               *signify what size instruction is in the case of reading extra memory
                JSR     EADN
                RTS            
     
B_DNEA          MOVE.B  #'.',(A4)+  ;
                MOVE.B  #'B',(A4)+  ;
                MOVE.B  #9,(A4)+  ;tab
                MOVE.W  #0,D7               *signify what size instruction is in the case of reading extra memory
                JSR     DNEA
                RTS
                
W_DNEA          MOVE.B  #'.',(A4)+  ;
                MOVE.B  #'W',(A4)+  ;
                MOVE.B  #9,(A4)+  ;tab
                MOVE.W  #1,D7               *signify what size instruction is in the case of reading extra memory
                JSR     DNEA
                RTS
                
L_DNEA          MOVE.B  #'.',(A4)+  ;
                MOVE.B  #'L',(A4)+  ;
                MOVE.B  #9,(A4)+  ;tab
                MOVE.W  #2,D7               *signify what size instruction is in the case of reading extra memory
                JSR     DNEA
                RTS

EADN            JSR     ADDEA
                MOVE.B  #',',(A4)+  ;
                MOVE.B  #'D',(A4)+  ;
                MOVE.W  D2,D1
                JSR     EncodeChar
                RTS

DNEA            MOVE.B  #'D',(A4)+  ;
                MOVE.W  D2,D1
                JSR     EncodeChar
                MOVE.B  #',',(A4)+  ;
                JSR     ADDSRC
                RTS

ADDA_W          MOVE.B  #'A',(A4)+  ;
                MOVE.B  #'.',(A4)+  ;
                MOVE.B  #'W',(A4)+  ;
                MOVE.B  #9,(A4)+  ;tab
                MOVE.W  #1,D7               *signify what size instruction is in the case of reading extra memory
                JSR     ADDSRC
                MOVE.B  #',',(A4)+  ;
                MOVE.B  #'A',(A4)+  ;
                MOVE.W  D2,D1
                JSR     EncodeChar
                RTS
                
ADDA_L          MOVE.B  #'A',(A4)+  ;
                MOVE.B  #'.',(A4)+  ;
                MOVE.B  #'L',(A4)+  ;
                MOVE.B  #9,(A4)+  ;tab
                MOVE.W  #2,D7               *signify what size instruction is in the case of reading extra memory
                JSR     ADDSRC
                MOVE.B  #',',(A4)+  ;
                MOVE.B  #'A',(A4)+  ;
                MOVE.W  D2,D1
                JSR     EncodeChar
                RTS

* Decodes source of Add commands
* Assumes that Split has been called before this and D2-D5 are correct
ADDSRC          MOVE.W  D4,D0               *move bits to proper position
                MOVE.W  D5,D1               *
                CMP.B   #2,D0               *2?
                BEQ     AnIndirect          *address register indirect
                CMP.B   #3,D0               *3?
                BEQ     AnIncrement         *address register with post increment
                CMP.B   #4,D0               *4?
                BEQ     AnDecrement         *address register with pre decrement
                CMP.B   #7,D0               *7?
                BEQ     CheckReg            *branch for further checking, either absolute or immediate data
                BRA     INVALID

* Decodes source of Add commands
* Assumes that Split has been called before this and D2-D5 are correct
ADDQEA          MOVE.W  D4,D0               *move bits to proper position
                MOVE.W  D5,D1               *
                CMP.B   #0,D0               *0?
                BEQ     Dn                  *data register
                CMP.B   #1,D0               *1?
                BEQ     An                  *address register
                CMP.B   #2,D0               *2?
                BEQ     AnIndirect          *address register indirect
                CMP.B   #3,D0               *3?
                BEQ     AnIncrement         *address register with post increment
                CMP.B   #4,D0               *4?
                BEQ     AnDecrement         *address register with pre decrement
                CMP.B   #7,D0               *7?
                BEQ     CheckRegAbs         *branch for further checking, either absolute or immediate data
                BRA     INVALID
                
* Decodes source of AddA commands
* Assumes that Split has been called before this and D2-D5 are correct
ADDEA           MOVE.W  D4,D0               *move bits to proper position
                MOVE.W  D5,D1               *
                CMP.B   #0,D0               *0?
                BEQ     Dn                  *data register
                CMP.B   #1,D0               *1?
                BEQ     An                  *address register
                CMP.B   #2,D0               *2?
                BEQ     AnIndirect          *address register indirect
                CMP.B   #3,D0               *3?
                BEQ     AnIncrement         *address register with post increment
                CMP.B   #4,D0               *4?
                BEQ     AnDecrement         *address register with pre decrement
                CMP.B   #7,D0               *7?
                BEQ     CheckRegAbs         *branch for further checking, either absolute or immediate data
                BRA     INVALID
                    
*print_binary    RTS            ;Can we reuse from  CODE1001  line 940-965 (can change)  ???


                ;TODO: make sure the A is getting printed in the latter part of things
                RTS

*--------------------------------------------------------------------------------
CODE1110        ;LSL LSR ASL ASR ROL ROR
                ;first thing to check is if it's a memory shift/rotate
                ;we know whether it is from bits 6-7: if they're 11 it's a memory shift
                MOVE.W D1, D0
                AND.W #%0000000011000000, D0
                CMP.W #%0000000011000000, D0
                BEQ MEM_SHFT
                ;Since we have passed the break for memory shifting it is now a register shift/rotate
                ;You check which instruction it is now with bits 3 and 4
                MOVE.W D1, D0 ;restore to d0 the original instruction  
                AND.W #%0000000000011000, D0
                CMP.W #%0000000000001000, D0
                BEQ   LSL_LSR
                CMP.W #%0000000000000000, D0
                BEQ   ASL_ASR
                CMP.W #%0000000000011000, D0
                BEQ   ROL_ROR
                BRA   INVALID
                
MEM_SHFT        NOP ;In a mem shifted one we know which instruction it is from bits 9-11
                MOVE.W D1, D0 ;restore to d0 the original instruction  
                AND.W #%0000011000000000, D0
                CMP.W #%0000001000000000, D0
                BEQ   LSL_LSR
                CMP.W #%0000000000000000, D0
                BEQ   ASL_ASR
                CMP.W #%0000011000000000, D0
                BEQ   ROL_ROR
                BRA   INVALID ;if it's made it through everything it's now invalid
LSL_LSR         MOVE.B  #'L',(A4)+
                MOVE.B  #'S',(A4)+
                BRA     L_OR_R_1110
                
ASL_ASR         MOVE.B  #'A',(A4)+
                MOVE.B  #'S',(A4)+     
                BRA     L_OR_R_1110 

ROL_ROR         MOVE.B  #'R',(A4)+
                MOVE.B  #'O',(A4)+     
                BRA     L_OR_R_1110  
                
                
L_OR_R_1110     MOVE.W  D1, D0 ;restore to d0 the original instruction
                AND.W   #%0000000100000000, D0
                CMP.W   #%0000000100000000, D0 ;If the bit we're checking for is 1 it's left
                BEQ     LFT_DIRECTION
                MOVE.B  #'R',(A4)+
                JSR     SHIFTTable
                * SUB.B   #'/',-(A4)          * workaround to remove / and allow code reuse TODO: be sure this is fine
                RTS
                
LFT_DIRECTION   MOVE.B  #'L',(A4)+
                JSR     SHIFTTable
                * SUB.B   #'/',-(A4)          * workaround to remove / and allow code reuse TODO: be sure this is fine                               
                RTS
*--------------------------------------------------------------------------------



*BELOW IS THE EA JUMP TABLE FOR DECODING MOVE,MOVEA, AND MOVEQ INSTRUCTIONS 
*--------------------------------------------------------------------------------
*assumtions: 
* - D0 contains Mode
* - D1 contains Register
* - D7 contains length of instruction (1:byte,2:word,3:long) in decimal in the
*      case of needing to read in an immediate data
MOVETable           CMP.B   #0,D0               *0?
                    BEQ     Dn                  *data register
                    CMP.B   #1,D0               *1?
                    BEQ     An                  *address register
                    CMP.B   #2,D0               *2?
                    BEQ     AnIndirect          *address register indirect
                    CMP.B   #3,D0               *3?
                    BEQ     AnIncrement         *address register with post increment
                    CMP.B   #4,D0               *4?
                    BEQ     AnDecrement         *address register with pre decrement
                    CMP.B   #7,D0               *7?
                    BEQ     CheckReg            *branch for further checking, either absolute or immediate data
                    BRA     INVALID
Dn                  MOVE.B  #'D',(A4)+          * D
                    JSR     EncodeChar          *encode register # at D1 and add to good buffer
                    CMP.B   #7,D1               *is the data register greater than 7?
                    BGT     INVALID             *if so, invalid instruction
                    RTS
An                  MOVE.B  #'A',(A4)+          * A
                    JSR     EncodeChar          *encode register # at D1 and add to good buffer
                    CMP.B   #7,D1               *is the data register greater than 7?
                    BGT     INVALID             *if so, invalid instruction
                    RTS
AnIndirect          MOVE.B  #'(',(A4)+          * (
                    MOVE.B  #'A',(A4)+          * A
                    JSR     EncodeChar          *encode register # at D1 and add to good buffer
                    MOVE.B  #')',(A4)+          * )
                    CMP.B   #7,D1               *is the data register greater than 7?
                    BGT     INVALID             *if so, invalid instruction
                    RTS
AnIncrement         MOVE.B  #'(',(A4)+          * (
                    MOVE.B  #'A',(A4)+          * A
                    JSR     EncodeChar          *encode register # at D1 and add to good buffer
                    MOVE.B  #')',(A4)+          * )
                    MOVE.B  #'+',(A4)+          * +
                    CMP.B   #7,D1               *is the data register greater than 7?
                    BGT     INVALID             *if so, invalid instruction
                    RTS
AnDecrement         MOVE.B  #'-',(A4)+          * -
                    MOVE.B  #'(',(A4)+          * (
                    MOVE.B  #'A',(A4)+          * A
                    JSR     EncodeChar          *encode register # at D1 and add to good buffer
                    MOVE.B  #')',(A4)+          * )
                    CMP.B   #7,D1               *is the data register greater than 7?
                    BGT     INVALID             *if so, invalid instruction
                    RTS                         *exit subroutine
CheckReg            CMP.B   #0,D1               *are we dealing with an absolute word of data? 
                    BEQ     ReadAbsWord         *yes
                    CMP.B   #1,D1               *are we dealing with an absolute long of data?
                    BEQ     ReadAbsLong         *yes
                    CMP.B   #4,D1               *are we dealing with an immediate data of either word or long?
                    BEQ     ReadImmediate       *yes
                    BRA     INVALID
CheckRegAbs         CMP.B   #0,D1               *are we dealing with an absolute word of data? 
                    BEQ     ReadAbsWord         *yes
                    CMP.B   #1,D1               *are we dealing with an absolute long of data?
                    BEQ     ReadAbsLong         *yes
                    BRA     INVALID
ReadAbsWord         JSR     READW               *read next word of data to D6
                    MOVE.B  #'$',(A4)+          * $
                    JSR     AddWord             *add that next word of data to good buffer
                    RTS
ReadAbsLong         JSR     READL               *read next long of data to D7
                    MOVE.B  #'$',(A4)+          * $
                    JSR     AddLong             *add that next long of data to good buffer
                    RTS
ReadImmediate       CMP.B   #1,D7               *is the instruction size byte?
                    BEQ     ReadImmWord         *yes, so read next word of data
                    CMP.B   #3,D7               *is the instruction size word?
                    BEQ     ReadImmWord         *yes, so read next word of data
                    CMP.B   #2,D7               *is the instruction size long?
                    BEQ     ReadImmLong         *yes, so read next long of data
ReadImmWord         JSR     READW               *read the next word in memory to D6
                    MOVE.B  #'#',(A4)+          * #
                    MOVE.B  #'$',(A4)+          * $
                    JSR     AddWord             *add that next word of data to good buffer
                    RTS
ReadImmLong         JSR     READL               *read the next long in memory to D6
                    MOVE.B  #'#',(A4)+          * #
                    MOVE.B  #'$',(A4)+          * $
                    JSR     AddLong             *add that next long of data to good buffer
                    RTS
                    
                    
*BELOW IS THE EA JUMP TABLE FOR DECODING LSL, LSR, ROL, ROR, ASL, AND ASR INSTRUCTIONS 
*--------------------------------------------------------------------------------
*assumptions: 
* - D0 contains Mode
* - D1 contains Register
* - D7 contains the original opcode 

SHIFTTable      JSR     SPLIT
                JSR     SHIFTSIZE
                RTS  

*this subroutine is used to read the contents of a DN shifting opcode
SHIFTDN         JSR     COUNT
                JSR     DREG
                SUB.B   #'/',-(A4)
                RTS
                
*this subroutine is used to read the contents of an AN shifting opcode
SHIFTAN         MOVE.B  #'.',(A4)+ * .
                MOVE.B  #'W',(A4)+ * W
                MOVE.B  #9,(A4)+   * tab
                MOVE.W  #2,D7               *signify what size instruction is in the case of reading extra memory
                MOVE.W  D4,D0               *move bits to proper position
                MOVE.W  D5,D1               *
                JSR     SHIFTEA     
                RTS

*this subroutine is used to identify the size of a command
SHIFTSIZE       MOVE.B  D3,D0
                AND.B   #3,D0
                CMP.B   #0,D0   
                BEQ     SBYTE
                CMP.B   #1,D0
                BEQ     SWORD
                CMP.B   #2,D0
                BEQ     SLONG  
                BRA     SHIFTAN              

SBYTE           MOVE.B  #'.',(A4)+ * .
                MOVE.B  #'B',(A4)+ * B
                MOVE.B  #9,(A4)+   * tab
                JSR     SHIFTDN
                RTS

SWORD           MOVE.B  #'.',(A4)+ * .
                MOVE.B  #'W',(A4)+ * W
                MOVE.B  #9,(A4)+   * tab
                JSR     SHIFTDN
                RTS

SLONG           MOVE.B  #'.',(A4)+ * .
                MOVE.B  #'L',(A4)+ * L
                MOVE.B  #9,(A4)+   * tab
                JSR     SHIFTDN
                RTS

*assumtions: 
* - D0 contains Mode
* - D1 contains Register
* - D7 contains length of instruction (1:byte,2:word,3:long) in decimal in the
*      case of needing to read in an immediate data
SHIFTEA         CMP.B   #2,D0               *2?
                BEQ     AnIndirect          *address register indirect
                CMP.B   #3,D0               *3?
                BEQ     AnIncrement         *address register with post increment
                CMP.B   #4,D0               *4?
                BEQ     AnDecrement         *address register with pre decrement
                CMP.B   #7,D0               *7?
                BEQ     CheckRegAbs         *branch for further checking, either absolute or immediate data
                BRA     INVALID

*this subroutine identifies register or immediate shift count 
COUNT           MOVE.W  D4, D0 ;restore to d0 the original instruction  
                AND.W   #%100, D0
                CMP.W   #%000, D0
                BEQ     COUNTFIELD
                CMP.W   #%100, D0
                BEQ     COUNTREG

*The count refers to the literal value to shift by 
COUNTFIELD      MOVE.B  #'#',(A4)+          *#    
                MOVE.W  D2,D1
                JSR     EncodeChar
                MOVE.B  #',',(A4)+          *,
                RTS 

*The count refers to a data register where the count is stored 
COUNTREG        MOVE.B  #'D',(A4)+          *#    
                MOVE.W  D2,D1
                JSR     EncodeChar
                MOVE.B  #',',(A4)+          *,
                RTS 
                RTS

* Identifies the desired data register 
* assumptions: 
* D5 contains the data register number
DREG            CMP.W   #0,D5 
                BEQ     addD0
                CMP.W   #1,D5 
                BEQ     addD1
                CMP.W   #2,D5
                BEQ     addD2 
                CMP.W   #3,D5
                BEQ     addD3
                CMP.W   #4,D5 
                BEQ     addD4
                CMP.W   #5,D5
                BEQ     addD5 
                CMP.W   #6,D5
                BEQ     addD6
                CMP.W   #7,D5
                BEQ     addD7
                RTS

*BELOW ARE EA UTILITY SUBROUTINES
*--------------------------------------------------------------------------------
*this subroutine splits the last 3 digits of the opcode word into 4 integers that will be
*stored at D2,D3,D4,D5
SPLIT       MOVE.W  D1,D2               *copy opcode word into D2 - D5
            MOVE.W  D2,D3               *
            MOVE.W  D3,D4               *
            MOVE.W  D4,D5               *
            LSL.W   #4,D2               *isolate D2
            LSR.W   #8,D2               *
            LSR.W   #4,D2               *
            LSL.W   #4,D3               *isolate D3
            LSR.W   #8,D3               *
            LSL.W   #8,D4               *isolate D4
            LSR.W   #8,D4               *
            LSL.W   #8,D5               *isolate D5
            LSL.W   #4,D5               *
            LSR.W   #8,D5               *
            LSR.W   #4,D5               *
            LSR.B   #1,D2               *calculate D2
            LSL.B   #5,D5               *calculate D5
            LSR.B   #5,D5               *
            MOVE.B  D3,D6               *calculate D3
            MOVE.B  D3,D7               *
            LSR.B   #4,D6               *
            LSL.B   #4,D7               *
            LSR.B   #4,D7               *
            LSL.B   #7,D6               *
            LSR.B   #5,D6               *
            LSR.B   #2,D7               *
            ADD.B   D6,D7               *
            MOVE.B  D7,D3               *
            MOVE.B  D4,D6               *calculate D4
            MOVE.B  D4,D7               *
            LSR.B   #4,D6               *
            LSL.B   #4,D7               *
            LSR.B   #4,D7               *
            LSL.B   #6,D6               *
            LSR.B   #5,D6               *
            LSR.B   #3,D7               *
            ADD.B   D6,D7               *
            MOVE.B  D7,D4               *
            RTS
*used to read the next word of data in memory and store in D6
READW       ADD     #1,A2               *now pointing to next byte in memory
            MOVE.B  (A2),D6             *store first byte in D6
            LSL.L   #8,D6               *move those bytes to the left 2 digits
            ADD     #1,A2               *now pointing to next byte in memory
            MOVE.B  (A2),D6             *get next byte
            RTS                         *next word now stored in D6
*used to read the next long of data in memory and store in D6
READL       ADD     #1,A2               *now pointing to next byte in memory
            MOVE.B  (A2),D6             *store first byte in D6
            LSL.L   #8,D6               *move those bytes to the left 2 digits
            ADD     #1,A2               *now pointing to next byte in memory
            MOVE.B  (A2),D6             *get next byte
            LSL.L   #8,D6               *move those bytes to the left 2 digits
            ADD     #1,A2               *now pointing to next byte in memory
            MOVE.B  (A2),D6             *get next byte
            LSL.L   #8,D6               *move those bytes to the left 2 digits
            ADD     #1,A2               *now pointing to next byte in memory
            MOVE.B  (A2),D6             *get next byte
            RTS                         *next long now stored in D6
*used to add a byte of hex stored at D6 to the good buffer at A4
AddByte     MOVE.B  D6,D1               *copy byte of data to D1
            LSR.B   #4,D1               *isolate first digit
            JSR     EncodeChar          *add first char to buffer
            MOVE.B  D6,D1               *copy byte of data to D1
            LSL.B   #4,D1               *isolate second digit
            LSR.B   #4,D1               *
            JSR     EncodeChar          *add second char to buffer
            RTS
*used to add a word of hex stored at D6 to the good buffer at A4
AddWord     MOVE.W  D6,D1               *copy word of data to D1
            LSR.W   #8,D1               *manipulate D1 to hold only first char
            LSR.W   #4,D1               *
            JSR     EncodeChar          *encode and add to good buffer
            MOVE.W  D6,D1               *copy word of data to D1
            LSL.W   #4,D1               *manipulate D1 to hold only second char
            LSR.W   #8,D1               *
            LSR.W   #4,D1               *
            JSR     EncodeChar          *encode and add to good buffer
            MOVE.W  D6,D1               *copy word of data to D1
            LSL.W   #8,D1               *manipulate D1 to hold only third char
            LSR.W   #8,D1               *
            LSR.W   #4,D1               *
            JSR     EncodeChar          *encode and add to good buffer
            MOVE.W  D6,D1               *copy word of data to D1
            LSL.W   #8,D1               *manipulate D1 to hold only fourth char
            LSL.W   #4,D1               *
            LSR.W   #8,D1               *
            LSR.W   #4,D1               *
            JSR     EncodeChar          *encode and add to good buffer
            RTS                         *exit subroutine
*used to add a long of hex stored at D6 to the good buffer at A4
AddLong     ROR.L   #8,D6               *move first word of long to end of D6
            ROR.L   #8,D6               *
            MOVE.W  D6,D1               *move first word to D1
            JSR     AddWord             *encode and add word to good buffer
            ROR.L   #8,D6               *move second word of long to end of D6
            ROR.L   #8,D6               *
            MOVE.W  D6,D1               *move second word to D1
            JSR     AddWord             *encode and add word to good buffer
            RTS                         *exit
*used to encode a hex character into a 
EncodeChar  CMP.B #$A,D1    * is the character an A - F?
            BGE alphaTwo    * yes
            ADDI.B #48,D1   * encode decimal to convert to ascii decimal
            JSR writechar   * write to the good buffer
            SUBI.B #48,D1 
            RTS
            
alphaTwo    ADDI.B #55,D1   * encode to make this an alphabetic ascii char
            JSR writechar   * write to the good buffer
            SUBI.B #55,D1 
            RTS
            
writechar   MOVE.B D1,(A4)+ * write to the good buffer
            RTS             * exit subroutine   
 
*-----------------Bad Buffer Loading-------------------------------------------------           
*used to add a word of hex stored at D6 to the good buffer at A4
BAddWord    MOVE.W  D6,D1               *copy word of data to D1
            LSR.W   #8,D1               *manipulate D1 to hold only first char
            LSR.W   #4,D1               *
            JSR     BEncodeChar          *encode and add to good buffer
            MOVE.W  D6,D1               *copy word of data to D1
            LSL.W   #4,D1               *manipulate D1 to hold only second char
            LSR.W   #8,D1               *
            LSR.W   #4,D1               *
            JSR     BEncodeChar          *encode and add to good buffer
            MOVE.W  D6,D1               *copy word of data to D1
            LSL.W   #8,D1               *manipulate D1 to hold only third char
            LSR.W   #8,D1               *
            LSR.W   #4,D1               *
            JSR     BEncodeChar          *encode and add to good buffer
            MOVE.W  D6,D1               *copy word of data to D1
            LSL.W   #8,D1               *manipulate D1 to hold only fourth char
            LSL.W   #4,D1               *
            LSR.W   #8,D1               *
            LSR.W   #4,D1               *
            JSR     BEncodeChar          *encode and add to good buffer
            RTS                         *exit subroutine
            
*used to encode a hex character into a 
BEncodeChar CMP.B #$A,D1    * is the character an A - F?
            BGE BalphaTwo    * yes
            ADDI.B #48,D1   * encode decimal to convert to ascii decimal
            BRA Bwritechar   * write to the good buffer
BalphaTwo   ADDI.B #55,D1   * encode to make this an alphabetic ascii char
            BRA Bwritechar   * write to the good buffer
Bwritechar  MOVE.B D1,(A5)+ * write to the good buffer
            RTS             * exit subroutine   
*--------------------------------------------------------------------------------
MEMStart        DC.W        $0000                                                                   *start memory address
MEMEnd          DC.W        $0000                                                                   *end memory address
OPCode          DC.W        $0000                                                                   *used for storing opcode word for printing
MoveMData       DC.W        $0000                                                                   *used to hold register list data
CR              EQU         $0D                                                                     *carriage return
LF              EQU         $0A                                                                     *line feed
MESSAGE1        DC.B        'Enter addresses in hexadecimal using all caps. Ex: AE1D, FF3F',CR,LF,0 *formatting message
PROMPT1         DC.B        'Enter starting memory address: $',0                                    *start memory prompt
PROMPT2         DC.B        'Enter ending memory address: $',0                                      *end memory prompt
RESTART_PROMPT  DC.B        'Restart? (Y/N): ',0                                                    *prompt to restart or end
NEXT_PG_PROMPT  DC.B        '--- PRESS ANY KEY FOR NEXT PAGE ---', CR, LF, 0                        *displays with each page of output
INVALID_ADDR    DC.B        'Invalid address entry. Try again.', CR, LF, 0                          *input checking failure alert


LINES_PER_SCRN  DC.W        30                                                                      *number of lines to print to the screen per page
CUR_PRNTD_LNS   DC.W        $0                                                                      *stores current lines printed this page

MIN_ADDR        DC.W        $1000
MAX_ADDR        DC.W        $7FFF


DOWNLINE        DC.B        '',CR,LF,0                                                              *printable carriage return
SPACE           DC.B        ' ',0                                                                   *printable space
GOOD_BUFFER     DC.B        160                                                                     *this is the buffer we will append our decoded information to for a successful decoding
BAD_BUFFER      DC.B        160                                                                     *this buffer will contain XXXXXXXX DATA YYYY for display on a failed decoding
INVALID_PTR     DC.B        160                                                                     *this variable is used to signify if our instruction is invalid                
                END         START                                                                   *last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
