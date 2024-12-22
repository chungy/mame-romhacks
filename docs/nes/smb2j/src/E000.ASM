
HurrahMsg =  $61a2  ;in 6000.asm
ThankYouMessageFinal = HurrahMsg+20

                $ =  $E000
VRAM_AddrTable:
                .WORD $0301
                .WORD $6B8D ;palette
                .WORD $6BB1 ;palette
                .WORD $6BD5 ;palette
                .WORD $6BF9 ;palette
                .WORD $C62B ;? (1 tile) (bank0)
                .word $341
                .word $341
                .WORD $6C35 ;palette
                .WORD $6C1D ;palette
                .WORD $6C25 ;palette
                .WORD $6C2D ;palette
                .WORD $6C3D ;thank you mario!
                .WORD $6C51 ;but our princess is in
                .WORD $C876 ;??
                .WORD $C87F ;palette data
                .WORD ThankYouMessageFinal      ;thank you mario
                .WORD $C8AB ;peace is paved
                .WORD $C8C1 ;with kingdom saved
		        .WORD HurrahMsg ;hurrah to mario/luigi
                .WORD $C8EB ;our only hero
                .WORD $C8FC ;this ends your trip
                .WORD $C913 ;of a long friendship
                .WORD $C92B ;100000 pts added
                .WORD $C943 ;for each player left
                .WORD $C149 ;(clear 8 tiles from 21E6)
                .WORD $C10B ;(palette data)
                .WORD $C95C ;? (script?)
                .WORD $1E8  ;mushroom placement on char select
                .WORD $C97D ;we present fantasy world
                .WORD $C9C0 ;? (script?)
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
                .pad $e149
smalldelay:                         ; E1F3p
                PHA     
                LDA     #$16
                SEC     
smd0:                               ; smalldelay+6j
                SBC     #1
                BCS     smd0
                PLA     
                RTS     
; End of function smalldelay
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; API: wait ~1790*Y cycles
; (0=256)
delay:                              ; delay+Bj seek0+5p seek0+8p seek0+10p
                                    ; startblockread+2p writeblockstart+Bp
                                    ; readHVC+5p readHVC+Ap
                LDX     0           ; 3
                LDX     #$FE        ; 2
del0:                               ; delay+6j
                NOP                 ; 2
                DEX                 ; 2
                BNE     del0        ; 3
                CMP     0           ; 3
                DEY                 ; 2
                BNE     delay       ; 3
                RTS     
; End of function delay
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; BG+OBJ off
screenoff:                          ; parseheader+1Bp sub_0_F3FAp
                                    ; copyrightcheckp
                LDA     $FE
                AND     #11100111b
sco0:                               ; screenon+4j OBJoff+4j OBJon+4j
                                    ; BGoff+4j BGon+4j
                STA     $FE
                STA     $2001
                RTS     
; End of function screenoff
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; BG+OBJ on
screenon:                           ; EF04p
                LDA     $FE
                ORA     #11000b
                BNE     sco0
; End of function screenon
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
OBJoff:                             ; EF46p
                LDA     $FE
                AND     #11101111b
                JMP     sco0
; End of function OBJoff
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
OBJon:
                LDA     $FE
                ORA     #10000b
                BNE     sco0
; End of function OBJon
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
BGoff:                              ; EFD7p
                LDA     $FE
                AND     #11110111b
                JMP     sco0
; End of function BGoff
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
BGon:                               ; EF97p EFB9p F565p F5CAp
                LDA     $FE
                ORA     #1000b
                BNE     sco0
; End of function BGon
nmi:                                ; F8D7w FAFBw FFFAo
                BIT     $100
                BPL     loc_0_E198
                BVC     loc_0_E195
                JMP     ($DFFA)
loc_0_E195:                         ; E190j
                JMP     ($DFF8)
loc_0_E198:                         ; E18Ej
                BVC     waitVBL2    ; nmiflags=$00
                JMP     ($DFF6)
waitVBL2:                           ; E198j
                LDA     $FF         ; nmiflags=$00
                AND     #$7F        ; nmi off
                STA     $FF
                STA     $2000
                LDA     $2002
                PLA     
                PLA     
                PLA     
                PLA                 ; restore nmiflags
                STA     $100
                PLA                 ; restore A
                RTS                 ; return from waitVBL
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; wait for vblank with NMI
waitNMI:                            ; EF49p EF8Ep EFB3p sub_0_F3FA+2Ep
                                    ; copyrightcheck+Bp F4D5p F55Fp F5C1p
                PHA     
                LDA     $100
                PHA     
                LDA     #0
                STA     $100        ; nmiflags=$00:
                                    ; return from nmi via waitVBL2
                LDA     $FF
                ORA     #$80        ; nmi enable
                STA     $FF
                STA     $2000
wv0:                                ; waitNMI+13j
                BNE     wv0
; End of function waitNMI
irq:                                ; FFFEo
                BIT     $101
                BMI     irqC0
                BVC     irq00
irq40:                              ; irqflags=$40
                LDX     $4031
                STA     $4024
                PLA     
                PLA     
                PLA     
                TXA                 ; X,A=val
                RTS                 ; return from readbyte
irq00:                              ; E1CCj
                PHA                 ; irqflags=$00
                LDA     $101
                SEC     
                SBC     #1
                BCC     i001        ; read disk while irqflags>0
                STA     $101
                LDA     $4031
i001:                               ; E1E0j
                PLA     
                RTI     
irqC0:                              ; E1CAj
                BVC     irq80       ; irqflags=$C0
                JMP     ($DFFE)
irq80:                              ; E1EAj
                PHA                 ; irqflags=$80
              ;  LDA     $4030
              nop
              nop
              nop
                JSR     smalldelay
                PLA     
                RTI     
loaddisk:                           ; EF59p
                SEI                 ; API: (..)
                                    ; return with A=err
                LDA     #-1
loc_0_E1FB:                         ; put next word in tmp0
                JSR     readsetup   ; if A=$FF, put 2nd word in tmp2
                                    ; else put A in tmp2
                                    ; on err return with Y=tmpE, A=errcode
                                    ; setup tmp4 for error* functions
                JSR     switchCXXXandCHR
                LDA     #0
                CLI     
                RTS     
                .BYTE    0 ;  
                .BYTE  $60 ; `
                .BYTE  $A2 ; Ђ
                .BYTE    4 ;  
ldd0:           .BYTE  $D0 ; а      ; E210j
                .BYTE  $F1 ; ё
                .BYTE  $E2 ; т
                BEQ     ldd1
                DEC     5
                BNE     ldd0        ; retry
ldd1:                               ; E20Cj
                PLA     
                STA     $101
                LDY     $E
                TXA                 ; A=errorcode
                RTS     
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; return with X=errcode
; X=0, Z=1 on success
; 
readwholedisk:
                JSR     initID      ; reset disk, read past ID stuff
                                    ; tmp8=preload#
                JSR     gettotalblocks ; read block type 2 into totalblocks
                LDA     6
                BEQ     rwd1
rwd0:                               ; readwholedisk+17j
                LDA     #3          ; now process each block
                JSR     startblockread ; A=block ID (1-4)
                                    ; abort if wrong ID read (err code $22+#)
                JSR     readblockfluff ; advance disk ptr past block name
                                    ; decide if this block should be loaded
                                    ; exit with tmp9=0 and tmpE++ if it should be read
                                    ; (tmp2) is a list of valid block types
                JSR     loadblock   ; if tmp9>0, skip block?
                DEC     6           ; dec block count
                BNE     rwd0
rwd1:                               ; readwholedisk+8j
                JSR     diskstop    ; stop disk op
                                    ; return with no error (X=0)
                RTS     
; End of function readwholedisk

;----------------
.pad $E237
IRQHandler:     ;moved from $61A2
		SEI	
		PHP	
		PHA	
		TXA	
		PHA	
		TYA	
		PHA	
        JSR tinydelay
		PHA	
		AND	#2
		BNE	loc_0_61DD
		PLA	
		AND	#1
		BEQ	loc_0_61E1
		LDA	$778
               ; AND     #$f7 ; 'ї'      ;clear sprite set
               ora #$08 ;set sprite set
		ORA	$77A
		STA	$778
		STA	$2000
		LDA	#0
        sta $e000 ;JSR     $FAB5 ;timerstop
		LDA	$73F
		STA	$2005
		LDA	$740
		STA	$2005
		LDA	#0
		STA	$77B
		JMP	loc_0_61E1
loc_0_61DD:				; CODE XREF: seg000:61AFj
		PLA	
        JSR smalldelay
loc_0_61E1:				; CODE XREF: seg000:61B4j seg000:61DAj
		PLA	
		TAY	
		PLA	
		TAX	
		PLA	
		PLP	
		CLI	
		RTI	

;----------------
.pad $E2F7
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; reset disk and read totalblocks
readtotal:                          ; deleteblocks+13p
                JSR     initID      ; reset disk, read past ID stuff
                                    ; tmp8=preload#
                JSR     gettotalblocks ; read block type 2 into totalblocks
                JSR     diskstop    ; stop disk op
                                    ; return with no error (X=0)
                RTS     
; End of function readtotal

                .pad $E32A ;-----

; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; API: get directory listing (see dir:)
; (next word)=buffer
; returns with Z,A=error status
getdiskinfo:
                LDA     #0
                JSR     readsetup   ; put next word in tmp0
                                    ; if A=$FF, put 2nd word in tmp2
                                    ; else put A in tmp2
                                    ; on err return with Y=tmpE, A=errcode
                                    ; setup tmp4 for error* functions
                LDA     $101
                PHA     
                LDA     #2          ; 2 tries
                STA     5
gdi0:                               ; getdiskinfo+14j
                JSR     dir         ; read dir info into (tmp0)
                                    ; format: 
                                    ;   (10) disk header (from makerID to add.3)
                                    ;   (1) total blocks
                                    ;   ...
                                    ;   (1) preload#
                                    ;   (8) name
                                    ;   ...
                                    ;   (2) used disk space (msb,lsb)
                                    ;       (only counting header3 blocks)
                BEQ     gdi1
                DEC     5
                BNE     gdi0
gdi1:                               ; getdiskinfo+10j
                PLA     
                STA     $101
                TXA                 ; err code
                RTS     
; End of function getdiskinfo
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; read dir info into (tmp0)
; format: 
;   (10) disk header (from makerID to add.3)
;   (1) total blocks
;   ...
;   (1) preload#
;   (8) name
;   ...
;   (2) used disk space (msb,lsb)
;       (only counting header3 blocks)
dir:                                ; getdiskinfo+Dp
                JSR     readHVC     ; reset disk, verify '*NINTENDO-HVC*'
                LDA     0
                STA     $A
                LDA     1
                STA     $B
                LDY     #0
                STY     2           ; tmp2,3=used disk space
                STY     3
dir0:                               ; dir+19j
                JSR     nextRW      ; (read/write) A
                STA     ($A),Y      ; store next 10 bytes
                INY     
                CPY     #10
                BNE     dir0
                JSR     addAB       ; tmpAB+=Y
                LDY     #31         ; read to end of block
dir1:                               ; dir+24j
                JSR     nextRW      ; (read/write) A
                DEY     
                BNE     dir1
                JSR     readfinish  ; end of block (skip 2 bytes)
                JSR     gettotalblocks ; read block type 2 into totalblocks
                LDY     #0
                LDA     6
                STA     ($A),Y      ; store total blocks
                BEQ     dir4
dir2:                               ; dir+83j
                LDA     #3
                JSR     startblockread ; A=block ID (1-4)
                                    ; abort if wrong ID read (err code $22+#)
                JSR     nextRW      ; skip block#
                JSR     nextRW      ; (read/write) A
                LDY     #1
                STA     ($A),Y      ; store preload#
dir3:                               ; dir+4Bj
                INY     
                JSR     nextRW      ; store name..
                STA     ($A),Y
                CPY     #9
                BNE     dir3
                JSR     addAB       ; tmpAB+=Y
                JSR     nextRW      ; skip addr
                JSR     nextRW      ; ..
                CLC                 ; tmp2,3+=$0105 (bug?)
                                    ; (header3+header4+4 extra=$0015)
                LDA     #5
                ADC     2
                STA     2
                LDA     #1
                ADC     3
                STA     3
                JSR     nextRW      ; tmpC,D=size
                STA     $C
                JSR     nextRW      ; ..
                STA     $D
                CLC                 ; tmp2,3+=tmpC,D
                LDA     $C
                ADC     2
                STA     2
                LDA     $D
                ADC     3
                STA     3
                LDA     #$FF        ; read past block
                STA     9
                JSR     ldb1
                DEC     6
                BNE     dir2
dir4:                               ; dir+32j
                LDA     3           ; store used disk space
                LDY     #1
                STA     ($A),Y
                LDA     2
                INY     
                STA     ($A),Y
                JSR     diskstop    ; stop disk op
                                    ; return with no error (X=0)
                RTS     
; End of function dir
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; tmpAB+=Y
addAB:                              ; dir+1Bp dir+4Dp
                TYA     
                CLC     
                ADC     $A
                STA     $A
                LDA     #0
                ADC     $B
                STA     $B
                RTS     
; End of function addAB
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; put next word in tmp0
; if A=$FF, put 2nd word in tmp2
; else put A in tmp2
; on err return with Y=tmpE, A=errcode
; setup tmp4 for error* functions
readsetup:                          ; E1FBp getdiskinfo+2p
                SEC     
                BCS     wset0
writesetup:                         ; saveN+4p deleteblocks+4p sub_0_E305+4p
                CLC                 ; see readsetup
                                    ; also abort on write protect
wset0:                              ; readsetup+1j
                TSX     
                DEX     
                STX     4           ; tmp4 holds old SP?
                PHP                 ; save carry
                STA     2           ; tmp2=A
                LDY     $104,X
                STY     5           ; tmp5=caller addr
                LDY     $105,X
                STY     6
                TAX     
                LDY     #1
                LDA     (5),Y
                STA     0
                INY     
                LDA     (5),Y
                STA     1           ; tmp0 holds first word
                LDA     #2
                CPX     #$FF
                BNE     wset1
                INY     
                LDA     (5),Y       ; tmp2 holds next word
                STA     2
                INY     
                LDA     (5),Y
                STA     3
                LDA     #4
wset1:                              ; readsetup+25j
                LDX     4           ; A holds bytes to skip ahead for RTS
                CLC     
                ADC     5
                STA     $104,X
                LDA     #0
                ADC     6
                STA     $105,X      ; move return addr past words
                PLP                 ; get carry
                RTS     
                .BYTE    1 ;  
                LDA     $4032
                AND     #1
                BNE     wset2       ; no disk
                BCS     wset3
                LDX     #3          ; err#3: write protect
                LDA     $4032
                AND     #100b       ; write protect?
                BEQ     wset3
wset2:                              ; readsetup+4Aj
                PLA                 ; no disk
                PLA     
                LDY     $E
                TXA     
                CLI     
wset3:                              ; readsetup+4Cj readsetup+55j
                RTS     
; End of function readsetup
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; reset disk, read past ID stuff
; tmp8=preload#
initID:                             ; readwholediskp writeblockp verifywritep
                                    ; restoretotalp readtotalp
                JSR     readHVC     ; reset disk, verify '*NINTENDO-HVC*'
                LDX     #4
                STX     8           ; header section/err code
                LDY     #0
idi0:                               ; initID+2Cj
                JSR     nextRW      ; verify disk ID
                CMP     (0),Y       ; ID in (tmp0)
                BEQ     idi2
                LDX     8
                CPX     #$A         ; (errcode $09->$10)
                BNE     idi1
                LDX     #$10
idi1:                               ; initID+14j
                LDA     (0),Y
                CMP     #$FF        ; ok if called from reset
                                    ; (first time)
                JSR     errorZ      ; abort disk op if Z=0
                                    ; X=err code
                                    ; returns to ?
idi2:                               ; initID+Ej
                INY     
                CPY     #1
                BEQ     idi3
                CPY     #5          ; don't advance errcode
                BCC     idi4        ; if this is game ID
idi3:                               ; initID+22j
                INC     8
idi4:                               ; initID+26j
                CPY     #$A
                BNE     idi0
                JSR     nextRW      ; (read/write) A
                STA     8           ; preload#
                LDY     #30         ; skip 30 bytes
idi5:                               ; initID+39j
                JSR     nextRW      ; (read/write) A
                DEY     
                BNE     idi5
                JSR     readfinish  ; end of block (skip 2 bytes)
                RTS     
; End of function initID
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; read block type 2 into totalblocks
gettotalblocks:                     ; readwholedisk+3p writeblock+9p
                                    ; readtotal+3p dir+29p
                LDA     #2
                JSR     startblockread ; A=block ID (1-4)
                                    ; abort if wrong ID read (err code $22+#)
                JSR     nextRW      ; (read/write) A
                STA     6
                JSR     readfinish  ; end of block (skip 2 bytes)
                RTS     
; End of function gettotalblocks
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; write block type 2 (total blocks)
; A=#blocks
writetotal:                         ; writeblock+1Fp verifywrite+7p
                                    ; restoretotal+5p
                PHA     
                LDA     #2
                JSR     writeblockstart ; A=block type
                PLA     
                JSR     nextRW      ; (read/write) A
                JSR     writefinish ; end of block (skip 2 bytes)
                RTS     
; End of function writetotal
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; advance disk ptr past block name
; decide if this block should be loaded
; exit with tmp9=0 and tmpE++ if it should be read
; (tmp2) is a list of valid block types
readblockfluff:                     ; readwholedisk+Fp
                JSR     nextRW      ; (read/write) A
                JSR     nextRW      ; X=
                LDA     #8
                STA     $101        ; skip block name
                CLI     
                LDY     #0
                LDA     (2),Y
                CMP     #$FF        ; if list is empty, load boot blocks
                BEQ     rbf2
rbf0:                               ; readblockfluff+22j
                TXA     
                CMP     (2),Y
                BEQ     rbf3
                INY     
                CPY     #20         ; max list size
                BEQ     rbf1
                LDA     (2),Y
                CMP     #$FF        ; $FF terminates list
                BNE     rbf0
rbf1:                               ; readblockfluff+1Cj
                LDA     #$FF
                BNE     rbf4
rbf2:                               ; readblockfluff+12j
                CPX     8           ; if X>tmp8, skip block
                BEQ     rbf3
                BCS     rbf4
rbf3:                               ; readblockfluff+17j readblockfluff+2Aj
                LDA     #0
                INC     $E
rbf4:                               ; readblockfluff+26j readblockfluff+2Cj
                STA     9
rbf9:                               ; readblockfluff+37j
                LDA     $101        ; wait til name is skipped
                BNE     rbf9
                RTS     
; End of function readblockfluff
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; read past (totalblocks) data blocks
seek:                               ; writeblock+Cp verifywrite+Ap
                LDA     6           ; get count
                STA     8           ; set count
                BEQ     sek2
sek0:                               ; seek+1Cj
                LDA     #3
                JSR     startblockread ; A=block ID (1-4)
                                    ; abort if wrong ID read (err code $22+#)
                LDY     #10
sek1:                               ; seek+11j
                JSR     nextRW      ; (read/write) A
                DEY     
                BNE     sek1
                LDA     #$FF        ; (force skip)
                STA     9
                JSR     loadblock   ; if tmp9>0, skip block?
                DEC     8
                BNE     sek0
sek2:                               ; seek+4j
                RTS     
; End of function seek
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; if tmp9>0, skip block?
loadblock:                          ; readwholedisk+12p seek+17p
                LDY     #0
ldb0:                               ; loadblock+Bj
                JSR     beginRW     ; irq on+(read/write) A
                STA     $A,Y        ; tmpA=address
                                    ; tmpC=size
                INY     
                CPY     #4
                BNE     ldb0
ldb1:                               ; dir+7Ep
                JSR     decCD
                JSR     nextRW      ; (read/write) A
                PHA                 ; save data type
                JSR     readfinish  ; end of block (skip 2 bytes)
                LDA     #4
                JSR     startblockread ; A=block ID (1-4)
                                    ; abort if wrong ID read (err code $22+#)
                LDY     9
                PLA                 ; get type
                BNE     ldb6        ; VRAM data
                CLC     
                LDA     $A
                ADC     $C
                LDA     $B
                ADC     $D          ; don't copy data if..
                BCS     ldb2        ;   addr+size>$FFFF
                LDA     $B
                CMP     #$20
                BCS     ldb3
                AND     #7
                CMP     #2
                BCS     ldb3        ;   or addr<$0200
ldb2:                               ; loadblock+2Aj
                LDY     #$FF
ldb3:                               ; loadblock+30j loadblock+36j
                                    ; loadblock+4Cj
                JSR     nextRW      ; (read/write) A
                CPY     #0
                BNE     ldb5
                STA     ($A),Y      ; if Y!=0 don't copy to RAM
                INC     $A
                BNE     ldb5
                INC     $B          ; inc addr
ldb5:                               ; loadblock+3Fj loadblock+45j
                JSR     decCD       ; dec count
                BCS     ldb3
                BCC     ldb4        ; done reading
ldb6:                               ; loadblock+1Fj
                CPY     #0          ; if Y>0, skip ahead
                BNE     ldb7        ; (dont need to set VADDR)
                LDA     $FE
                AND     #11100111b  ; screen off
                STA     $FE
                STA     $2001
                LDA     $2002
                LDA     $B
                STA     $2006
                LDA     $A
                STA     $2006
ldb7:                               ; loadblock+52j loadblock+77j
                JSR     nextRW      ; (read/write) A
                CPY     #0
                BNE     ldb8
                STA     $2007
ldb8:                               ; loadblock+6Fj
                JSR     decCD
                BCS     ldb7
ldb4:                               ; loadblock+4Ej
                LDA     9           ; done reading
                BNE     ldb9        ; block skipped?
                JSR     readfinish  ; end of block (skip 2 bytes)
                RTS     
ldb9:                               ; loadblock+7Bj
                JSR     nextRW      ; (read/write) A
                JSR     nextRW      ; (read/write) A
                JMP     blockdone
; End of function loadblock
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; get addr+size from header in (tmp2),
; store in tmpA/C,
; and ready PPU for VRAM read
parseheader:                        ; writeverifyblock+30p
                                    ; writeverifyblock+64p
                LDY     #11         ; size
                LDA     (2),Y
                STA     $C
                INY     
                LDA     (2),Y
                STA     $D
                LDY     #14         ; addr
                LDA     (2),Y
                STA     $A
                INY     
                LDA     (2),Y
                STA     $B
                INY     
                LDA     (2),Y
                BEQ     phd0
                JSR     screenoff   ; BG+OBJ off
                LDA     $2002
                LDA     $B
                STA     $2006
                LDA     $A
                STA     $2006
                LDA     $2007
phd0:                               ; parseheader+19j
                JSR     decCD
                RTS     
; End of function parseheader
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; (tmp2) points to block header+data
; if A>0, compare file with (tmp2)
; else write (tmp2)
writeverifyblock:                   ; writeblock+16p verifywrite+14p
                STA     9           ; verify if tmp9>0
                LDA     6
                JSR     nextRW      ; file#
                LDX     9
                BEQ     wvb0
                LDX     #$26        ; err26=saving error
                CMP     6
                JSR     errorZ      ; abort disk op if Z=0
                                    ; X=err code
                                    ; returns to ?
wvb0:                               ; writeverifyblock+9j
                LDY     #0          ; do block header:
wvb1:                               ; writeverifyblock+27j
                LDA     (2),Y
                JSR     nextRW      ; (read/write) A
                LDX     9
                BEQ     wvb2
                LDX     #$26
                CMP     (2),Y
                JSR     errorZ      ; abort disk op if Z=0
                                    ; X=err code
                                    ; returns to ?
wvb2:                               ; writeverifyblock+1Bj
                INY     
                CPY     #14
                BNE     wvb1
                LDX     9
                BEQ     wvb6
                JSR     readfinish  ; end of block (skip 2 bytes)
                JSR     parseheader ; get addr+size from header in (tmp2),
                                    ; store in tmpA/C,
                                    ; and ready PPU for VRAM read
                LDA     #4
                JSR     startblockread ; A=block ID (1-4)
                                    ; abort if wrong ID read (err code $22+#)
wvb3:                               ; writeverifyblock+6Cj
                LDY     #16
                LDA     (2),Y       ; data type
                BNE     wvb7
                LDY     #0
                LDX     9
                BEQ     wvb5
wvb4:                               ; writeverifyblock+51j
                JSR     nextRW      ; (read/write) A
                LDX     #$26
                CMP     ($A),Y
                JSR     errorZ      ; abort disk op if Z=0
                                    ; X=err code
                                    ; returns to ?
                JSR     incABdecCD
                BCS     wvb4
                BCC     wvb9
wvb5:                               ; writeverifyblock+42j
                                    ; writeverifyblock+5Dj
                LDA     ($A),Y
                JSR     nextRW      ; (read/write) A
                JSR     incABdecCD
                BCS     wvb5
                BCC     wvb9
wvb6:                               ; writeverifyblock+2Bj
                JSR     writefinish ; end of block (skip 2 bytes)
                JSR     parseheader ; get addr+size from header in (tmp2),
                                    ; store in tmpA/C,
                                    ; and ready PPU for VRAM read
                LDA     #4
                JSR     writeblockstart ; A=block type
                JMP     wvb3
wvb7:                               ; writeverifyblock+3Cj
                                    ; writeverifyblock+81j
                LDX     9
                BEQ     wvb10
                JSR     nextRW      ; (read/write) A
                LDX     #$26
                CMP     $2007
                JSR     errorZ      ; abort disk op if Z=0
                                    ; X=err code
                                    ; returns to ?
wvb8:                               ; writeverifyblock+91j
                JSR     decCD
                BCS     wvb7
wvb9:                               ; writeverifyblock+53j
                                    ; writeverifyblock+5Fj
                LDX     9
                BEQ     wvb11
                JSR     readfinish  ; end of block (skip 2 bytes)
                RTS     
wvb10:                              ; writeverifyblock+71j
                LDA     $2007
                JSR     nextRW      ; (read/write) A
                JMP     wvb8
wvb11:                              ; writeverifyblock+85j
                JSR     writefinish ; end of block (skip 2 bytes)
                RTS     
; End of function writeverifyblock
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; prep drive:
; turn drive on, seek to 0, wait for drive ready
; abort if power low
seek0:                              ; readHVCp
                JSR     driveinit
                LDY     #0          ; (~1/2 second)
                JSR     delay       ; API: wait ~1790*Y cycles
                                    ; (0=256)
                JSR     delay       ; API: wait ~1790*Y cycles
                                    ; (0=256)
                JSR     startmotor
                LDY     #$96        ; (~1/8 second)
                JSR     delay       ; API: wait ~1790*Y cycles
                                    ; (0=256)
                LDA     $F9
                ORA     #$80
                STA     $F9
                STA     $4026       ; ??
                LDX     #2          ; err code: low power
                EOR     $4033
                ROL     A
                JSR     errorC      ; abort on low power
                JSR     driveinit
                JSR     startmotor
sk0:                                ; seek0+35j
                LDX     #1          ; wait for drive ready
                LDA     $4032
                LSR     A
                JSR     errorC      ; abort disk op if C=1
                                    ; X=err code
                                    ; returns to ?
                LSR     A
                BCS     sk0         ; wait for drive ready
                RTS     
; End of function seek0
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
driveinit:                          ; seek0p seek0+25p
                LDA     $FA
                AND     #1000b      ; keep mirror
                ORA     #100110b    ; begin seek to pos. 0
                STA     $4025

                RTS     
; End of function driveinit
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; A=block ID (1-4)
; abort if wrong ID read (err code $22+#)
startblockread:                     ; readwholedisk+Cp verifywrite+Fp dir+36p
                                    ; gettotalblocks+2p seek+8p loadblock+19p
                                    ; writeverifyblock+35p readHVC+Fp
                LDY     #5
                JSR     delay       ; API: wait ~1790*Y cycles
                                    ; (0=256)
                STA     7           ; save ID
                CLC     
                ADC     #$21
                TAY                 ; Y=err code (22+)
                LDA     $FA
                ORA     #$40        ; begin disk op
                STA     $FA
                STA     $4025
            
                JSR     beginRW     ; irq on+(read/write) A
                PHA     
                TYA     
                TAX     
                PLA     
                CMP     7
                JSR     errorZ      ; check for correct val
                RTS     
; End of function startblockread
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; A=block type
writeblockstart:                    ; writeblock+11p writetotal+3p
                                    ; writeverifyblock+69p
                LDY     #10
                STA     7
                LDA     $FA
                AND     #101011b    ; disk write
                STA     $4025

                JSR     delay       ; API: wait ~1790*Y cycles
                                    ; (0=256)
                LDY     #0
                STY     $4024
                ORA     #$40        ; disk op begin
                STA     $FA
                STA     $4025
                LDA     #$80
                JSR     beginRW     ; irq on+(read/write) A
                LDA     7
                JSR     nextRW      ; (read/write) A
                RTS     
; End of function writeblockstart
nintendo_hvc:   .BYTE '*CVH-ODNETNIN*' ; readHVC+19r
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; reset disk, verify '*NINTENDO-HVC*'
readHVC:                            ; dirp initIDp
                JSR     seek0       ; prep drive:
                                    ; turn drive on, seek to 0, wait for drive ready
                                    ; abort if power low
                LDY     #$C5        ; ~1/4 sec
                JSR     delay       ; API: wait ~1790*Y cycles
                                    ; (0=256)
                LDY     #$46
                JSR     delay       ; API: wait ~1790*Y cycles
                                    ; (0=256)
                LDA     #1
                JSR     startblockread ; A=block ID (1-4)
                                    ; abort if wrong ID read (err code $22+#)
                LDY     #13
rhd0:                               ; readHVC+20j
                JSR     nextRW      ; (read/write) A
                LDX     #$21        ; err#21
                CMP     nintendo_hvc,Y
                JSR     errorZ      ; abort disk op if Z=0
                                    ; X=err code
                                    ; returns to ?
                DEY     
                BPL     rhd0
                RTS     
; End of function readHVC
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; end of block (skip 2 bytes)
readfinish:                         ; dir+26p initID+3Bp gettotalblocks+Ap
                                    ; loadblock+14p loadblock+7Dp
                                    ; writeverifyblock+2Dp
                                    ; writeverifyblock+87p
                JSR     nextRW      ; (read/write) A
                LDX     #$28        ; err#28
                LDA     $4030
                AND     #$40
                BNE     error_       ; abort disk op
                                    ; X=err code
                                    ; returns to ?
                LDA     $FA
                ORA     #$10        ; ?
                STA     $FA
                STA     $4025
                JSR     nextRW      ; (read/write) A
                LDX     #$27        ; err#27
                LDA     $4030
                AND     #$10        ; ?
                BNE     error_       ; abort disk op
                                    ; X=err code
                                    ; returns to ?
                BEQ     blockdone
; End of function readfinish
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; end of block (skip 2 bytes)
writefinish:                        ; writetotal+Ap writeverifyblock+61p
                                    ; writeverifyblock+94p
                JSR     nextRW      ; (read/write) A
                LDX     #$29        ; err#29
                LDA     $4030
                AND     #$40
                BNE     error_       ; abort disk op
                                    ; X=err code
                                    ; returns to ?
                LDA     $FA
                ORA     #$10
                STA     $FA
                STA     $4025
                LDX     #$B2
wf0:                                ; writefinish+18j
                DEX     
                BNE     wf0
                LDX     #$30        ; err#30
                LDA     $4032
                AND     #2
                BNE     error_       ; abort disk op
                                    ; X=err code
                                    ; returns to ?
blockdone:                          ; loadblock+87j readfinish+21j
                                    ; sub_0_E761+14j
                LDA     $FA
                AND     #101111b
                ORA     #100b       ; read flag
                STA     $FA
                STA     $4025
                LDX     #1          ; err#1: no disk
                LDA     $4032
                LSR     A           ; look for disk
                JSR     errorC      ; abort disk op if C=1
                                    ; X=err code
                                    ; returns to ?
                RTS     
; End of function writefinish
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; ??? (similar to writefinish)
sub_0_E761:
                JSR     nextRW      ; (read/write) A
                STA     ($A),Y
                LDX     #$28
                LDA     $4030
                AND     #$40
                BNE     error_       ; abort disk op
                                    ; X=err code
                                    ; returns to ?
                INY     
                JSR     nextRW      ; (read/write) A
                STA     ($A),Y
                JMP     blockdone
; End of function sub_0_E761
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; stop disk op
; return with no error (X=0)
diskstop:                           ; readwholedisk+19p writeblock+19p
                                    ; verifywrite+17p restoretotal+8p
                                    ; readtotal+6p dir+90p
                LDX     #0
                BEQ     erc1        ; X=err code
; End of function diskstop
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; abort disk op if C=1
; X=err code
; returns to ?
errorC:                             ; seek0+22p seek0+31p writefinish+34p
                BCS     error_       ; abort disk op
                                    ; X=err code
                                    ; returns to ?
erc2:                               ; errorZj
                RTS                 ; a-ok
; End of function errorC
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; abort disk op if Z=0
; X=err code
; returns to ?
errorZ:                             ; initID+1Cp writeverifyblock+Fp
                                    ; writeverifyblock+21p
                                    ; writeverifyblock+4Bp
                                    ; writeverifyblock+7Bp startblockread+1Dp
                                    ; readHVC+1Cp
                BEQ     erc2        ; a-ok
error_:                              ; readfinish+Aj readfinish+1Fj
                                    ; writefinish+Aj writefinish+21j
                                    ; sub_0_E761+Cj errorCj
                TXA                 ; abort disk op
                                    ; X=err code
                                    ; returns to ?
                LDX     4
                TXS                 ; move stack to return from readwholedisk
                TAX     
erc1:                               ; diskstop+2j
                LDA     $FA         ; X=err code
                AND     #1001b      ; keep mirror+?
                ORA     #100110b    ; ?
                STA     $FA
                STA     $4025
                TXA                 ; A=err code
                CLI     
                RTS                 ; Z=1 if no error
; End of function errorZ
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; irq on+(read/write) A
beginRW:                            ; loadblock+2p startblockread+14p
                                    ; writeblockstart+1Cp
                LDX     #$40
                STX     $101
                ROL     $FA
                SEC     
                ROR     $FA         ; disk irq enable
                LDX     $FA
                STX     $4025
nextRW:                             ; dir+11p dir+20p dir+39p dir+3Cp
                                    ; dir+44p dir+50p dir+53p dir+63p
                                    ; dir+68p initID+9p initID+2Ep
                                    ; initID+35p gettotalblocks+5p
                                    ; writetotal+7p readblockfluffp
                                    ; readblockfluff+3p seek+Dp loadblock+10p
                                    ; loadblock+3Ap loadblock+6Ap ...
                CLI                 ; (read/write) A
rb0:                                ; beginRW+10j
                JMP     rb0
; End of function beginRW
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
incABdecCD:                         ; writeverifyblock+4Ep
                                    ; writeverifyblock+5Ap
                INC     $A
                BNE     decCD
                INC     $B
decCD:                              ; loadblock+Dp loadblock+49p
                                    ; loadblock+74p parseheader+2Ep
                                    ; writeverifyblock+7Ep incABdecCD+2j
                SEC     
                LDA     $C
                SBC     #1
                STA     $C
                LDA     $D
                SBC     #0
                STA     $D
                RTS     
; End of function incABdecCD
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
vramscript:                         ; EF4Cp EF51p sub_0_F0B4+23p sub_0_F0E1p
                                    ; sub_0_F0E7p sub_0_F0EDp F0F7p
                                    ; sub_0_F179+44p sub_0_F3FA+31p
                                    ; copyrightcheck+Ep F4D8p F55Ap
                JSR     getptr      ; put word after caller in tmp0
                JMP     vc0         ; next command
vc3:                                ; vramscript+74j
                PHA                 ; keep addr for E7F9
                STA     $2006
                INY     
                LDA     (0),Y
                STA     $2006       ; set address
                INY     
                LDA     (0),Y       ; byte count+flags
                ASL     A           ; bit 7: vram increment
                PHA     
                LDA     $FF
                ORA     #4
                BCS     vc4
                AND     #11111011b
vc4:                                ; vramscript+19j
                STA     $2000
                STA     $FF
                PLA     
                ASL     A           ; bit 6: next byte is fill value
                PHP                 ; save Z
                BCC     vc5
                ORA     #10b        ; this makes C=1 later
                INY                 ; point Y to fill data
vc5:                                ; vramscript+25j
                PLP     
                CLC     
                BNE     vc6         ; C=Z
                SEC     
vc6:                                ; vramscript+2Cj
                ROR     A           ; if count=$00, count=$40
                LSR     A           ; C=1 for fill
                TAX                 ; X=count
vc7:                                ; vramscript+3Bj
                BCS     vc8
                INY     
vc8:                                ; vramscript+32j
                LDA     (0),Y
                STA     $2007
                DEX     
                BNE     vc7
                PLA     
                CMP     #$3F        ; was this palette data?
                BNE     vc9
                STA     $2006       ; wtf is this for?
                STX     $2006       ; VADDR=$3F00
                STX     $2006
                STX     $2006       ; VADDR=$0000
vc9:                                ; vramscript+40j vramscript+70j
                SEC                 ; tmp0=tmp0+Y+1
                TYA     
                ADC     0
                STA     0
                LDA     #0
                ADC     1
                STA     1
vc0:                                ; vramscript+3j vramscript+87j
                LDX     $2002       ; process next command
                LDY     #0
                LDA     (0),Y
                BPL     vc1
                RTS     
vc1:                                ; vramscript+61j
                CMP     #$60
                BNE     vc2
                PLA     
                STA     1
                PLA     
                STA     0
                LDY     #2
                BNE     vc9
vc2:                                ; vramscript+66j
                CMP     #$4C
                BNE     vc3
                LDA     0
                PHA     
                LDA     1
                PHA     
                INY     
                LDA     (0),Y
                TAX     
                INY     
                LDA     (0),Y
                STA     1
                STX     0
                BCS     vc0         ; next command
; End of function vramscript
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; put word after caller in tmp0
getptr:                             ; vramscriptp listadd+6p listadd+13p
                                    ; copyCHR+6p
                TSX     
                LDA     $103,X
                STA     5
                LDA     $104,X
                STA     6
                LDY     #1
                LDA     (5),Y
                STA     0
                INY     
                LDA     (5),Y
                STA     1
                CLC     
                LDA     #2          ; fixup return address
                ADC     5
                STA     $103,X
                LDA     #0
                ADC     6
                STA     $104,X
                RTS     
; End of function getptr
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; copy $3xx list to vram and clear list
vramlistcopy:                       ; EF91p sub_0_F0B4+1Cp F5C4p
                LDA     $FF
                AND     #11111011b  ; vaddr inc*1
                STA     $2000
                STA     $FF
                LDX     $2002
                LDY     #0
                BEQ     vlc3
vlc0:                               ; vramlistcopy+3Ej
                PHA     
                STA     $2006
                INY     
                LDA     $302,Y
                STA     $2006
                INY     
                LDX     $302,Y
vlc1:                               ; vramlistcopy+27j
                INY     
                LDA     $302,Y
                STA     $2007
                DEX     
                BNE     vlc1
                PLA     
                CMP     #$3F
                BNE     vlc2
                STA     $2006
                STX     $2006
                STX     $2006
                STX     $2006
vlc2:                               ; vramlistcopy+2Cj
                INY     
vlc3:                               ; vramlistcopy+Ej
                LDA     $302,Y
                BPL     vlc0
                STA     $302        ; clear list
                LDA     #0
                STA     $301
                RTS     
; End of function vramlistcopy
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; reads VRAM from addresses listed in $3xx
; Y=count
sub_0_E8B3:
                LDA     $2002
loc_0_E8B6:                         ; sub_0_E8B3+1Cj
                LDA     $300,X
                STA     $2006
                INX     
                LDA     $300,X
                STA     $2006
                INX     
                LDA     $2007
                LDA     $2007
                STA     $300,X
                INX     
                DEY     
                BNE     loc_0_E8B6
                RTS     
; End of function sub_0_E8B3
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; add to vram list
; A:X=VADDR, Y=count, next word=data ptr
listadd:                            ; sub_0_F376+4Cp F549p F5F3p
                STA     3
                STX     2
                STY     4           ; tmp4=byte count
                JSR     getptr      ; put word after caller in tmp0
                LDY     #$FF
                LDA     #1          ; 1 row (if NT)
                BNE     la0
listaddNT:                          ; who calls this??
                STA     3           ; (for list of NT data)
                                    ; A:X=VADDR, next word=data ptr
                                    ; 1st byte in data, bits 0-3=bytes in row
                                    ; bits 4-7=#rows
                STX     2
                JSR     getptr      ; put word after caller in tmp0
                LDY     #0
                LDA     (0),Y
                AND     #$F
                STA     4
                LDA     (0),Y
                LSR     A
                LSR     A
                LSR     A
                LSR     A
la0:                                ; listadd+Dj
                STA     5           ; tmp5=row count
                LDX     $301
la1:                                ; listadd+62j
                LDA     3           ; write VADDR
                STA     $302,X
                JSR     la3         ; increment list ptr
                LDA     2
                STA     $302,X
                JSR     la3         ; increment list ptr
                LDA     4
                STA     6           ; set count for new row
                STA     $302,X      ; write count
la2:                                ; listadd+4Bj
                JSR     la3         ; increment list ptr
                INY     
                LDA     (0),Y       ; data copy..
                STA     $302,X
                DEC     6
                BNE     la2
                JSR     la3         ; increment list ptr
                STX     $301
                CLC     
                LDA     #$20        ; VADDR+=$20
                ADC     2           ; (next NT row)
                STA     2
                LDA     #0
                ADC     3
                STA     3
                DEC     5           ; next row
                BNE     la1
                LDA     #$FF
                STA     $302,X      ; end list
                RTS     
la3:                                ; listadd+2Ep listadd+36p listadd+40p
                                    ; listadd+4Dp
                INX                 ; increment list ptr
                CPX     $300
                BCC     la4
                LDX     $301        ; abort if out of room
                LDA     #$FF
                STA     $302,X
                PLA     
                PLA     
                LDA     #1
la4:                                ; listadd+6Ej
                RTS     
; End of function listadd
                DEX     
                DEX     
                DEX     
                TXA     
loc_0_E953:                         ; E957j
                CLC     
                ADC     #3
                DEY     
                BNE     loc_0_E953
                TAX     
                TAY     
                LDA     $300,X
                CMP     0
                BNE     loc_0_E970
                INX     
                LDA     $300,X
                CMP     1
                BNE     loc_0_E970
                INX     
                LDA     $300,X
                CLC     
                RTS     
loc_0_E970:                         ; E960j E968j
                LDA     0
                STA     $300,Y
                INY     
                LDA     1
                STA     $300,Y
                SEC     
                RTS     
                LDA     #8
                STA     0
                LDA     2
                ASL     A
                ROL     0
                ASL     A
                ROL     0
                AND     #$E0
                STA     1
                LDA     3
                LSR     A
                LSR     A
                LSR     A
                ORA     1
                STA     1
                RTS     
                LDA     1
                ASL     A
                ASL     A
                ASL     A
                STA     3
                LDA     1
                STA     2
                LDA     0
                LSR     A
                ROR     2
                LSR     A
                ROR     2
                LDA     #$F8
                AND     2
                STA     2
                RTS     
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
sub_0_E9B1:                         ; EF0Ep sub_0_F0FD+1Ep
                LDA     0,X
                AND     #2
                STA     0
                LDA     1,X
                AND     #2
                EOR     0
                CLC     
                BEQ     loc_0_E9C1
                SEC     
loc_0_E9C1:                         ; sub_0_E9B1+Dj sub_0_E9B1+14j
                ROR     0,X
                INX     
                DEY     
                BNE     loc_0_E9C1
                RTS     
; End of function sub_0_E9B1
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; sprite DMA transfer ($0200)
spritedma:                          ; sub_0_F0B4+19p
                LDA     #0
                STA     $2003
                LDA     #2          ; spritebase>>8
                STA     $4014
                RTS     
; End of function spritedma
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; if (X)=0
;   (X)=9
;   decrement range (X->Y)
; else
;   decrement range (X->A)
sub_0_E9D3:                         ; sub_0_EFE8+9p
                STX     0
                DEC     0,X
                BPL     loc_0_E9DE
                LDA     #9
                STA     0,X
                TYA     
loc_0_E9DE:                         ; sub_0_E9D3+4j
                TAX     
loc_0_E9DF:                         ; sub_0_E9D3+15j
                LDA     0,X
                BEQ     loc_0_E9E5
                DEC     0,X
loc_0_E9E5:                         ; sub_0_E9D3+Ej
                DEX     
                CPX     0
                BNE     loc_0_E9DF
                RTS     
; End of function sub_0_E9D3
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; read 4016/7
jr1:                                ; jr1+2Fp jr1+34p EA36p EA3Ep EA4Cp
                                    ; EA57p EA68p
                LDX     $FB
                INX     
                STX     $4016
                DEX     
                STX     $4016
                LDX     #8
jr0:                                ; jr1+1Fj
                LDA     $4016
                LSR     A
                ROL     $F5
                LSR     A
                ROL     0
                LDA     $4017
                LSR     A
                ROL     $F6
                LSR     A
                ROL     1
                DEX     
                BNE     jr0
                RTS     
jr2:                                ; jr1+37p EA4Fp EA5Ap
                LDA     0
                ORA     $F5
                STA     $F5
                LDA     1
                ORA     $F6
                STA     $F6
                RTS     
joyread:                            ; EEB8p F551p
                JSR     jr1         ; read joypad state
                BEQ     jr3         ; always jumps?
                JSR     jr1         ; read 4016/7
                JSR     jr2
jr3:                                ; jr1+32j EA4Aj EA66j
                LDX     #1
jr4:                                ; jr1+48j
                LDA     $F5,X
                TAY     
                EOR     $F7,X
                AND     $F5,X
                STA     $F5,X
                STY     $F7,X
                DEX     
                BPL     jr4
                RTS     
; End of function jr1
                JSR     jr1         ; read 4016/7
loc_0_EA39:                         ; EA44j EA48j
                LDY     $F5
                LDA     $F6
                PHA     
                JSR     jr1         ; read 4016/7
                PLA     
                CMP     $F6
                BNE     loc_0_EA39
                CPY     $F5
                BNE     loc_0_EA39
                BEQ     jr3
                JSR     jr1         ; read 4016/7
                JSR     jr2
loc_0_EA52:                         ; EA60j EA64j
                LDY     $F5
                LDA     $F6
                PHA     
                JSR     jr1         ; read 4016/7
                JSR     jr2
                PLA     
                CMP     $F6
                BNE     loc_0_EA52
                CPY     $F5
                BNE     loc_0_EA52
                BEQ     jr3
                JSR     jr1         ; read 4016/7
                LDA     0
                STA     $F7
                LDA     1
                STA     $F8
                LDX     #3
loc_0_EA75:                         ; EA81j
                LDA     $F5,X
                TAY     
                EOR     $F1,X
                AND     $F5,X
                STA     $F5,X
                STY     $F1,X
                DEX     
                BPL     loc_0_EA75
                RTS     
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; A=addr*256, X=val, Y=count or attrib
; if A<$2000, fill Y*256 bytes with X
; else fill NT with X, attrib with Y
; 
vramfill:                           ; sub_0_F3FA+22p sub_0_F3FA+2Bp
                                    ; copyrightcheck+19p F4D2p
                STA     0
                STX     1
                STY     2
                LDA     $2002
                LDA     $FF
                AND     #11111011b
                STA     $2000
                STA     $FF
                LDA     0
                STA     $2006
                LDY     #0
                STY     $2006
                LDX     #4
                CMP     #$20        ; if A>$20, count=$400
                BCS     vfl2        ; else count=tmp2*256
                LDX     2
vfl2:                               ; vramfill+20j
                LDY     #0
                LDA     1
vfl0:                               ; vramfill+2Cj vramfill+2Fj
                STA     $2007
                DEY     
                BNE     vfl0
                DEX     
                BNE     vfl0
                LDY     2
                LDA     0
                CMP     #$20        ; NT?
                BCC     vfl9
                ADC     #2          ; set attrib with tmp2
                STA     $2006
                LDA     #$C0
                STA     $2006
                LDX     #$40
vfl1:                               ; vramfill+49j
                STY     $2007
                DEX     
                BNE     vfl1
vfl9:                               ; vramfill+37j
                LDX     1
                RTS     
; End of function vramfill
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; clear pages of ram
; A=val, X=start, Y=end
; (exits with tmp0=$00)
pageclear:                          ; sub_0_F0FD+6p
                PHA     
                TXA     
                STY     1
                CLC     
                SBC     1
                TAX                 ; x=x-y-1 (-pages)
                PLA     
                LDY     #0
                STY     0           ; tmp0=Y*256
pcl0:                               ; pageclear+10j pageclear+15j
                STA     (0),Y       ; fill 256 bytes
                DEY     
                BNE     pcl0
                DEC     1           ; (from high to low)
                INX     
                BNE     pcl0
                RTS     
; End of function pageclear
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; set $2000,$2005
setscroll:                          ; EE9Bp EF01p EF56p EF94p EFB6p F562p
                                    ; F5C7p
                LDA     $2002
                LDA     $FD
                STA     $2005
                LDA     $FC
                STA     $2005
                LDA     $FF
                STA     $2000
                RTS     
; End of function setscroll
                ASL     A
                TAY     
                INY     
                PLA     
                STA     0
                PLA     
                STA     1
                LDA     (0),Y
                TAX     
                INY     
                LDA     (0),Y
                STA     1
                STX     0
                JMP     (0)
                LDA     $FB
                AND     #$F8
                STA     $FB
                ORA     #5
                STA     $4016
                NOP     
                NOP     
                NOP     
                NOP     
                NOP     
                NOP     
                LDX     #8
loc_0_EB26:                         ; EB5Cj
                LDA     $FB
                ORA     #4
                STA     $4016
                LDY     #$A
loc_0_EB2F:                         ; EB30j
                DEY     
                BNE     loc_0_EB2F
                NOP     
                LDY     $FB
                LDA     $4017
                LSR     A
                AND     #$F
                BEQ     loc_0_EB62
                STA     0,X
                LDA     $FB
                ORA     #6
                STA     $4016
                LDY     #$A
loc_0_EB48:                         ; EB49j
                DEY     
                BNE     loc_0_EB48
                NOP     
                NOP     
                LDA     $4017
                ROL     A
                ROL     A
                ROL     A
                AND     #$F0
                ORA     0,X
                EOR     #$FF
                STA     0,X
                DEX     
                BPL     loc_0_EB26
                LDY     $FB
                ORA     #$FF
loc_0_EB62:                         ; EB3Bj
                STY     $4016
                RTS     
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; Y=0, tmp0+=8, dec tmp2
tmp0_add8:                          ; copyCHR+46p copyCHR+60p copyCHR+6Cp
                LDA     #8
; End of function tmp0_add8
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; Y=0, tmp0=tmp0+A, dec tmp2
tmp0_add:                           ; copyCHR+54p
                PHP                 ; (save C)
                LDY     #0
                CLC     
                ADC     0
                STA     0
                LDA     #0
                ADC     1
                STA     1
                PLP                 ; (restore C)
                DEC     2
                RTS     
; End of function tmp0_add
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; C=0: copy 8 bytes of (tmp0+Y) to vram
; C=1: read 8 bytes of vram to (tmp0+Y)
xfer8:                              ; copyCHR+43p copyCHR+4Cp copyCHR+4Fp
                                    ; copyCHR+5Ap copyCHR+69p
                LDX     #8
xf0:                                ; xfer8+Bj
                BCS     xf2
                LDA     (0),Y
                STA     $2007
xf1:                                ; xfer8+13j
                INY     
                DEX     
                BNE     xf0
                RTS     
xf2:                                ; xfer8+2j
                LDA     $2007
                STA     (0),Y
                BCS     xf1
; End of function xfer8
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; C=0: copy 8 bytes of (tmp3) to vram
; C=1: VADDR+=8
fill8:                              ; copyCHR+5Dp copyCHR+66p
                LDA     3
                LDX     #8
fl0:                                ; fill8+Aj
                BCS     fl2
                STA     $2007
fl1:                                ; fill8+10j
                DEX     
                BNE     fl0
                RTS     
fl2:                                ; fill8+4j
                LDA     $2007
                BCS     fl1
; End of function fill8
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; copy 8 bytes of (tmp0+Y) to vram
; use (tmp3) for EOR mask
copy8:                              ; copyCHR+3Ep
                LDX     #8
co0:                                ; copy8+Bj
                LDA     3
                EOR     (0),Y
                STA     $2007
                INY     
                DEX     
                BNE     co0
                RTS     
; End of function copy8
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; Y:A=vram addr  X=tile count
; word after call=CPU addr
; A&$0F=CHR type
; 
; bit 0=mask (0=$00, 1=$FF)
; bit 1=read/write
; bit 2,3=type
;   00: 2bpp
;   01: 1bpp (plane1=data, plane2=mask)
;   10: 1bpp (plane1=mask, plane2=data)
;   11: 1bpp (plane1=data^mask, plane2=data)
copyCHR:                            ; setupfont+6p setupfont+11p
                                    ; setupfont+1Cp sub_0_F3FA+9p
                                    ; sub_0_F3FA+14p sub_0_F48C+15p
                                    ; sub_0_F48C+20p F4E8p F4F3p F4FEp
                                    ; F509p
                STA     4
                STX     2           ; tmp2=count
                STY     3           ; tmp3=Y:A
                JSR     getptr      ; put word after caller in tmp0
                LDA     $2002
                LDA     $FF
                AND     #11111011b  ; vram inc*1
                STA     $FF
                STA     $2000
                LDY     3
                STY     $2006
                LDA     4
                AND     #$F0
                STA     $2006       ; VADDR=tmp3&$FFF0
                LDA     #0
                STA     3
                LDA     4
                AND     #$F
                LSR     A
                BCC     cch0
                DEC     3
cch0:                               ; copyCHR+2Aj
                LSR     A
                BCC     cch1
                LDX     $2007
cch1:                               ; copyCHR+2Fj
                TAY     
                BEQ     cch00xx
                DEY     
                BEQ     cch01xx
                DEY     
                BEQ     cch10xx
                DEY     
cch11xx:                            ; copyCHR+49j
                JSR     copy8       ; copy 8 bytes of (tmp0+Y) to vram
                                    ; use (tmp3) for EOR mask
                LDY     #0
                JSR     xfer8       ; C=0: copy 8 bytes of (tmp0+Y) to vram
                                    ; C=1: read 8 bytes of vram to (tmp0+Y)
                JSR     tmp0_add8   ; Y=0, tmp0+=8, dec tmp2
                BNE     cch11xx
                RTS     
cch00xx:                            ; copyCHR+35j copyCHR+57j
                JSR     xfer8       ; C=0: copy 8 bytes of (tmp0+Y) to vram
                                    ; C=1: read 8 bytes of vram to (tmp0+Y)
                JSR     xfer8       ; C=0: copy 8 bytes of (tmp0+Y) to vram
                                    ; C=1: read 8 bytes of vram to (tmp0+Y)
                LDA     #$10
                JSR     tmp0_add    ; Y=0, tmp0=tmp0+A, dec tmp2
                BNE     cch00xx
                RTS     
cch01xx:                            ; copyCHR+38j copyCHR+63j
                JSR     xfer8       ; C=0: copy 8 bytes of (tmp0+Y) to vram
                                    ; C=1: read 8 bytes of vram to (tmp0+Y)
                JSR     fill8       ; C=0: copy 8 bytes of (tmp3) to vram
                                    ; C=1: VADDR+=8
                JSR     tmp0_add8   ; Y=0, tmp0+=8, dec tmp2
                BNE     cch01xx
                RTS     
cch10xx:                            ; copyCHR+3Bj copyCHR+6Fj
                JSR     fill8       ; C=0: copy 8 bytes of (tmp3) to vram
                                    ; C=1: VADDR+=8
                JSR     xfer8       ; C=0: copy 8 bytes of (tmp0+Y) to vram
                                    ; C=1: read 8 bytes of vram to (tmp0+Y)
                JSR     tmp0_add8   ; Y=0, tmp0+=8, dec tmp2
                BNE     cch10xx
                RTS     
; End of function copyCHR
locret_0_EC21:                      ; sub_0_EC22+11j sub_0_EC22+1Bj
                                    ; sub_0_EC22+29j
                RTS     
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
sub_0_EC22:                         ; EF29p EF30p
                LDY     #$B
                LDA     (0),Y
                STA     2
                LDA     #2
                STA     3
                DEY     
                LDA     (0),Y
                LSR     A
                LSR     A
                LSR     A
                LSR     A
                BEQ     locret_0_EC21
                STA     4
                STA     $C
                LDA     (0),Y
                AND     #$F
                BEQ     locret_0_EC21
                STA     5
                LDY     #1
                LDA     (0),Y
                TAX     
                DEY     
                LDA     (0),Y
                BEQ     loc_0_EC4F
                BPL     locret_0_EC21
                LDX     #$F4
loc_0_EC4F:                         ; sub_0_EC22+27j
                STX     8
                LDY     #8
                LDA     (0),Y
                LSR     A
                AND     #8
                BEQ     loc_0_EC5C
                LDA     #$80
loc_0_EC5C:                         ; sub_0_EC22+36j
                ROR     A
                STA     9
                INY     
                LDA     (0),Y
                AND     #$23
                ORA     9
                STA     9
                LDY     #3
                LDA     (0),Y
                STA     $A
                LDA     5
                STA     7
                LDY     #0
                STY     $B
loc_0_EC76:                         ; sub_0_EC22+80j
                LDA     4
                STA     6
                LDX     8
loc_0_EC7C:                         ; sub_0_EC22+75j
                TXA     
                STA     (2),Y
                CMP     #$F4
                BEQ     loc_0_EC87
                CLC     
                ADC     #8
                TAX     
loc_0_EC87:                         ; sub_0_EC22+5Fj
                INY     
                INY     
                LDA     9
                STA     (2),Y
                INY     
                LDA     $A
                STA     (2),Y
                INY     
                INC     $B
                DEC     6
                BNE     loc_0_EC7C
                LDA     $A
                CLC     
                ADC     #8
                STA     $A
                DEC     7
                BNE     loc_0_EC76
                LDY     #7
                LDA     (0),Y
                STA     7
                DEY     
                LDA     (0),Y
                STA     8
                LDA     #0
                STA     $A
                CLC     
                LDX     $B
                DEY     
loc_0_ECB7:                         ; sub_0_EC22+A3j
                LDA     (0),Y
                CLC     
                ADC     7
                STA     7
                LDA     #0
                ADC     8
                STA     8
                DEX     
                BNE     loc_0_ECB7
                INC     2
                LDY     #0
                LDA     8
                BNE     loc_0_ECD3
                DEC     $A
                LDY     7
loc_0_ECD3:                         ; sub_0_EC22+ABj
                BIT     9
                BMI     loc_0_ECF5
                BVS     loc_0_ECF7
loc_0_ECD9:                         ; sub_0_EC22+D0j sub_0_EC22+DDj
                LDA     (7),Y
                BIT     $A
                BPL     loc_0_ECE0
                TYA     
loc_0_ECE0:                         ; sub_0_EC22+BBj
                STA     (2,X)
                DEY     
                BIT     9
                BMI     loc_0_ECE9
                INY     
                INY     
loc_0_ECE9:                         ; sub_0_EC22+C3j
                LDA     #4
                CLC     
                ADC     2
                STA     2
                DEC     $B
                BNE     loc_0_ECD9
                RTS     
loc_0_ECF5:                         ; sub_0_EC22+B3j
                BVC     loc_0_ED09
loc_0_ECF7:                         ; sub_0_EC22+B5j
                TYA     
                CLC     
                ADC     $B
                TAY     
                DEY     
                BIT     9
                BMI     loc_0_ECD9
                LDA     #$FF
                EOR     $C
                STA     $C
                INC     $C
loc_0_ED09:                         ; sub_0_EC22+D3j sub_0_EC22+112j
                TYA     
                CLC     
                ADC     $C
                TAY     
                LDA     4
                STA     6
loc_0_ED12:                         ; sub_0_EC22+109j
                DEY     
                BIT     9
                BMI     loc_0_ED19
                INY     
                INY     
loc_0_ED19:                         ; sub_0_EC22+F3j
                LDA     (7),Y
                BIT     $A
                BPL     loc_0_ED20
                TYA     
loc_0_ED20:                         ; sub_0_EC22+FBj
                STA     (2,X)
                LDA     #4
                CLC     
                ADC     2
                STA     2
                DEC     6
                BNE     loc_0_ED12
                TYA     
                CLC     
                ADC     $C
                TAY     
                DEC     5
                BNE     loc_0_ED09
                RTS     
; End of function sub_0_EC22
kyodaku:        .BYTE $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $17, $12, $17, $1D, $E
                                    ; copyrightcheck+3Ar
                .BYTE $17, $D, $18, $24, $28, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24 ; copyright screen
                .BYTE $24, $24, $24, $24, $24, $24, $24, $F, $A, $16, $12, $15, $22, $24, $C, $18, $16
                .BYTE $19, $1E, $1D, $E, $1B, $24, $1D, $16, $24, $24, $24, $24, $24, $24, $24, $24
                .BYTE $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24
                .BYTE $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24, $24
                .BYTE $24, $1D, $11, $12, $1C, $24, $19, $1B, $18, $D, $1E, $C, $1D, $24, $12, $1C, $24
                .BYTE $16, $A, $17, $1E, $F, $A, $C, $1D, $1E, $1B, $E, $D, $24, $24, $24, $24, $A, $17
                .BYTE $D, $24, $1C, $18, $15, $D, $24, $B, $22, $24, $17, $12, $17, $1D, $E, $17, $D
                .BYTE $18, $24, $C, $18, $27, $15, $1D, $D, $26, $24, $24, $24, $24, $18, $1B, $24, $B
                .BYTE $22, $24, $18, $1D, $11, $E, $1B, $24, $C, $18, $16, $19, $A, $17, $22, $24, $1E
                .BYTE $17, $D, $E, $1B, $24, $24, $24, $24, $24, $24, $24, $15, $12, $C, $E, $17, $1C
                .BYTE $E, $24, $18, $F, $24, $17, $12, $17, $1D, $E, $17, $D, $18, $24, $C, $18, $27
                .BYTE $15, $1D, $D, $26, $26, $24, $24
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
startmotor:                         ; seek0+Bp seek0+28p
                ORA     #1          ; motor on
                STA     $4025
                AND     #11111101b  ; stop head reset
                STA     $FA
                STA     $4025
                RTS     
; End of function startmotor
reset:                              ; EFACj
                                    ; FFFCo
                SEI     
                LDA     #$10
                STA     $2000
                STA     $FF
                CLD     
                LDA     #110b
                STA     $FE
                STA     $2001
                LDX     #2
r0:                                 ; EE39j EE3Cj
                LDA     $2002
                BPL     r0
                DEX     
                BNE     r0
                JSR     resetbanks  ; x=0
                STX     $16F
               ; LDA     #10000011b
               ; STA     $4023
               lda #$00
               sta $a000  ; sta $42ff   ;set mirroring
                STX     $FD
                STX     $FC
                STX     $FB
                STX     $4016
                LDA     #$2E
                STA     $FA
            ;    STA     $4025
            nop
            nop
            nop
                LDA     #$FF
                STA     $F9
            ;    STA     $4026
            nop
            nop
            nop
                STX     $4010
                LDA     #11000000b
                STA     $4017
                LDA     #1111b
                STA     $4015
                LDA     #0
                STA     $75F
                LDA     #0
                STA     $1E6
                LDX     #$CB
                TXS     
                LDA     #11000000b
                STA     $100
                LDA     #10000000b
                JSR     loc_0_F900
                LDA     $102
                CMP     #$35
                BNE     hardreset
                LDA     $103
                CMP     #$53
                BEQ     r1
                CMP     #$AC
                BNE     hardreset
                LDA     #$53
                STA     $103
r1:                                 ; EE90j EFE5j
                JSR     setscroll   ; set $2000,$2005
                CLI     
                JMP     ($DFFC)
hardreset:                          ; EE89j EE94j
                LDA     #0
                LDX     #$F8
r3:                                 ; EEA9j
                STA     0,X         ; clear $00-$F8
                DEX     
                BNE     r3
                STA     $301        ; clear vram list..
                LDA     #$7D        ; list size: $302-$37F
                STA     $300
                LDA     #$FF
                STA     $302
                JSR     joyread     ; read joypad state
                LDA     $F7
                CMP     #110000b    ; start+select?
                BNE     r2
                LDA     #$5A        ; run diagnosis
                STA     $1E7
                NOP     
                NOP     
                NOP     
r2:                                 ; EEBFj
                JSR     sub_0_F3FA  ; titlesrceen init?
                JSR     sub_0_F0FD  ; sprite init?
                LDA     #$4A
                STA     $A1
                LDA     #$30
                STA     $B1
                LDA     #$E4
                STA     $83
                LDA     #169
                STA     $FC
                LDA     #$35
                STA     $102
                LDA     #$AC
                JSR     setbankCXXXto0
loc_0_EEE9:                         ; EEE4j EF38j
                LDX     #6
loc_0_EEEB:                         ; EEF2j
                LDA     $C511,X
r5:                                 ; EF44j
                STA     $1E8,X
                DEX     
                BPL     loc_0_EEEB
                LDA     #$AC
                STA     $103
                JMP     ($DFFC)
                STA     $E1
r6:
                JSR     sub_0_F0B4
                JSR     setscroll   ; set $2000,$2005
                JSR     screenon    ; BG+OBJ on
                JSR     sub_0_EFE8
                LDX     #$60
                LDY     #$20
                JSR     sub_0_E9B1
                JSR     sub_0_F143
                JSR     sub_0_F342
                LDX     #0
                JSR     sub_0_F1E5
                LDX     #$10
                JSR     sub_0_F1E5
                LDA     #$C0
                STA     0
                LDA     #0
                STA     1
                JSR     sub_0_EC22
                LDA     #$D0
                STA     0
                JSR     sub_0_EC22
                LDA     $4032
                AND     #1
                BNE     loc_0_EEE9+1 ; no disk
                LDA     $FC
                BEQ     diskhere
                LDA     #1
                STA     $FC
diskhere:                           ; EF3Cj
                LDA     $90
                BNE     r5
                JSR     OBJoff
                JSR     waitNMI     ; wait for vblank with NMI
                JSR     vramscript
                .WORD blankspace
                JSR     vramscript
                .WORD now_loading
                JSR     setscroll   ; set $2000,$2005
                JSR     loaddisk    ; API: (..)
                                    ; return with A=err
                .WORD defaultID     ; maker ID, game ID, verison
                .WORD defaultID     ; maker ID, game ID, verison
                BNE     showerror
                JSR     copyrightcheck
                BEQ     showcopyright
                JSR     checksram   ; scan for bad sram ($6000-$DFFF)
                                    ; leave final address in tmp0, Z=0 on error
                LDA     #$20
showerror:                          ; EF60j
                STA     $23
                JSR     sub_0_F3FA  ; titlesrceen init?
                JSR     sub_0_F0E1  ; vramscript _2040
                JSR     sub_0_F0E7  ; vramscript _2340
                JSR     sub_0_F0ED  ; vramscript _2380
                JSR     sub_0_F179
                LDA     #$10
                STA     $A3
                LDA     $22
                BEQ     loc_0_EF8B
                LDA     #1
                STA     $83
                DEC     $21
loc_0_EF8B:                         ; EF83j EFA3j
                JSR     sub_0_F376
                JSR     waitNMI     ; wait for vblank with NMI
                JSR     vramlistcopy ; copy $3xx list to vram and clear list
                JSR     setscroll   ; set $2000,$2005
                JSR     BGon
                JSR     sub_0_EFE8
                LDA     #2
                STA     $E1
                LDA     $A3
                BNE     loc_0_EF8B
loc_0_EFA5:                         ; EFAAj
                LDA     $4032
                AND     #1
                BEQ     loc_0_EFA5  ; wait for disk eject
                JMP     reset
showcopyright:                      ; EF65j
                LDA     #$20
                STA     $A2
loc_0_EFB3:                         ; EFCBj
                JSR     waitNMI     ; wait for vblank with NMI
                JSR     setscroll   ; set $2000,$2005
                JSR     BGon
                LDX     $FC
                INX     
                INX     
                CPX     #$B0
                BCS     loc_0_EFC6
                STX     $FC
loc_0_EFC6:                         ; EFC2j
                JSR     sub_0_EFE8
                LDA     $A2
                BNE     loc_0_EFB3
                LDA     #$35
                STA     $102
                LDA     #$AC
                STA     $103
                JSR     BGoff
                LDY     #7
                JSR     sub_0_F48C
                LDA     #0
                STA     $FD
                STA     $FC
                JMP     r1
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
sub_0_EFE8:                         ; EF07p EF9Ap EFC6p
                JSR     sub_0_FF5C
                LDX     #$80
                LDA     #$9F
                LDY     #$BF
                JSR     sub_0_E9D3  ; if (X)=0
                                    ;   (X)=9
                                    ;   decrement range (X->Y)
                                    ; else
                                    ;   decrement range (X->A)
                RTS     
; End of function sub_0_EFE8
defaultID:      .BYTE $FF, $FF, $FF, $FF, $FF, $FF ; EF5Co EF5Eo
                                    ; maker ID, game ID, verison
                .BYTE 0, 0          ; (must be side 0)
                .BYTE  $FF ;  
                .BYTE  $FF ;  
blankspace:     .BYTE  $21 ; !      ; EF4Fo sub_0_F0B4+26o
byte_0_F000:    .BYTE $A6           ; FA78w bankswitchCXXX+5w FAC5w FACFw
                                    ; FAD9w FAE3w
                .BYTE $54
                .BYTE $24
                .BYTE $FF           ; end
set_disk_card:  .BYTE $21, $A6      ; F0FAo
                                    ; "PLEASE SET DISK CARD"
                .BYTE $14
                .BYTE $19, $15, $E, $A, $1C, $E, $24, $1C, $E, $1D, $24, $D, $12, $1C, $14, $24, $C
                .BYTE $A, $1B, $D
                .BYTE $FF           ; end
now_loading:    .BYTE $21, $A6      ; EF54o
                                    ; "NOW LOADING..."
                .BYTE $E
                .BYTE $17, $18, $20, $24, $15, $18, $A, $D, $12, $17, $10, $26, $26, $26
                .BYTE $FF           ; end
errcodes:       .BYTE $D, $12, $1C, $14, $24, $1C, $E, $1D ; sub_0_F179+2r
                                    ; sub_0_F179+3Br
                                    ; "DISK SET"
                .BYTE $B, $A, $1D, $1D, $E, $1B, $22, $24 ; "BATTERY "
                .BYTE $A, $25, $B, $24, $1C, $12, $D, $E ; "A\B SIDE"
                .BYTE $D, $12, $1C, $14, $24, $17, $18, $26 ; "DISK NO."
disktrouble:    .BYTE $21, $A6      ; "DISK TROUBLE  ERR.20"
                .BYTE $14
                .BYTE $D, $12, $1C, $14, $24, $1D, $1B, $18, $1E, $B, $15, $E, $24, $24, $E, $1B, $1B
                .BYTE $26, 2, 0
                .BYTE $FF
pram_cram_ok:   .BYTE $20, $E8      ; F4DBo
                                    ; "PRAM CRAM     OK"
                .BYTE $10
                .BYTE $19, $1B, $A, $16, $24, $C, $1B, $A, $16, $24, $24, $24, $24, $24, $18, $14
                .BYTE $21, $68      ; "PORT"
                .BYTE 4
                .BYTE $19, $18, $1B, $1D
_3f00:          .BYTE $3F, 0        ; copyrightcheck+11o
                                    ; palette
                .BYTE 8
                .BYTE $F, $20, $F, $F, $F, $F, $F, $F
_2bc0:          .BYTE $2B, $C0      ; NT2
                .BYTE $50
                .BYTE 0
_2bd0:          .BYTE $2B, $D0      ; NT2
                .BYTE $70
                .BYTE $55
                .BYTE $FF           ; end
spritedata:     .BYTE $80, $B8, 0, 0, 0, 0, 0, 0, $10, 0, $32, 0, 0, 0, 1, 0, $80, $B8, 0, $F0, 0, 0
                                    ; sub_0_F0FD+Br
                .BYTE 0, 0, 0, 1, $32, $18, 0, 0, $FF, 0
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
sub_0_F0B4:                         ; EEFEp
                LDA     $FC
                BEQ     loc_0_F0C0
                DEC     $FC
                BNE     loc_0_F0C0
                LDA     #$10
                STA     $94
loc_0_F0C0:                         ; sub_0_F0B4+2j sub_0_F0B4+6j
                LDX     $94
                BEQ     loc_0_F0CD
                DEX     
                BEQ     sub_0_F0E1  ; vramscript _2040
                DEX     
                BEQ     sub_0_F0E7  ; vramscript _2340
                DEX     
                BEQ     sub_0_F0ED  ; vramscript _2380
loc_0_F0CD:                         ; sub_0_F0B4+Ej
                JSR     spritedma   ; sprite DMA transfer ($0200)
                JSR     vramlistcopy ; copy $3xx list to vram and clear list
                LDA     $92
                BNE     loc_0_F0F3
                JSR     vramscript
                .WORD blankspace
                LDA     #$40
                STA     $92
                RTS     
; End of function sub_0_F0B4
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; vramscript _2040
sub_0_F0E1:                         ; EF71p sub_0_F0B4+11j
                JSR     vramscript
                .WORD unk_0_F716
                RTS     
; End of function sub_0_F0E1
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; vramscript _2340
sub_0_F0E7:                         ; EF74p sub_0_F0B4+14j
                JSR     vramscript
                .WORD _2340
                RTS     
; End of function sub_0_F0E7
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; vramscript _2380
sub_0_F0ED:                         ; EF77p sub_0_F0B4+17j
                JSR     vramscript
                .WORD _2380
                RTS     
; End of function sub_0_F0ED
loc_0_F0F3:                         ; sub_0_F0B4+21j
                CMP     #$2E
                BNE     locret_0_F0FC
                JSR     vramscript
                .WORD set_disk_card
locret_0_F0FC:                      ; F0F5j
                RTS     
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; sprite init?
sub_0_F0FD:                         ; EECCp
                LDA     #$F4        ; clear spritebase
                LDX     #2
                LDY     #2
                JSR     pageclear   ; clear pages of ram
                                    ; A=val, X=start, Y=end
                                    ; (exits with tmp0=$00)
                LDY     #$20
loc_0_F108:                         ; sub_0_F0FD+12j
                LDA     spritedata-1,Y
                STA     $BF,Y
                DEY     
                BNE     loc_0_F108
                LDA     #$D0
                STA     $60
                STA     1
loc_0_F117:                         ; sub_0_F0FD+2Bj
                LDY     #2
                LDX     #$60
                JSR     sub_0_E9B1
                LDA     $60
                LDX     1
                STA     $22F,X
                DEX     
                STX     1
                BNE     loc_0_F117
                LDA     #$18
                LDX     #$D0
loc_0_F12E:                         ; sub_0_F0FD+38j
                STA     $22D,X
                DEX     
                DEX     
                DEX     
                DEX     
                BNE     loc_0_F12E
                LDX     #$D0
                STX     $24
loc_0_F13B:                         ; sub_0_F0FD+43j
                JSR     sub_0_F156
                CPX     #$D0
                BNE     loc_0_F13B
                RTS     
; End of function sub_0_F0FD
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
sub_0_F143:                         ; EF11p
                LDA     $84
                BNE     sub_0_F156
                LDA     #4
                STA     $84
                LDX     #$D0
loc_0_F14D:                         ; sub_0_F143+11j
                DEC     $22C,X
                DEX     
                DEX     
                DEX     
                DEX     
                BNE     loc_0_F14D
; End of function sub_0_F143
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
sub_0_F156:                         ; sub_0_F0FD+3Ep sub_0_F143+2j
                LDY     #4
loc_0_F158:                         ; sub_0_F156+1Cj
                LDX     $24
                DEC     $22E,X
                LDA     #3
                AND     $22E,X
                ORA     #$20
                STA     $22E,X
                DEX     
                DEX     
                DEX     
                DEX     
                BNE     loc_0_F16F
                LDX     #$D0
loc_0_F16F:                         ; sub_0_F156+15j
                STX     $24
                DEY     
                BNE     loc_0_F158
                RTS     
; End of function sub_0_F156
dunno:          .BYTE 1, 2, 7, 8    ; sub_0_F179+2Er
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
sub_0_F179:                         ; EF7Ap
                LDY     #$18
loc_0_F17B:                         ; sub_0_F179+9j
                LDA     errcodes+$1F,Y
                STA     $3F,Y
                DEY     
                BNE     loc_0_F17B
                LDA     $23
                AND     #$F
                STA     $56
                LDA     $23
                LSR     A
                LSR     A
                LSR     A
                LSR     A
                STA     $55
                CMP     #2
                BEQ     loc_0_F1BD
                LDY     #$E
                LDA     #$24
loc_0_F19A:                         ; sub_0_F179+25j
                STA     $42,Y
                DEY     
                BNE     loc_0_F19A
                LDY     #5
                LDA     $23
loc_0_F1A4:                         ; sub_0_F179+31j
                DEY     
                BEQ     loc_0_F1BD
                CMP     dunno-1,Y
                BNE     loc_0_F1A4
                TYA     
                ASL     A
                ASL     A
                ASL     A
                TAX     
                LDY     #7
loc_0_F1B3:                         ; sub_0_F179+42j
                DEX     
                LDA     errcodes,X
                STA     $43,Y
                DEY     
                BPL     loc_0_F1B3
loc_0_F1BD:                         ; sub_0_F179+1Bj sub_0_F179+2Cj
                JSR     vramscript
                .WORD $40
                RTS     
; End of function sub_0_F179
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
setupfont:                          ; sub_0_F3FA+19p copyrightcheck+8p F54Ep
                LDA     #1101b      ; copy font to $1000 (colors 1/2)
                LDY     #$10
                LDX     #$29
                JSR     copyCHR     ; Y:A=vram addr  X=tile count
                                    ; word after call=CPU addr
                                    ; A&$0F=CHR type
                                    ; 
                                    ; bit 0=mask (0=$00, 1=$FF)
                                    ; bit 1=read/write
                                    ; bit 2,3=type
                                    ;   00: 2bpp
                                    ;   01: 1bpp (plane1=data, plane2=mask)
                                    ;   10: 1bpp (plane1=mask, plane2=data)
                                    ;   11: 1bpp (plane1=data^mask, plane2=data)
                .WORD $e001 ;font          ; 1bpp font
                LDA     #110b       ; read font to $400 (invert)
                LDY     #$10
                LDX     #$29
                JSR     copyCHR     ; Y:A=vram addr  X=tile count
                                    ; word after call=CPU addr
                                    ; A&$0F=CHR type
                                    ; 
                                    ; bit 0=mask (0=$00, 1=$FF)
                                    ; bit 1=read/write
                                    ; bit 2,3=type
                                    ;   00: 2bpp
                                    ;   01: 1bpp (plane1=data, plane2=mask)
                                    ;   10: 1bpp (plane1=mask, plane2=data)
                                    ;   11: 1bpp (plane1=data^mask, plane2=data)
                .WORD $400
                LDA     #1001b      ; copy font to $1000 (colors 3/1)
                LDY     #$10
                LDX     #$29
                JSR     copyCHR     ; Y:A=vram addr  X=tile count
                                    ; word after call=CPU addr
                                    ; A&$0F=CHR type
                                    ; 
                                    ; bit 0=mask (0=$00, 1=$FF)
                                    ; bit 1=read/write
                                    ; bit 2,3=type
                                    ;   00: 2bpp
                                    ;   01: 1bpp (plane1=data, plane2=mask)
                                    ;   10: 1bpp (plane1=mask, plane2=data)
                                    ;   11: 1bpp (plane1=data^mask, plane2=data)
                .WORD $400
                RTS     
; End of function setupfont
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
sub_0_F1E5:                         ; EF19p EF1Ep
                JSR     sub_0_F1F2
                JSR     sub_0_F2EC
                JSR     sub_0_F273
                JSR     sub_0_F2C6
                RTS     
; End of function sub_0_F1E5
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
sub_0_F1F2:                         ; sub_0_F1E5p
                LDA     $20,X
                BNE     locret_0_F227
                LDA     $C0,X
                BNE     locret_0_F227
                LDA     $B0
                BNE     locret_0_F227
                LDA     $81,X
                BNE     locret_0_F227
                LDA     $62,X
                AND     #$3C
                STA     $81,X
                TXA     
                BNE     loc_0_F228
                LDA     $B2
                BNE     loc_0_F236
                LDA     $D0
                BEQ     loc_0_F23D
                LDA     $22
                BNE     loc_0_F21D
                LDA     $C3
                CMP     #$78
                BCC     loc_0_F24D
loc_0_F21D:                         ; sub_0_F1F2+23j sub_0_F1F2+3Cj
                                    ; sub_0_F1F2+53j
                LDA     #0
                STA     $C8,X
                STA     $CF,X
                LDA     #$FF
                STA     $CE,X
locret_0_F227:                      ; sub_0_F1F2+2j sub_0_F1F2+6j
                                    ; sub_0_F1F2+Aj sub_0_F1F2+Ej
                RTS     
loc_0_F228:                         ; sub_0_F1F2+17j
                LDA     $C0
                BEQ     loc_0_F25A
                LDA     $22
                BNE     loc_0_F21D
                LDA     $63,X
                CMP     #$80
                BCS     loc_0_F24D
loc_0_F236:                         ; sub_0_F1F2+1Bj sub_0_F1F2+59j
                                    ; sub_0_F1F2+74j
                LDA     #0
                STA     $CF,X
                STA     $CE,X
                RTS     
loc_0_F23D:                         ; sub_0_F1F2+1Fj
                LDA     $C8
                BNE     loc_0_F247
                LDA     $63,X
                CMP     #$C0
                BCC     loc_0_F21D
loc_0_F247:                         ; sub_0_F1F2+4Dj
                LDA     $64,X
                CMP     #$80
                BCC     loc_0_F236
loc_0_F24D:                         ; sub_0_F1F2+29j sub_0_F1F2+42j
                                    ; sub_0_F1F2+70j
                LDA     #$10
                STA     $C8,X
                LDA     #0
                STA     $CF,X
                LDA     #1
                STA     $CE,X
                RTS     
loc_0_F25A:                         ; sub_0_F1F2+38j
                LDA     $64,X
                LDY     $C8
                BEQ     loc_0_F264
                CMP     #$40
                BCC     loc_0_F24D
loc_0_F264:                         ; sub_0_F1F2+6Cj
                CMP     #$C0
                BCC     loc_0_F236
                LDA     #$40
                STA     $CF,X
                LDA     #0
                STA     $CE,X
                STA     $C8,X
                RTS     
; End of function sub_0_F1F2
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
sub_0_F273:                         ; sub_0_F1E5+6p
                LDA     $20,X
                BEQ     locret_0_F2AA
                BMI     loc_0_F2AB
                CLC     
                LDA     #$30
                ADC     $CD,X
                STA     $CD,X
                LDA     #0
                ADC     $CC,X
                STA     $CC,X
                CLC     
                LDA     $CD,X
                ADC     $C2,X
                STA     $C2,X
                LDA     $CC,X
                ADC     $C1,X
                CMP     #$B8
                BCC     loc_0_F2A4
                TXA     
                BNE     loc_0_F2B6
                LDA     $60,X
                AND     #$30
                STA     $81,X
loc_0_F29E:                         ; sub_0_F273+51j
                LDA     #0
                STA     $20,X
                LDA     #$B8
loc_0_F2A4:                         ; sub_0_F273+20j
                STA     $C1,X
                LDA     #3
                STA     $C5,X
locret_0_F2AA:                      ; sub_0_F273+2j
                RTS     
loc_0_F2AB:                         ; sub_0_F273+4j
                DEC     $20,X
                LDA     #$FD
                STA     $CC,X
                LDA     #0
                STA     $CD,X
                RTS     
loc_0_F2B6:                         ; sub_0_F273+23j
                STA     $C8,X
                LDA     #1
                STA     $CE,X
                LDA     #$C0
                STA     $CF,X
                LDA     #$FF
                STA     $81,X
                BNE     loc_0_F29E
; End of function sub_0_F273
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
sub_0_F2C6:                         ; sub_0_F1E5+9p
                LDA     $B0
                BNE     locret_0_F2E7
                LDA     $A1,X
                BNE     locret_0_F2E7
                LDA     $C0,X
                BEQ     locret_0_F2E7
                LDA     $62,X
                ORA     #$10
                AND     #$3C
                STA     $81,X
                LDY     #$10
loc_0_F2DC:                         ; sub_0_F2C6+1Dj
                LDA     $F094,X
                STA     $C0,X
                INX     
                DEY     
                BNE     loc_0_F2DC
                STY     $B0,X
locret_0_F2E7:                      ; sub_0_F2C6+2j sub_0_F2C6+6j
                                    ; sub_0_F2C6+Aj
                RTS     
; End of function sub_0_F2C6
unk_0_F2E8:     .BYTE    0 ;        ; sub_0_F2EC+38r
                .BYTE    2 ;  
                .BYTE    1 ;  
                .BYTE    2 ;  
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
sub_0_F2EC:                         ; sub_0_F1E5+3p
                LDA     $C0,X
                BNE     locret_0_F329
                CLC     
                LDA     $CF,X
                ADC     $C4,X
                STA     $C4,X
                LDA     $CE,X
                ADC     $C3,X
                LDY     $B0
                CPY     #$20
                BCS     loc_0_F315
                CMP     #$F8
                BCC     loc_0_F32A
                CPY     #$1F
                BCS     loc_0_F315
                LDA     $60,X
                AND     #$2F
                ORA     #6
                STA     $A1,X
                LDA     #$80
                STA     $C0,X
loc_0_F315:                         ; sub_0_F2EC+13j sub_0_F2EC+1Bj
                                    ; sub_0_F2EC+40j sub_0_F2EC+44j
                                    ; sub_0_F2EC+48j sub_0_F2EC+54j
                STA     $C3,X
                LSR     A
                LSR     A
                AND     #3
                TAY     
                LDA     $CE,X
                ORA     $CF,X
                BNE     loc_0_F324
                LDY     #1
loc_0_F324:                         ; sub_0_F2EC+34j
                LDA     unk_0_F2E8,Y
                STA     $C5,X
locret_0_F329:                      ; sub_0_F2EC+2j
                RTS     
loc_0_F32A:                         ; sub_0_F2EC+17j
                CMP     #$78
                BNE     loc_0_F315
                CPX     $22
                BNE     loc_0_F315
                LDY     $20,X
                BNE     loc_0_F315
                LDY     #0
                STY     $CE,X
                STY     $CF,X
                LDY     #$80
                STY     $20,X
                BNE     loc_0_F315
; End of function sub_0_F2EC
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
sub_0_F342:                         ; EF14p
                LDA     $B0
                BNE     locret_0_F36D
                LDA     $C0
                ORA     $D0
                BNE     locret_0_F36D
                CLC     
                LDA     $C3
                ADC     #$19
                CMP     $D3
                BCC     locret_0_F36D
                STA     $D3
                LDA     #2
                STA     $CE
                STA     $DE
                LDA     #0
                STA     $CF
                STA     $DF
                LDA     #$10
                STA     $C8
                STA     $D8
                LDA     #$30
                STA     $B0
locret_0_F36D:                      ; sub_0_F342+2j sub_0_F342+8j
                                    ; sub_0_F342+11j
                RTS     
; End of function sub_0_F342
pal1:           .BYTE $2A, $A, $25, 5, $21, 1, $27, $16 ; sub_0_F376+62r
                                    ; sub_0_F376+67r
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
sub_0_F376:                         ; EF8Bp
                LDY     #8
                LDA     $83
                BNE     loc_0_F3C8
                LDA     $93
                BNE     loc_0_F3EF
                LDX     #0
loc_0_F382:                         ; sub_0_F376+2Cj
                LDA     $C1,X
                CMP     #$A4
                BCS     loc_0_F39E
                LDA     #$20
                LDY     $B2
                BNE     loc_0_F39C
                LDA     #8
                LDY     $65
                CPY     #$18
                BCS     loc_0_F39C
                LDA     #8
                STA     $B2
                LDA     #$20
loc_0_F39C:                         ; sub_0_F376+16j sub_0_F376+1Ej
                STA     $83,X
loc_0_F39E:                         ; sub_0_F376+10j
                CPX     #$10
                LDX     #$10
                BCC     loc_0_F382
                LDA     $22
                BEQ     locret_0_F3C7
                LDA     $82
                BNE     locret_0_F3C7
                LDA     #8
                STA     $82
                LDX     #$F
                LDA     $47
                CMP     #$F
                BNE     loc_0_F3BA
                LDX     #$16
loc_0_F3BA:                         ; sub_0_F376+40j
                STX     $47
loc_0_F3BC:                         ; sub_0_F376+76j
                LDA     #$3F
                LDX     #8
                LDY     #8
                JSR     listadd     ; add to vram list
                                    ; A:X=VADDR, Y=count, next word=data ptr
                .WORD $40
locret_0_F3C7:                      ; sub_0_F376+30j sub_0_F376+34j
                RTS     
loc_0_F3C8:                         ; sub_0_F376+4j sub_0_F376+59j
                LDA     pal0-1,Y
                STA     $3F,Y
                DEY     
                BNE     loc_0_F3C8
                INC     $21
                LDA     $21
                AND     #6
                TAY     
                LDA     pal1,Y
                STA     $42
                LDA     pal1+1,Y
                STA     $43
                LDY     #0
                LDA     $B2
                BNE     loc_0_F3EA
                LDY     #$10
loc_0_F3EA:                         ; sub_0_F376+70j sub_0_F376+82j
                STY     $22
                JMP     loc_0_F3BC
loc_0_F3EF:                         ; sub_0_F376+8j sub_0_F376+80j
                LDA     pal2-1,Y
                STA     $3F,Y
                DEY     
                BNE     loc_0_F3EF
                BEQ     loc_0_F3EA
; End of function sub_0_F376
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; titlesrceen init?
sub_0_F3FA:                         ; EEC9p EF6Ep
                JSR     screenoff   ; BG+OBJ off
                LDA     #0
                LDX     #$58
                LDY     #$13
                JSR     copyCHR     ; Y:A=vram addr  X=tile count
                                    ; word after call=CPU addr
                                    ; A&$0F=CHR type
                                    ; 
                                    ; bit 0=mask (0=$00, 1=$FF)
                                    ; bit 1=read/write
                                    ; bit 2,3=type
                                    ;   00: 2bpp
                                    ;   01: 1bpp (plane1=data, plane2=mask)
                                    ;   10: 1bpp (plane1=mask, plane2=data)
                                    ;   11: 1bpp (plane1=data^mask, plane2=data)
                .WORD unk_0_F735
                LDA     #0
                LDX     #$19
                LDY     #0
                JSR     copyCHR     ; Y:A=vram addr  X=tile count
                                    ; word after call=CPU addr
                                    ; A&$0F=CHR type
                                    ; 
                                    ; bit 0=mask (0=$00, 1=$FF)
                                    ; bit 1=read/write
                                    ; bit 2,3=type
                                    ;   00: 2bpp
                                    ;   01: 1bpp (plane1=data, plane2=mask)
                                    ;   10: 1bpp (plane1=mask, plane2=data)
                                    ;   11: 1bpp (plane1=data^mask, plane2=data)
                .WORD unk_0_FCA5
                JSR     setupfont
                LDA     #$20
                LDX     #$6D
                LDY     #$AA
                JSR     vramfill    ; A=addr*256, X=val, Y=count or attrib
                                    ; if A<$2000, fill Y*256 bytes with X
                                    ; else fill NT with X, attrib with Y
                                    ; 
                LDA     #$28
                LDX     #$6D
                LDY     #$AA
                JSR     vramfill    ; A=addr*256, X=val, Y=count or attrib
                                    ; if A<$2000, fill Y*256 bytes with X
                                    ; else fill NT with X, attrib with Y
                                    ; 
                JSR     waitNMI     ; wait for vblank with NMI
                JSR     vramscript
                .WORD _3f08
                RTS     
; End of function sub_0_F3FA
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
copyrightcheck:                     ; EF62p
                JSR     screenoff   ; BG+OBJ off
                LDY     #3
                JSR     sub_0_F48C
                JSR     setupfont
                JSR     waitNMI     ; wait for vblank with NMI
                JSR     vramscript
                .WORD _3f00         ; palette
                LDA     #$20
                LDX     #$24
                LDY     #0
                JSR     vramfill    ; A=addr*256, X=val, Y=count or attrib
                                    ; if A<$2000, fill Y*256 bytes with X
                                    ; else fill NT with X, attrib with Y
                                    ; 
                LDA     $FF
                AND     #11111011b
                STA     $FF
                STA     $2000
                LDX     $2002
                LDX     #$28
                STX     $2006
                LDA     #0
                STA     $2006       ; VADDR=2800
                LDA     $2007
                LDY     #0
cpy0:                               ; copyrightcheck+42j
                LDA     $2007
                CMP     kyodaku,Y   ; copyright screen
                BNE     cpy2
                INY     
                CPY     #$E0
                BNE     cpy0
                STX     $2006
                STY     $2006       ; VADDR=28E0
cpy1:                               ; copyrightcheck+50j
                LDA     #$24
                STA     $2007
                INY     
                BNE     cpy1
cpy2:                               ; copyrightcheck+3Dj
                RTS     
; End of function copyrightcheck
byte_0_F484:    .BYTE 2, $30, $10, $29 ; sub_0_F48C+2r
                .BYTE $32, 0, $29, $10
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
sub_0_F48C:                         ; EFDCp copyrightcheck+5p
                LDX     #3
loc_0_F48E:                         ; sub_0_F48C+9j
                LDA     byte_0_F484,Y
                STA     7,X
                DEY     
                DEX     
                BPL     loc_0_F48E
                LDA     #$29
                STA     $B
loc_0_F49B:                         ; sub_0_F48C+3Dj
                LDA     7
                LDX     #1
                LDY     9
                JSR     copyCHR     ; Y:A=vram addr  X=tile count
                                    ; word after call=CPU addr
                                    ; A&$0F=CHR type
                                    ; 
                                    ; bit 0=mask (0=$00, 1=$FF)
                                    ; bit 1=read/write
                                    ; bit 2,3=type
                                    ;   00: 2bpp
                                    ;   01: 1bpp (plane1=data, plane2=mask)
                                    ;   10: 1bpp (plane1=mask, plane2=data)
                                    ;   11: 1bpp (plane1=data^mask, plane2=data)
                .WORD $10
                LDA     8
                LDX     #1
                LDY     $A
                JSR     copyCHR     ; Y:A=vram addr  X=tile count
                                    ; word after call=CPU addr
                                    ; A&$0F=CHR type
                                    ; 
                                    ; bit 0=mask (0=$00, 1=$FF)
                                    ; bit 1=read/write
                                    ; bit 2,3=type
                                    ;   00: 2bpp
                                    ;   01: 1bpp (plane1=data, plane2=mask)
                                    ;   10: 1bpp (plane1=mask, plane2=data)
                                    ;   11: 1bpp (plane1=data^mask, plane2=data)
                .WORD $10
                LDY     #1
loc_0_F4B3:                         ; sub_0_F48C+39j
                CLC     
                LDA     #$10
                ADC     7,Y
                STA     7,Y
                LDA     #0
                ADC     9,Y
                STA     9,Y
                DEY     
                BPL     loc_0_F4B3
                DEC     $B
                BNE     loc_0_F49B
                RTS     
; End of function sub_0_F48C
diagnose:
                LDA     #$20
                LDX     #$24
                LDY     #0
                JSR     vramfill    ; A=addr*256, X=val, Y=count or attrib
                                    ; if A<$2000, fill Y*256 bytes with X
                                    ; else fill NT with X, attrib with Y
                                    ; 
                JSR     waitNMI     ; wait for vblank with NMI
                JSR     vramscript
                .WORD pram_cram_ok
                JSR     checksram   ; scan for bad sram ($6000-$DFFF)
                                    ; leave final address in tmp0, Z=0 on error
                BNE     sramerror
                LDA     #0          ; $C000->$0000 CHR write
                LDX     #0
                LDY     #0
                JSR     copyCHR     ; Y:A=vram addr  X=tile count
                                    ; word after call=CPU addr
                                    ; A&$0F=CHR type
                                    ; 
                                    ; bit 0=mask (0=$00, 1=$FF)
                                    ; bit 1=read/write
                                    ; bit 2,3=type
                                    ;   00: 2bpp
                                    ;   01: 1bpp (plane1=data, plane2=mask)
                                    ;   10: 1bpp (plane1=mask, plane2=data)
                                    ;   11: 1bpp (plane1=data^mask, plane2=data)
                .WORD $C000
                LDA     #0          ; $D000->$1000 CHR write
                LDX     #0
                LDY     #$10
                JSR     copyCHR     ; Y:A=vram addr  X=tile count
                                    ; word after call=CPU addr
                                    ; A&$0F=CHR type
                                    ; 
                                    ; bit 0=mask (0=$00, 1=$FF)
                                    ; bit 1=read/write
                                    ; bit 2,3=type
                                    ;   00: 2bpp
                                    ;   01: 1bpp (plane1=data, plane2=mask)
                                    ;   10: 1bpp (plane1=mask, plane2=data)
                                    ;   11: 1bpp (plane1=data^mask, plane2=data)
                .WORD $D000
                LDA     #10b        ; $C000<-$0000 CHR read
                LDX     #0
                LDY     #0
                JSR     copyCHR     ; Y:A=vram addr  X=tile count
                                    ; word after call=CPU addr
                                    ; A&$0F=CHR type
                                    ; 
                                    ; bit 0=mask (0=$00, 1=$FF)
                                    ; bit 1=read/write
                                    ; bit 2,3=type
                                    ;   00: 2bpp
                                    ;   01: 1bpp (plane1=data, plane2=mask)
                                    ;   10: 1bpp (plane1=mask, plane2=data)
                                    ;   11: 1bpp (plane1=data^mask, plane2=data)
                .WORD $C000
                LDA     #10b        ; $D000<-$1000 CHR read
                LDX     #0
                LDY     #$10
                JSR     copyCHR     ; Y:A=vram addr  X=tile count
                                    ; word after call=CPU addr
                                    ; A&$0F=CHR type
                                    ; 
                                    ; bit 0=mask (0=$00, 1=$FF)
                                    ; bit 1=read/write
                                    ; bit 2,3=type
                                    ;   00: 2bpp
                                    ;   01: 1bpp (plane1=data, plane2=mask)
                                    ;   10: 1bpp (plane1=mask, plane2=data)
                                    ;   11: 1bpp (plane1=data^mask, plane2=data)
                .WORD $D000
                LDA     #$C0        ; check for CHR error:
                STA     1
                LDY     #0
                STY     0
                LDX     #$20
                LDA     #$7F
                ADC     #2          ; V=1
                JSR     checkmem    ; check mem $C000-D000
                BEQ     diag0
                LDA     1
                AND     #3
                STA     1
sramerror:                          ; F4E0j
                LDA     #$11        ; print (tmp0)H to $0007
                                    ; (show bad address)
                STA     $B
                LDY     #3
                LDA     0
serr0:                              ; F541j
                TAX     
                AND     #$F
                STA     7,Y
                DEY     
                TXA     
                LSR     A
                LSR     A
                LSR     A
                LSR     A
                STA     7,Y
                LDA     1
                DEY     
                BPL     serr0
                LDA     #$20
                LDX     #$F4
                LDY     #5
                JSR     listadd     ; add to vram list
                                    ; A:X=VADDR, Y=count, next word=data ptr
                .WORD 7
diag0:                              ; F51Fj
                JSR     setupfont
                JSR     joyread     ; read joypad state
                LDA     $F7
                CMP     #10000001b  ; right+A?
                BNE     diag1       ; normal test screen (ram+port)
                JSR     vramscript  ; show some text
                .WORD rominfo
                JSR     waitNMI     ; wait for vblank with NMI
                JSR     setscroll   ; set $2000,$2005
                JSR     BGon
jmploop:                            ; F568j
                JMP     jmploop
rominfo:        .BYTE $20, $E7      ; F55Do
                                    ; "2C33 INTERNAL ROM"
                .BYTE $11
                .BYTE 2, $C, 3, 3, $24, $12, $17, $1D, $E, $1B, $17, $A, $15, $24, $1B, $18, $16
                .BYTE $21, $63      ; "PROGRAMED BY TAKAO SAWANO"
                .BYTE $19
                .BYTE $19, $1B, $18, $10, $1B, $A, $16, $E, $D, $24, $B, $22, $24, $1D, $A, $14, $A
                .BYTE $18, $24, $1C, $A, $20, $A, $17, $18
                .BYTE $21, $A3      ; "NINTENDO CO.,LTD. DEV.NO.2"
                .BYTE 25
                .BYTE $17, $12, $17, $1D, $E, $17, $D, $18, $24, $C, $18, $27, $15, $1D, $D, $26, $24
                .BYTE $D, $E, $1F, $26, $17, $18, $26, 2
                .BYTE $FF           ; end
diag1:                              ; F558j
                LDA     #1          ; normal test screen (ram+port)
                STA     $F
                LDA     #$FF
                CLC     
                PHA     
                PHP     
diag2:                              ; F5F8j
                JSR     waitNMI     ; wait for vblank with NMI
                JSR     vramlistcopy ; copy $3xx list to vram and clear list
                JSR     setscroll   ; set $2000,$2005
                JSR     BGon
                DEC     $F
                BNE     diag3
                PLP     
                PLA     
                STA     $4026
                ROL     A
                PHA     
                PHP     
                LDA     #$19
                STA     $F
diag3:                              ; F5CFj
                LDA     $4033
                LDX     #7
diag4:                              ; F5EBj
                LDY     #1
                ASL     A
                BCS     diag5
                DEY     
diag5:                              ; F5E5j
                STY     7,X
                DEX     
                BPL     diag4
                LDA     #$21
                LDX     #$70
                LDY     #8
                JSR     listadd     ; add to vram list
                                    ; A:X=VADDR, Y=count, next word=data ptr
                .WORD 7
                JMP     diag2
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; scan for bad sram ($6000-$DFFF)
; leave final address in tmp0, Z=0 on error
checksram:                          ; EF67p F4DDp
                LDA     #$60
                LDX     #$80
                STX     3
                PHA     
                STA     1
                LDY     #0
                STY     0           ; tmp0=$6000
                CLV                 ; V=0
                JSR     checkmem    ; Y=$00, X=size*256
                                    ; if V=0:
                                    ;   fill (tmp0) with incrementing values
                                    ; if V=1:
                                    ;   compare (tmp0) with incrementing values
                                    ;   stop on incorrect value and store address in tmp0, Z=0
                PLA                 ; A=$60
                STA     1
                STY     0           ; Y=$00
                LDX     3           ; X=$80
                LDA     #$7F
                ADC     #2          ; V=1
                JSR     checkmem    ; Y=$00, X=size*256
                                    ; if V=0:
                                    ;   fill (tmp0) with incrementing values
                                    ; if V=1:
                                    ;   compare (tmp0) with incrementing values
                                    ;   stop on incorrect value and store address in tmp0, Z=0
                RTS     
; End of function checksram
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
; Y=$00, X=size*256
; if V=0:
;   fill (tmp0) with incrementing values
; if V=1:
;   compare (tmp0) with incrementing values
;   stop on incorrect value and store address in tmp0, Z=0
checkmem:                           ; F51Cp checksram+Ep checksram+1Cp
                                    ; checkmem+10j
                STX     2
chk0:                               ; checkmem+Bj
                LDA     2
                BVS     chk2
                STA     (0),Y
chk1:                               ; checkmem+15j
                INC     2
                DEY     
                BNE     chk0
                INC     1
                DEX     
                BNE     checkmem    ; Y=$00, X=size*256
                                    ; if V=0:
                                    ;   fill (tmp0) with incrementing values
                                    ; if V=1:
                                    ;   compare (tmp0) with incrementing values
                                    ;   stop on incorrect value and store address in tmp0, Z=0
                RTS     
chk2:                               ; checkmem+4j
                CMP     (0),Y
                BEQ     chk1
                STY     0
                RTS     
; End of function checkmem
pal0:           .BYTE $F, $30, $27, $16, $F, $10, 0, $16 ; sub_0_F376+52r
                                    ; looks like palette
_3f08:          .BYTE $3F, 8        ; sub_0_F3FA+34o
                .BYTE $18
pal2:           .BYTE $F, $21, 1, $F, $F, 0, 2, 1, $F, $27, $16, 1, $F, $27, $30, $1A, $F, $F, 1, $F
                                    ; sub_0_F376+79r
                .BYTE $F, $F, $F, $F
                .BYTE $20, $E4      ; *
                .BYTE 2
                .BYTE $6E, $73
                .BYTE $20, $E6      ; *
                .BYTE $54
                .BYTE $77
                .BYTE $20, $FA      ; *
                .BYTE 2
                .BYTE $78, $7C
                .BYTE $21, 4        ; *
                .BYTE 2
                .BYTE $6F, $74
                .BYTE $21, 6        ; *
                .BYTE $54
                .BYTE $24
                .BYTE $21, $1A      ; *
                .BYTE 2
                .BYTE $79, $7D
                .BYTE $21, $24      ; *
                .BYTE $C5
                .BYTE $70
                .BYTE $21, $3B      ; *
                .BYTE $C5
                .BYTE $70
                .BYTE $21, $25      ; *
                .BYTE $C5
                .BYTE $24
                .BYTE $21, $3A      ; *
                .BYTE $C5
                .BYTE $24
                .BYTE $21, $C4      ; *
                .BYTE 2
                .BYTE $71, $75
                .BYTE $21, $C6      ; *
                .BYTE $54
                .BYTE $24
                .BYTE $21, $DA      ; *
                .BYTE 2
                .BYTE $7A, $7E
                .BYTE $21, $E4      ; *
                .BYTE 2
                .BYTE $72, $76
                .BYTE $21, $E6      ; *
                .BYTE $54
                .BYTE $77
                .BYTE $21, $FA
                .BYTE 2
                .BYTE $7B, $7F
                .BYTE $21, $26      ; *
                .BYTE $14
                .BYTE $30, $34, $38, $3B, $3F, $24, $24, $47, $4B, $24, $24, $24, $24, $24, $24, $5D
                .BYTE $61, $24, $24, $28
                .BYTE $21, $46      ; *
                .BYTE $14
                .BYTE $31, $35, $32, $3C, $40, $43, $46, $48, $4C, $4E, $51, $3C, $54, $57, $5A, $5E
                .BYTE $62, $65, $68, $6B
                .BYTE $21, $66      ; *
                .BYTE $14
                .BYTE $32, $36, $39, $3D, $41, $44, $32, $49, $4D, $4F, $52, $3D, $55, $58, $5B, $5F
                .BYTE $63, $66, $69, $6C
                .BYTE $21, $86      ; *
                .BYTE $14
                .BYTE $33, $37, $3A, $3E, $42, $45, $33, $4A, $45, $50, $53, $3E, $56, $59, $5C, $60
                .BYTE $64, $67, $6A, $24
                .BYTE $21, $A6      ; *
                .BYTE $54
                .BYTE $24
replaces_80f1:
                LDA     $753
                BNE     locret_0_F70B
                ASL     $702
                ROL     $701
locret_0_F70B:                      ; F703j
                RTS     
                .BYTE  $86 ; 
                .BYTE  $23 ; #      ; *
                .BYTE  $E0 ; р
                .BYTE  $50 ; P
                .BYTE  $FF ;  
                .BYTE  $23 ; #      ; *
                .BYTE  $F0 ; №
                .BYTE  $48 ; H
                .BYTE  $AF ; Џ
                .BYTE  $FF ;        ; end
unk_0_F716:     .BYTE  $20 ;        ; sub_0_F0E1+3o
                .BYTE  $40 ; @
                .BYTE  $60 ; `
                .BYTE  $80 ; 
                .BYTE  $20 ;        ; *
                .BYTE  $20 ;  
                .BYTE  $60 ; `
                .BYTE  $81 ; 
                .BYTE  $20 ;        ; *
                .BYTE    0 ;  
                .BYTE  $60 ; `
                .BYTE  $81 ; 
                .BYTE  $FF ;        ; end
_2340:          .BYTE  $23 ; #      ; sub_0_F0E7+3o
                .BYTE  $40 ; @
                .BYTE  $60 ; `
                .BYTE  $80 ; 
                .BYTE  $23 ; #      ; *
                .BYTE  $60 ; `
                .BYTE  $60 ; `
                .BYTE  $81 ; 
                .BYTE  $FF ;        ; end
_2380:          .BYTE  $23 ; #      ; sub_0_F0ED+3o
                .BYTE  $80 ; 
                .BYTE  $60 ; `
                .BYTE  $82 ; 
                .BYTE  $23 ; #      ; *
                .BYTE  $A0 ;  
                .BYTE  $60 ; `
                .BYTE  $82 ; 
                .BYTE  $FF ;        ; end
unk_0_F735:     .BYTE  $FF ;        ; sub_0_F3FA+Co
                .BYTE  $C0 ; Р
                .BYTE  $C0 ; Р
                .BYTE  $C0 ; Р
                .BYTE  $C0 ; Р
                .BYTE  $C0 ; Р
                .BYTE  $C0 ; Р
                .BYTE  $C0 ; Р
                .BYTE  $80 ; 
                .BYTE  $BF ; П
                .BYTE  $BF ; П
                .BYTE  $BF ; П
                .BYTE  $BF ; П
                .BYTE  $BF ; П
                .BYTE  $BF ; П
                .BYTE  $BF ; П
                .BYTE  $C0 ; Р
                .BYTE  $C0 ; Р
                .BYTE  $C0 ; Р
                .BYTE  $C0 ; Р
                .BYTE  $C0 ; Р
                .BYTE  $C0 ; Р
                .BYTE  $C0 ; Р
                .BYTE  $C0 ; Р
                .BYTE  $BF ; П
                .BYTE  $BF ; П
                .BYTE  $BF ; П
                .BYTE  $BF ; П
                .BYTE  $BF ; П
                .BYTE  $BF ; П
                .BYTE  $BF ; П
                .BYTE  $BF ; П
                .BYTE  $C0 ; Р
                .BYTE  $C0 ; Р
                .BYTE  $C0 ; Р
                .BYTE  $C0 ; Р
                .BYTE  $C0 ; Р
                .BYTE  $C0 ; Р
                .BYTE  $C0 ; Р
                .BYTE  $C0 ; Р
                .BYTE  $BF ; П
                .BYTE  $BF ; П
                .BYTE  $BF ; П
                .BYTE  $BF ; П
                .BYTE  $BF ; П
                .BYTE  $BF ; П
                .BYTE  $BF ; П
                .BYTE  $BF ; П
                .BYTE  $C0 ; Р
                .BYTE  $C0 ; Р
                .BYTE  $C0 ; Р
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $BF ; П
                .BYTE  $BF ; П
                .BYTE  $BF ; П
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $7F ; 
                .BYTE  $7F ; 
                .BYTE  $3F ; ?
                .BYTE  $3F ; ?
                .BYTE  $1F ;  
                .BYTE  $1F ;  
                .BYTE   $F ;  
                .BYTE   $F ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE    7 ;  
                .BYTE  $87 ; 
                .BYTE  $83 ; 
                .BYTE  $C3 ; У
                .BYTE  $C1 ; С
                .BYTE  $E1 ; с
                .BYTE  $E0 ; р
                .BYTE  $F0 ; №
                .BYTE  $FF ;  
                .BYTE  $7F ; 
                .BYTE  $7F ; 
                .BYTE  $BF ; П
                .BYTE  $BF ; П
                .BYTE  $DF ; п
                .BYTE  $DF ; п
                .BYTE  $EF ; я
                .BYTE  $F0 ; №
                .BYTE  $F8 ; ј
                .BYTE  $F8 ; ј
                .BYTE  $FC ; ќ
                .BYTE  $FC ; ќ
                .BYTE  $FE ; ў
                .BYTE  $FE ; ў
                .BYTE  $FF ;  
                .BYTE  $EF ; я
                .BYTE  $F7 ; ї
                .BYTE  $F7 ; ї
                .BYTE  $FB ; ћ
                .BYTE  $FB ; ћ
                .BYTE  $FD ; §
                .BYTE  $FD ; §
                .BYTE  $FE ; ў
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FE ; ў
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $C0 ; Р
                .BYTE  $C0 ; Р
                .BYTE  $C0 ; Р
                .BYTE  $C0 ; Р
                .BYTE  $C0 ; Р
                .BYTE  $C0 ; Р
                .BYTE  $C0 ; Р
                .BYTE  $80 ; 
                .BYTE  $BF ; П
                .BYTE  $BF ; П
                .BYTE  $BF ; П
                .BYTE  $BF ; П
                .BYTE  $BF ; П
                .BYTE  $BF ; П
                .BYTE  $BF ; П
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE    0 ;  
                .BYTE  $80 ; 
                .BYTE  $80 ; 
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $7F ; 
                .BYTE  $7F ; 
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $E0 ; р
                .BYTE  $E0 ; р
                .BYTE  $E0 ; р
                .BYTE  $E0 ; р
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $C0 ; Р
                .BYTE  $DF ; п
                .BYTE  $DF ; п
                .BYTE  $DF ; п
                .BYTE  $DF ; п
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $E0 ; р
                .BYTE  $E0 ; р
                .BYTE  $E0 ; р
                .BYTE  $E0 ; р
                .BYTE  $E0 ; р
                .BYTE  $E0 ; р
                .BYTE  $E0 ; р
                .BYTE  $C0 ; Р
                .BYTE  $DF ; п
                .BYTE  $DF ; п
                JSR     $61A2       ; softirq
                JSR     $D2A0       ; write to irq and sound ctrl regs
                RTS     
                .BYTE  $E0 ; р
                .BYTE  $E0 ; р
                .BYTE  $E0 ; р
                .BYTE  $E0 ; р
                .BYTE  $E0 ; р
                .BYTE  $E0 ; р
                .BYTE  $DF ; п
                .BYTE  $DF ; п
                .BYTE  $DF ; п
                .BYTE  $DF ; п
                .BYTE  $DF ; п
                .BYTE  $DF ; п
                .BYTE  $DF ; п
                .BYTE  $DF ; п
                .BYTE  $E0 ; р
                .BYTE  $E0 ; р
                .BYTE  $E0 ; р
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $DF ; п
                .BYTE  $DF ; п
                .BYTE  $DF ; п
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $7F ; 
                .BYTE  $7F ; 
                .BYTE  $7F ; 
                .BYTE  $7F ; 
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $7F ; 
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $70 ; p
                .BYTE  $70 ; p
                .BYTE  $70 ; p
                .BYTE  $70 ; p
                .BYTE  $70 ; p
                .BYTE  $70 ; p
                .BYTE  $70 ; p
                .BYTE  $60 ; `
                .BYTE  $EF ; я
                .BYTE  $EF ; я
                .BYTE  $EF ; я
                .BYTE  $EF ; я
                .BYTE  $EF ; я
                .BYTE  $EF ; я
                .BYTE  $EF ; я
                .BYTE  $70 ; p
                .BYTE  $70 ; p
                .BYTE  $70 ; p
                .BYTE  $70 ; p
                .BYTE  $70 ; p
                .BYTE  $70 ; p
                .BYTE  $70 ; p
                .BYTE  $70 ; p
                .BYTE  $EF ; я
                .BYTE  $EF ; я
                .BYTE  $EF ; я
_f850:
                LDA     #$58
                CMP     $16F
                BNE     loc_0_F864
                LDA     #8
                STA     $75F
                LDA     #$10
                STA     $6FC
loc_0_F861:                         ; F869j
                JMP     $C475
loc_0_F864:                         ; F855j
                LDA     $6FC
                AND     #$10
                BNE     loc_0_F861
                JMP     $C494
                .BYTE  $DF ; п
                .BYTE  $FF ;  
                .BYTE  $FE ; ў
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $3F ; ?
                .BYTE  $3F ; ?
                .BYTE  $3F ; ?
                .BYTE  $3F ; ?
                .BYTE  $3F ; ?
                .BYTE  $3F ; ?
                .BYTE  $3F ; ?
                .BYTE  $3F ; ?
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
;f880
                JSR     $671B
                LDA     #0
                STA     $16F
                RTS     
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $7F ; 
                .BYTE  $1F ;  
                .BYTE    7 ;  
                .BYTE  $81 ; 
                .BYTE  $81 ; 
                .BYTE  $C0 ; Р
                .BYTE  $C0 ; Р
                .BYTE  $7F ; 
                .BYTE  $9F ; 
                .BYTE  $E7 ; ч
                LDA     $7FB
                CMP     #0
                BNE     loc_0_F8AD
                LDA     $75F
                JMP     $702E
loc_0_F8AD:                         ; F8A5j
                LDA     $75F
                ASL     A
                TAX     
                LDA     $75C
                AND     #2
                BEQ     loc_0_F8BA
                INX     
loc_0_F8BA:                         ; F8B7j
                LDY     unk_0_F8C0,X
                JMP     $703B
unk_0_F8C0:     .BYTE  $66 ; f      ; F8BAr
                .BYTE  $60 ; `
                .BYTE  $88 ; 
                .BYTE  $60 ; `
                .BYTE  $66 ; f
                .BYTE  $30 ; 0
                .BYTE  $77 ; w
                .BYTE  $60 ; `
                .BYTE  $F0 ; №
                .BYTE  $F0 ; №
                .BYTE  $F0 ; №
                .BYTE  $F0 ; №
                .BYTE  $F0 ; №
                .BYTE  $EF ; я
                .BYTE  $EF ; я
                .BYTE  $EF ; я
unknown_f8d0
                LDA     byte_0_F8E0,X
                TAX     
                ;STA     $D900,X
                 nop
                 nop
                 nop
                ;STA     nmi
                 nop
                 nop
                 nop
                LDA     #0
                STA     $77B
                RTS     
byte_0_F8E0:    .BYTE $47, $4F, $57, $5F ; F8D0r bankswitchCXXX+8r
                .BYTE $67, $6F, $37, $3F
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $3F ; ?
                .BYTE  $3F ; ?
                .BYTE  $3F ; ?
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $3F ; ?
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $C7 ; Ч
                .BYTE    7 ;  
                .BYTE    7 ;  
                .BYTE  $3F ; ?
                .BYTE  $3F ; ?
                .BYTE  $3E ; >
                .BYTE  $3E ; >
                .BYTE  $3C ; <
                .BYTE  $3C ; <
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
loc_0_F900:                         ; 101=irqflags
                STA     $101
                LDA     #0
                STA     $1E5
              ;  STA     $6000
              nop
              nop
              nop
              
                JMP     setbankCXXXto0
                .BYTE  $4C ; L
                .BYTE    0 ;  

_f910:          PHA
                LDA     $1E6
                BEQ     loc_0_F959
                LDA     $1E5
                BNE     loc_0_F959
                LDA     $314
                PHA     
                LDA     $316
                PHA     
                JSR     $6750
                LDA     #$10
                STA     $2000
                LDA     #0
                STA     $2001
                LDX     $2002
                LDA     #$20
                STA     $2006
                LDA     #$73
                STA     $2006
                LDA     $314
                STA     $2007
                LDA     #$28
                STA     $2007
                LDA     $316
                STA     $2007
                PLA     
                STA     $316
                PLA     
                STA     $314
                DEC     $1E5
loc_0_F959:                         ; F914j F919j
                PLA     
                STA     $2001
                RTS     
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $C0 ; Р
                .BYTE  $DF ; п
                .BYTE  $DF ; п
                .BYTE  $DF ; п
                .BYTE  $BF ; П
                .BYTE  $87 ; 
                .BYTE   $F ;  
                .BYTE  $3F ; ?
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $7F ; 
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $40 ; @
                .BYTE    0 ;  
                .BYTE  $1C ;  
                .BYTE  $3F ; ?
                .BYTE  $3F ; ?
                .BYTE  $7F ; 
                .BYTE  $7F ; 
                .BYTE  $40 ; @
                .BYTE  $BF ; П
                .BYTE  $FF ;  
;F980
tinydelay:
                LDX     #19 ;#7
loc_0_F982:                         ; F983j
                DEX     
                BNE     loc_0_F982
                LDA     #1
                RTS     
;F988
tinierdelay:
                NOP     
                NOP     
                NOP     
                NOP     
                NOP     
                LDA     #1
                RTS     
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $7F ; 
                .BYTE  $7F ; 
                .BYTE  $7F ; 
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $3F ; ?
                .BYTE   $F ;  
                .BYTE    3 ;  
                .BYTE    3 ;  
                .BYTE  $81 ; 
                .BYTE  $81 ; 
                .BYTE  $FF ;  
                .BYTE  $3F ; ?
                .BYTE  $CF ; Я
                .BYTE  $F7 ; ї
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $7F ; 
                .BYTE  $7F ; 
                .BYTE  $81 ; 
                .BYTE  $81 ; 
                .BYTE  $81 ; 
                .BYTE  $81 ; 
                .BYTE  $81 ; 
                .BYTE  $81 ; 
                .BYTE  $81 ; 
                .BYTE  $81 ; 
                .BYTE  $7F ; 
                .BYTE  $7F ; 
                .BYTE  $7F ; 
                .BYTE  $7F ; 
                .BYTE  $7F ; 
                .BYTE  $7F ; 
                .BYTE  $7F ; 
                .BYTE  $7F ; 
                .BYTE  $81 ; 
                .BYTE  $81 ; 
                .BYTE  $81 ; 
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $7F ; 
                .BYTE  $7F ; 
                .BYTE  $7F ; 
                LDA     $F8E0,X
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FC ; ќ
                .BYTE  $F0 ; №
                .BYTE  $E0 ; р
                .BYTE  $E0 ; р
                .BYTE  $C0 ; Р
                .BYTE  $C0 ; Р
                .BYTE  $C0 ; Р
                .BYTE  $FC ; ќ
                .BYTE  $F3 ; ѓ
                .BYTE  $EF ; я
                .BYTE  $DF ; п
                .BYTE  $DF ; п
                .BYTE  $BF ; П
                .BYTE  $BF ; П
                .BYTE  $BF ; П
                .BYTE  $C0 ; Р
                .BYTE  $C0 ; Р
                .BYTE  $C0 ; Р
                .BYTE  $C0 ; Р
                .BYTE  $C0 ; Р
                .BYTE  $C0 ; Р
                .BYTE  $E0 ; р
                .BYTE  $E0 ; р
                .BYTE  $BF ; П
                .BYTE  $BF ; П
                .BYTE  $BF ; П
                .BYTE  $BF ; П
                .BYTE  $BF ; П
                .BYTE  $BF ; П
                .BYTE  $DF ; п
                .BYTE  $DF ; п
                .BYTE  $F0 ; №
                .BYTE  $F0 ; №
                .BYTE  $FC ; ќ
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $EF ; я
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                LDA     $753
                BNE     loc_0_FA12
loc_0_FA05:                         ; FA0Fj
                LDA     byte_0_FA20,Y
                STA     $304,X
                INY     
                INX     
                DEC     0
                BPL     loc_0_FA05
                RTS     
loc_0_FA12:                         ; FA03j FA1Cj
                LDA     byte_0_FA28,Y
                STA     $304,X
                INY     
                INX     
                DEC     0
                BPL     loc_0_FA12
                RTS     
                .BYTE  $FD ; §
byte_0_FA20:    .BYTE $22, $16, $27, $18 ; FA05r
                .BYTE $22, $37, $27, $16
byte_0_FA28:    .BYTE $22, $30, $27, $19 ; FA12r
                .BYTE $22, $37, $27, $16

;fa30:	blinky stars
                ldx $6000
                beq abort

		ldy #9
-               lda star_data-1,y
		sta $300,y
		dey
		bne -

                txa
                cmp #13
                bcs line2  ;>=13

		sty $305 ;clear 2nd strip
		ora #$40
                sta $303 ;set #stars
                bne fini
line2:
                cmp #24
                bcs fini
                sbc #11
		ora #$40
		sta $307 ;set #stars
fini:
		lda #0
		jmp $65a1	;sta $773 : inc $73c : rts
abort:          jmp $6613
star_data:
                .byte $20,$d0,$4c,$f1, $20,$f0,$4c,$f1, 0

        .pad $fa80

; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
bankswitchCXXX:                     ; switchCXXXandCHR+14p
                                    ; switchCXXXandCHR+41p
              lda #$c6  ;2
              sta $8000 ;3
              inx       ;1
              inx       ;1
              stx $8001 ;3

              ;2  LDA     #3          ; bankswitch $C000
              ;3  STA     byte_0_E000
              ;3  STX     byte_0_F000
                LDA     byte_0_F8E0,X
                TAX     
                LDA     #0
              ;3  STA     $D900,X
                STA     $77B
              ;2  LDA     #2
              ;2  BNE     $FAFB  ;(fafb= sta nmi : rts)

              rts

resetbanks: ;safe to assume X=0
    lda #$80
    sta $a001 ;sram enable
    lda #$c6
    sta $8000 ;change $C000 bank
    stx $8001 ;..to $6000 copy
  
  lda #$60   ;2  copy c000 to 6000
  sta $5     ;2
  lda #$c0   ;2
  sta $7     ;2
  ldy #0     ;2
  sty $4     ;2
  sty $6     ;2
     lda $6001
     cmp $c001
     beq bleh  ;check for uninitialized SRAM (don't overwrite saved #wins)
blah:
  lda ($6),y   ;2
  sta ($4),y   ;2
bleh:
  iny        ;1
  bne blah   ;2
  inc $7     ;2
  inc $5     ;2
  bpl blah   ;2=32

    lda #2
    sta $8001  ;set $c000
    lda #$c7
    sta $8000  ;set $a000
    lda #1
    sta $8001

              ;jmp timersetup
                 lda #$1c
                 sta $e000
                 sta $c000
                 sta $c001
                 sta $e001

               ;JMP     $fa78 ;(sta $f000:sta $c000:rts)
                 rts


          .pad $fb00
_fb00:
                LDA     $6FC
                AND     #$C0
                BEQ     loc_0_FB61
                LDX     $1E6
                BNE     loc_0_FB64
                AND     #$80
                BEQ     loc_0_FB22
                INC     $75C
                LDA     $75C
                AND     #3
                STA     $75C
                LDA     $6FC
                AND     #$40
                BEQ     loc_0_FB31
loc_0_FB22:                         ; FB0Ej
                INC     $75F
                LDA     $7FB
                BNE     loc_0_FB7A
                LDA     $75F
                CMP     #9
                BCS     loc_0_FB71
loc_0_FB31:                         ; FB20j FB7Fj FB89j
                LDA     #0
                STA     $1E5
                JMP     loc_0_FB5F
                .BYTE    1 ;  
                .BYTE  $20 ;  
                LDA     $2002
                LDA     #$20
                STA     $2006
                LDA     #$73
                STA     $2006
                LDA     $314
                STA     $2007
                LDA     #$28
                NOP     
                STA     $2007
                LDA     $316
                STA     $2007
                LDA     #$1E
                STA     $2001
loc_0_FB5F:                         ; FB36j FBBBj
                LDA     #-1
loc_0_FB61:                         ; FB05j
                STA     $1E6
loc_0_FB64:                         ; FB0Aj
                LDY     $75C
                BNE     loc_0_FB8B
                NOP     
loc_0_FB6A:                         ; FB95j FB99j FB9Dj FBA1j FBA5j FBA8j
                                    ; FBACj
                STY     $760
                LDA     $6FC
                RTS     
loc_0_FB71:                         ; FB2Fj
                LDY     #0
                STY     $75F
                INY     
                STY     $7FB
loc_0_FB7A:                         ; FB28j
                LDA     $75F
                CMP     #4
                BCC     loc_0_FB31
                LDA     #0
                STA     $75F
                STA     $7FB
                BEQ     loc_0_FB31
loc_0_FB8B:                         ; FB67j
                LDA     $75F
                LDX     $7FB
                BNE     loc_0_FBAA
                CMP     #1
                BEQ     loc_0_FB6A
                CMP     #3
                BEQ     loc_0_FB6A
                CMP     #6
                BEQ     loc_0_FB6A
                CMP     #7
                BEQ     loc_0_FB6A
                CMP     #8
                BEQ     loc_0_FB6A
loc_0_FBA7:                         ; FBAEj
                INY     
                BNE     loc_0_FB6A
loc_0_FBAA:                         ; FB91j
                AND     #2
                BNE     loc_0_FB6A
                BEQ     loc_0_FBA7
                STA     $2005
                STA     $2005
                LDA     #$1E
                STA     $2001
                JMP     loc_0_FB5F

                .BYTE    5 ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $3F ; ?
                .BYTE  $1F ;  
                .BYTE  $FF ;  
                .BYTE  $E0 ; р
                .BYTE  $F9 ; љ
                .BYTE  $FC ; ќ
                .BYTE  $FE ; ў
                .BYTE  $FE ; ў
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;
                .BYTE  $FE ; ў
                .BYTE  $FF ;  
_fbd0: 
                  LDA $1E,X ;9fdc(9ffe) replacement
                  JMP $A000
              ;  .BYTE  $FF ;  
              ;  .BYTE  $FF ;
              ;  .BYTE  $FF ;  
              ;  .BYTE  $FF ;  
              ;  .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FE ; ў
                .BYTE  $FE ; ў
                .BYTE  $FC ; ќ
                .BYTE  $F9 ; љ
                .BYTE  $E3 ; у
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FE ; ў
                .BYTE  $FC ; ќ
                .BYTE   $E ;  
                .BYTE  $F8 ; ј
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE  $F1 ; ё
                .BYTE    7 ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FC ; ќ
                .BYTE    0 ;  
                .BYTE    1 ;  
                .BYTE  $FF ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE  $C0 ; Р
                .BYTE  $E0 ; р
;FC00
                BEQ jmp800C ;2
                LDA $704    ;3
                BEQ jmp8088 ;2
                jmp $8000   ;3
jmp8088:        jmp $8088   ;3
jmp800C:        jmp $800c   ;3=16

;                LDA     $1E7
;                CMP     #$5A
;                BEQ     locret_0_FC0A
;                DEC     $75A
;locret_0_FC0A:                      ; FC05j
;                RTS

             ;   .BYTE  $40 ; @
             ;   .BYTE  $40 ; @
             ;   .BYTE  $FE ; ў
             ;   .BYTE  $FA ; њ
             ;   .BYTE  $7B ; {
                .BYTE  $79 ; y
                .BYTE  $B9 ; Й
                .BYTE  $B9 ; Й
                .BYTE  $B9 ; Й
                .BYTE  $B9 ; Й
                .BYTE  $40 ; @
                .BYTE  $40 ; @
                .BYTE  $40 ; @
                .BYTE  $40 ; @
                .BYTE  $C0 ; Р
                .BYTE  $80 ; 
                .BYTE  $80 ; 
                .BYTE    0 ;  
                .BYTE  $B9 ; Й
                .BYTE  $B9 ; Й
                .BYTE  $B9 ; Й
                .BYTE  $B9 ; Й
                .BYTE  $39 ; 9
                .BYTE  $73 ; s
                .BYTE  $72 ; r
                .BYTE  $E2 ; т
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE  $E6 ; ц
                .BYTE  $C4 ; Ф
                .BYTE  $8C ; 
                .BYTE  $18 ;  
                .BYTE  $30 ; 0
                .BYTE  $60 ; `
                .BYTE  $C0 ; Р
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE  $FF ;  
                .BYTE    0 ;  
                .BYTE  $FF ;  
                .BYTE    0 ;  
                .BYTE  $FF ;  
                .BYTE    0 ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE    0 ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE    0 ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE    0 ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE    6 ;  
                .BYTE    6 ;  
                .BYTE    6 ;  
                .BYTE    6 ;  
                .BYTE    6 ;  
                .BYTE    6 ;  
                .BYTE    6 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE  $60 ; `
                .BYTE  $60 ; `
                .BYTE  $60 ; `
                .BYTE  $60 ; `
                .BYTE  $60 ; `
                .BYTE  $60 ; `
                .BYTE  $60 ; `
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE  $1F ;  
                .BYTE  $5F ; _
                .BYTE  $50 ; P
                .BYTE  $57 ; W
                .BYTE  $57 ; W
                .BYTE  $50 ; P
                .BYTE  $1F ;  
                .BYTE    0 ;  
                .BYTE  $20 ;  
                .BYTE  $20 ;  
                .BYTE  $AF ; Џ
                .BYTE  $A7 ; Ї
                .BYTE  $A7 ; Ї
                .BYTE  $AF ; Џ
                .BYTE  $60 ; `
                .BYTE  $3F ; ?
                .BYTE  $F8 ; ј
                .BYTE  $FA ; њ
                .BYTE   $A ;  
                .BYTE  $EA ; ъ
                .BYTE  $EA ; ъ
                .BYTE   $A ;  
                .BYTE  $F8 ; ј
                .BYTE    0 ;  
                .BYTE    4 ;  
                .BYTE    4 ;  
                .BYTE  $F5 ; ѕ
                .BYTE  $E5 ; х
                .BYTE  $E5 ; х
                .BYTE  $F5 ; ѕ
                .BYTE    6 ;  
                .BYTE  $FC ; ќ
unk_0_FCA5:     .BYTE    0 ;        ; sub_0_F3FA+17o
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    3 ;  
                .BYTE  $1F ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    3 ;  
                .BYTE    3 ;  
                .BYTE   $F ;  
                .BYTE    0 ;  
                .BYTE    2 ;  
                .BYTE  $3F ; ?
                .BYTE  $1F ;  
                .BYTE   $F ;  
                .BYTE    7 ;  
                .BYTE  $20 ;  
                .BYTE  $70 ; p
                .BYTE  $70 ; p
                .BYTE  $20 ;  
                .BYTE    4 ;  
                .BYTE  $1E ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    1 ;  
                .BYTE    3 ;  
                .BYTE   $F ;  
                .BYTE  $1F ;  
                .BYTE    0 ;  
                .BYTE    4 ;  
                .BYTE   $F ;  
                .BYTE  $1F ;  
                .BYTE   $F ;  
                .BYTE   $C ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE   $F ;  
                .BYTE    7 ;  
                .BYTE  $2F ; /
                .BYTE  $3F ; ?
                .BYTE  $3F ; ?
                .BYTE  $1C ;  
                .BYTE  $18 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE  $F0 ; №
                .BYTE  $F8 ; ј
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE  $80 ; 
                .BYTE  $E0 ; р
                .BYTE  $F0 ; №
                .BYTE  $F0 ; №
                .BYTE  $48 ; H
                .BYTE  $F8 ; ј
                .BYTE  $FC ; ќ
                .BYTE  $F8 ; ј
                .BYTE  $E0 ; р
                .BYTE  $10 ;  
                .BYTE  $10 ;  
                .BYTE  $32 ; 2
                .BYTE  $26 ; &
                .BYTE  $48 ; H
                .BYTE  $9C ; 
                .BYTE    8 ;  
                .BYTE    0 ;  
                .BYTE  $F0 ; №
                .BYTE  $FC ; ќ
                .BYTE  $FC ; ќ
                .BYTE  $F8 ; ј
                .BYTE  $7C ; |
                .BYTE  $F8 ; ј
                .BYTE  $F8 ; ј
                .BYTE  $FC ; ќ
                .BYTE  $FC ; ќ
                .BYTE  $78 ; x
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE  $F8 ; ј
                .BYTE  $F8 ; ј
                .BYTE  $F8 ; ј
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
setbankCXXXto0:                     ; EEE6p F90Bj
                LDA     #0
                BEQ     loc_0_FD0D
; End of function setbankCXXXto0
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
switchCXXXandCHR:                   ; E1FEp
                LDA     $7F7
                BNE     loc_0_FD54
                BEQ     loc_0_FD10
loc_0_FD0B:                         ; switchCXXXandCHR+57j
                LDA     #2
loc_0_FD0D:       ;setbankCXXXto0 jumps here   ;(2=princess CHR set)
                STA     $7F7
loc_0_FD10:                         ; switchCXXXandCHR+5j switchCXXXandCHR+55j
                ;if 7f7!=0 && level=8, 7f7=2

                LDA     $FE
                AND     #$E7    ;display off
                STA     $2001

                ldy #$c0
                ldx #0
                sty $8000
                 lda $7f7
                 cmp #2
                 bne asdf
                ldx #8
      asdf:     stx $8001       ;000-800

                iny
                sty $8000
                iny
                inx
                inx
                stx $8001       ;800-1000

                ldx #4
      jkl:
                sty $8000
                iny
                stx $8001
                inx

                txa
                and #8
                beq jkl
                ldy #0

             ;---
loc_0_FD42:
                LDX     $7F7
                JSR     bankswitchCXXX
                LDX     #$17
loc_0_FD4A:                         ; switchCXXXandCHR+4Dj
                LDA     $C52C,X
                STA     $1CC,X
                DEX     
                BPL     loc_0_FD4A
                RTS     
loc_0_FD54:                         ; switchCXXXandCHR+3j
                LDA     $75F        ;75f=world
                CMP     #8
                BNE     loc_0_FD10  ;if world!=8,
                BEQ     loc_0_FD0B  ;if world=8,

        .pad $fd60

                .BYTE  $F4 ; є
                .BYTE  $FE ; ў
                .BYTE  $7E ; ~
                .BYTE    2 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    3 ;  
                .BYTE  $1F ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    3 ;  
                .BYTE    3 ;  
                .BYTE   $F ;  
                .BYTE    0 ;  
                .BYTE    2 ;  
                .BYTE  $3F ; ?
                .BYTE  $1F ;  
                .BYTE   $F ;  
                .BYTE    7 ;  
                .BYTE    0 ;  
                .BYTE    1 ;  
                .BYTE    1 ;  
                .BYTE  $13 ;  
                .BYTE    4 ;  
                .BYTE  $1E ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    3 ;  
                .BYTE    7 ;  
                .BYTE   $F ;  
                .BYTE   $F ;  
                .BYTE  $1F ;  
                .BYTE  $1F ;  
                .BYTE   $F ;  
                .BYTE    7 ;  
                .BYTE    7 ;  
                .BYTE    3 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE   $F ;  
                .BYTE   $D ;  
                .BYTE   $F ;  
                .BYTE    7 ;  
                .BYTE    7 ;  
                .BYTE    3 ;  
                .BYTE    0 ;  
                .BYTE    1 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE  $F0 ; №
                .BYTE  $F8 ; ј
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE  $80 ; 
                .BYTE  $E0 ; р
                .BYTE  $F0 ; №
                .BYTE  $F0 ; №
                .BYTE  $48 ; H
                .BYTE  $F8 ; ј
                .BYTE  $FC ; ќ
                .BYTE  $F8 ; ј
                .BYTE  $E0 ; р
                .BYTE  $80 ; 
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE  $C0 ; Р
                .BYTE  $48 ; H
                .BYTE  $9C ; 
                .BYTE    8 ;  
                .BYTE    0 ;  
                .BYTE  $E0 ; р
                .BYTE  $F0 ; №
                .BYTE  $F8 ; ј
                .BYTE  $F8 ; ј
                .BYTE  $80 ; 
                .BYTE  $C0 ; Р
                .BYTE  $F0 ; №
                .BYTE  $F0 ; №
                .BYTE  $F0 ; №
                .BYTE  $E0 ; р
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE  $F8 ; ј
                .BYTE  $30 ; 0
                .BYTE  $10 ;  
                .BYTE  $30 ; 0
                .BYTE  $F0 ; №
                .BYTE  $E0 ; р
                .BYTE  $E0 ; р
                .BYTE  $E0 ; р
                .BYTE    0 ;  
                .BYTE  $1C ;  
                .BYTE  $1E ;  
                .BYTE   $E ;  
                .BYTE    4 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    7 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE  $10 ;  
                .BYTE  $18 ;  
                .BYTE  $3B ; ;
                .BYTE  $38 ; 8
                .BYTE  $38 ; 8
                .BYTE   $F ;  
                .BYTE    7 ;  
                .BYTE    3 ;  
                .BYTE    3 ;  
                .BYTE    6 ;  
                .BYTE   $C ;  
                .BYTE    9 ;  
                .BYTE   $F ;  
                .BYTE  $31 ; 1
                .BYTE  $3F ; ?
                .BYTE  $1C ;  
                .BYTE  $1E ;  
                .BYTE   $F ;  
                .BYTE   $F ;  
                .BYTE  $4F ; O
                .BYTE  $4F ; O
                .BYTE  $1F ;  
                .BYTE  $1F ;  
                .BYTE  $1F ;  
                .BYTE    7 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE  $7E ; ~
                .BYTE  $7F ; 
                .BYTE  $7F ; 
                .BYTE    7 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE  $FC ; ќ
                .BYTE  $FE ; ў
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE  $E0 ; р
                .BYTE  $F8 ; ј
                .BYTE  $FC ; ќ
                .BYTE  $3C ; <
                .BYTE  $92 ; 
                .BYTE  $FE ; ў
                .BYTE  $FF ;  
                .BYTE  $FE ; ў
                .BYTE  $F8 ; ј
                .BYTE  $60 ; `
                .BYTE  $C0 ; Р
                .BYTE  $83 ; 
                .BYTE  $87 ; 
                .BYTE  $12 ;  
                .BYTE  $A7 ; Ї
                .BYTE    2 ;  
                .BYTE    0 ;  
                .BYTE  $FC ; ќ
                .BYTE  $FE ; ў
                .BYTE  $FC ; ќ
                .BYTE  $F0 ; №
                .BYTE  $D2 ; в
                .BYTE  $F0 ; №
                .BYTE  $E0 ; р
                .BYTE  $F0 ; №
                .BYTE  $F0 ; №
                .BYTE  $60 ; `
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE  $F0 ; №
                .BYTE  $F8 ; ј
                .BYTE  $FC ; ќ
                .BYTE  $FE ; ў
                .BYTE  $F2 ; ђ
                .BYTE  $60 ; `
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE  $80 ; 
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE  $FF ;  
loc_0_FE36:                         ; sub_0_FF5C+Bj
                LSR     A
                BCS     loc_0_FE66
                LSR     $E1
                BCS     loc_0_FE47
                LSR     A
                BCS     loc_0_FEA6
                LSR     $E1
                BCS     loc_0_FE7A
                JMP     loc_0_FF6A
loc_0_FE47:                         ; FE3Bj
                LDA     #$10
                STA     $4000
                LDA     #1
                STA     $4008
                STY     $E3
                LDA     #$20
                STA     $E4
                LDX     #$5C
                LDY     #$7F
                STX     $4004
                STY     $4005
                LDA     #$F9
                STA     $4007
loc_0_FE66:                         ; FE37j
                LDA     $E4
                LSR     A
                BCC     loc_0_FE6F
                LDA     #$D
                BNE     loc_0_FE71
loc_0_FE6F:                         ; FE69j
                LDA     #$7C
loc_0_FE71:                         ; FE6Dj
                STA     $4006
                JMP     loc_0_FFC6
loc_0_FE77:                         ; FEB2j
                JMP     loc_0_FFCA
loc_0_FE7A:                         ; FE42j
                STY     $E3
                LDX     #$9C
                LDY     #$7F
                STX     $4000
                STX     $4004
                STY     $4001
                STY     $4005
                LDA     #$20
                STA     $4008
                LDA     #1
                STA     $400C
                LDX     #0
                STX     $E9
                STX     $EA
                STX     $EB
                LDA     #1
                STA     $E6
                STA     $E7
                STA     $E8
loc_0_FEA6:                         ; FE3Ej
                DEC     $E6
                BNE     loc_0_FEC1
                LDY     $E9
                INY     
                STY     $E9
                LDA     $FF1F,Y
                BEQ     loc_0_FE77
                JSR     sub_0_FFE9
                STA     $E6
                TXA     
                AND     #$3E
                LDX     #4
                JSR     sub_0_FFD9
loc_0_FEC1:                         ; FEA8j
                DEC     $E7
                BNE     loc_0_FEDA
                LDY     $EA
                INY     
                STY     $EA
                LDA     $FF33,Y
                JSR     sub_0_FFE9
                STA     $E7
                TXA     
                AND     #$3E
                LDX     #0
                JSR     sub_0_FFD9
loc_0_FEDA:                         ; FEC3j
                DEC     $E8
                BNE     loc_0_FEFD
                LDA     #9
                STA     $400E
                LDA     #8
                STA     $400F
                LDY     $EB
                INY     
                STY     $EB
                LDA     $FF46,Y
                JSR     sub_0_FFE9
                STA     $E8
                TXA     
                AND     #$3E
                LDX     #8
                JSR     sub_0_FFD9
loc_0_FEFD:                         ; FEDCj
                JMP     loc_0_FF6A
unk_0_FF00:     .BYTE    3 ;        ; sub_0_FFD9+9r
unk_0_FF01:     .BYTE  $57 ; W      ; sub_0_FFD9+1r
                .BYTE    0 ;  
                .BYTE    0 ;  
                .BYTE    8 ;  
                .BYTE  $D4 ; д
                .BYTE    8 ;  
                .BYTE  $BD ; Н
                .BYTE    8 ;  
                .BYTE  $B2 ; В
                .BYTE    9 ;  
                .BYTE  $AB ; Ћ
                .BYTE    9 ;  
                .BYTE  $7C ; |
                .BYTE    9 ;  
                .BYTE  $3F ; ?
                .BYTE    9 ;  
                .BYTE  $1C ;  
                .BYTE    8 ;  
                .BYTE  $FD ; §
                .BYTE    8 ;  
                .BYTE  $EE ; ю
                .BYTE    9 ;  
                .BYTE  $FC ; ќ
                .BYTE    9 ;  
                .BYTE  $DF ; п
unk_0_FF1A:     .BYTE    6 ;        ; sub_0_FFE9+9r
                .BYTE   $C ;  
                .BYTE  $12 ;  
                .BYTE  $18 ;  
                .BYTE    8 ;  
                .BYTE  $48 ; H
                .BYTE  $CA ; Ъ
                .BYTE  $CE ; Ю
                .BYTE  $D4 ; д
                .BYTE  $13 ;  
                .BYTE  $11 ;  
                .BYTE   $F ;  
                .BYTE  $90 ; 
                .BYTE  $10 ;  
                .BYTE  $C4 ; Ф
                .BYTE  $C8 ; Ш
                .BYTE    7 ;  
                .BYTE    5 ;  
                .BYTE  $15 ;  
                .BYTE  $C4 ; Ф
                .BYTE  $D2 ; в
                .BYTE  $D4 ; д
                .BYTE  $8E ; 
                .BYTE   $C ;  
                .BYTE  $4F ; O
                .BYTE    0 ;  
                .BYTE  $D6 ; ж
                .BYTE  $D6 ; ж
                .BYTE  $CA ; Ъ
                .BYTE   $B ;  
                .BYTE  $19 ;  
                .BYTE  $17 ;  
                .BYTE  $98 ; 
                .BYTE  $18 ;  
                .BYTE  $CE ; Ю
                .BYTE  $D4 ; д
                .BYTE  $15 ;  
                .BYTE  $13 ;  
                .BYTE  $11 ;  
                .BYTE  $D2 ; в
                .BYTE  $CA ; Ъ
                .BYTE  $CC ; Ь
                .BYTE  $96 ; 
                .BYTE  $18 ;  
                .BYTE  $57 ; W
                .BYTE  $CE ; Ю
                .BYTE   $F ;  
                .BYTE   $F ;  
                .BYTE   $F ;  
                .BYTE  $CE ; Ю
                .BYTE  $CE ; Ю
                .BYTE  $CE ; Ю
                .BYTE  $CE ; Ю
                .BYTE  $CE ; Ю
                .BYTE   $F ;  
                .BYTE   $F ;  
                .BYTE   $F ;  
                .BYTE  $CE ; Ю
                .BYTE  $CE ; Ю
                .BYTE  $CE ; Ю
                .BYTE  $CE ; Ю
                .BYTE  $CE ; Ю
                .BYTE   $F ;  
                .BYTE   $F ;  
                .BYTE   $F ;  
                .BYTE  $CE ; Ю
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
sub_0_FF5C:                         ; sub_0_EFE8p
                LDY     $E1
                LDA     $E3
                LSR     $E1
                BCS     loc_0_FF7B
                LSR     A
                BCS     loc_0_FF9A
                JMP     loc_0_FE36
loc_0_FF6A:                         ; FE44j FEFDj sub_0_FF5C+7Aj
                LDA     #0
                STA     $E1
                RTS     
unk_0_FF6F:     .BYTE    6 ;        ; sub_0_FF5C+42r
                .BYTE   $C ;  
                .BYTE  $12 ;  
unk_0_FF72:     .BYTE  $47 ; G      ; sub_0_FF5C+47r
                .BYTE  $5F ; _
                .BYTE  $71 ; q
unk_0_FF75:     .BYTE  $5F ; _      ; sub_0_FF5C+52r
                .BYTE  $71 ; q
                .BYTE  $8E ; 
unk_0_FF78:     .BYTE  $71 ; q      ; sub_0_FF5C+5Br
                .BYTE  $8E ; 
                .BYTE  $BE ; О
loc_0_FF7B:                         ; sub_0_FF5C+6j
                STY     $E3
                LDA     #$12
                STA     $E4
                LDA     #2
                STA     $E5
                LDX     #$9F
                LDY     #$7F
                STX     $4000
                STX     $4004
                STY     $4001
                STY     $4005
                LDA     #$20
                STA     $4008
loc_0_FF9A:                         ; sub_0_FF5C+9j
                LDA     $E4
                LDY     $E5
                CMP     unk_0_FF6F,Y
                BNE     loc_0_FFC6
                LDA     unk_0_FF72,Y
                STA     $4002
                LDX     #$58
                STX     $4003
                LDA     unk_0_FF75,Y
                STA     $4006
                STX     $4007
                LDA     unk_0_FF78,Y
                STA     $400A
                STX     $400B
                LDA     $E5
                BEQ     loc_0_FFC6
                DEC     $E5
loc_0_FFC6:                         ; FE74j sub_0_FF5C+45j sub_0_FF5C+66j
                DEC     $E4
                BNE     loc_0_FFD6
loc_0_FFCA:                         ; FE77j
                LDA     #0
                STA     $E3
                LDA     #$10
                STA     $4000
                STA     $4004
loc_0_FFD6:                         ; sub_0_FF5C+6Cj
                JMP     loc_0_FF6A
; End of function sub_0_FF5C
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
sub_0_FFD9:                         ; FEBEp FED7p FEFAp
                TAY     
                LDA     unk_0_FF01,Y
                BEQ     locret_0_FFE8
                STA     $4002,X
                LDA     unk_0_FF00,Y
                STA     $4003,X
locret_0_FFE8:                      ; sub_0_FFD9+4j
                RTS     
; End of function sub_0_FFD9
; ллллллллллллллл S U B R O U T I N E ллллллллллллллллллллллллллллллллллллллл
sub_0_FFE9:                         ; FEB4p FECDp FEF0p
                TAX     
                ROR     A
                TXA     
                ROL     A
                ROL     A
                ROL     A
                AND     #7
                TAY     
                LDA     unk_0_FF1A,Y
                RTS     
; End of function sub_0_FFE9
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE  $FF ;  
                .BYTE    1 ;  
nmivect:        .WORD nmi
resvect:        .WORD reset
irqvect:        .WORD irq
; end of 'rom'
