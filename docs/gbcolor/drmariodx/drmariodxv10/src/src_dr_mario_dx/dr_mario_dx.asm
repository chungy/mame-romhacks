; Dr. Mario DX
; by Marc Robledo @marc_robledo 2019-2020
; graphics edit by Da_GPer


; CONSTANTS
FREE_RAM								EQU $CE00 ;there seems to be some unused RAM at $ce00, we will use it to store some variables and the new vblank code

TEMP_VAR_COPIED_MAP_ORIGINAL_OFFSET		EQU FREE_RAM+15
TEMP_VAR_COPIED_MAP 					EQU FREE_RAM+16
NEW_VBLANK_CODE		 					EQU TEMP_VAR_COPIED_MAP+20*18+8



; IMPORTS
INCLUDE "src_dr_mario_dx/gbhw.inc" ;https://github.com/gbdev/hardware.inc/blob/master/hardware.inc


; MACROS
SWITCH_BANK: MACRO
	ld	a, \1
	ld	[$2000], a
ENDM


SECTION "Interrupts - VBlank", ROM0[$0040]
SECTION "Interrupts - Timer", ROM0[$0050]


; HEADER
SECTION "Cart name", ROM0[$0134]
DB "DR.MARIO DX",0,0,0,0,$80 ;$80: set CGB mode
SECTION "Cart type", ROM0[$0147]
DB ROM_MBC1 ;$01: 64kb
SECTION "Cart size", ROM0[$0148]
DB ROM_SIZE_64KBYTE ;we need more space to store palettes and additional routines


; SPRITE ATTRIBUTES
; the game has all four bytes for every sprite OAM hardcoded in ROM (it just copies them when needed to OAM)
; so we will edit their attribute to give them a CGB palette!
SECTION "Overlay - Menu 1P VIRUS LEVEL Digit 1", ROM0[$05ea]
DB $02
SECTION "Overlay - Menu 1P VIRUS LEVEL Digit 2", ROM0[$05ee]
DB $02
SECTION "Overlay - Menu 2P VIRUS LEVEL Digit 1", ROM0[$05f2]
DB $02
SECTION "Overlay - Menu 2P VIRUS LEVEL Digit 2", ROM0[$05f6]
DB $02
SECTION "Overlay - Menu 1P VIRUS LEVEL Arrow", ROM0[$05fa]
DB $02
SECTION "Overlay - Menu 2P VIRUS LEVEL Arrow", ROM0[$05fe]
DB $42
SECTION "Overlay - Menu 1P MUSIC 1", ROM0[$060f]
DB $88,$20,$fe,$02
DB $88,$28,$fe,$02
DB $88,$30,$fe,$02
DB $88,$48,$fe,$02
DB $88,$50,$fe,$02
SECTION "Overlay - Menu 1P VIRUS LEVEL Y", ROM0[$0626]
DB $02
SECTION "Overlay - Menu 1P VIRUS LEVEL O", ROM0[$062a]
DB $02
SECTION "Overlay - Menu 1P VIRUS LEVEL U", ROM0[$062e]
DB $02
SECTION "Overlay - Menu 2P VIRUS LEVEL Y", ROM0[$0632]
DB $02
SECTION "Overlay - Menu 2P VIRUS LEVEL O", ROM0[$0636]
DB $02
SECTION "Overlay - Menu 2P VIRUS LEVEL U", ROM0[$063a]
DB $02
SECTION "Overlay - Menu 1P SPEED Y", ROM0[$063e]
DB $02
SECTION "Overlay - Menu 1P SPEED O", ROM0[$0642]
DB $02
SECTION "Overlay - Menu 1P SPEED U", ROM0[$0646]
DB $02
SECTION "Overlay - Menu 2P SPEED Y", ROM0[$064a]
DB $02
SECTION "Overlay - Menu 2P SPEED O", ROM0[$064e]
DB $02
SECTION "Overlay - Menu 2P SPEED U", ROM0[$0652]
DB $02

SECTION "Overlay - Sprite Attributes Multiplayer Digit YOU 1 (top)", ROM0[$0ce5]
DB $02
SECTION "Overlay - Sprite Attributes Multiplayer Digit YOU 1 (bottom)", ROM0[$0ce9]
DB $02
SECTION "Overlay - Sprite Attributes Multiplayer Digit YOU 2 (top)", ROM0[$0ced]
DB $02
SECTION "Overlay - Sprite Attributes Multiplayer Digit YOU 2 (bottom)", ROM0[$0cf1]
DB $02
SECTION "Overlay - Sprite Attributes Multiplayer Digit COM 1 (top)", ROM0[$0cf5]
DB $02
SECTION "Overlay - Sprite Attributes Multiplayer Digit COM 1 (bottom)", ROM0[$0cf9]
DB $02
SECTION "Overlay - Sprite Attributes Multiplayer Digit COM 2 (top)", ROM0[$0cfd]
DB $02
SECTION "Overlay - Sprite Attributes Multiplayer Digit COM 2 (bottom)", ROM0[$0d01]
DB $02
SECTION "Overlay - Sprite Attributes Multiplayer Crown YOU 1 (left)", ROM0[$10d2]
DB $03
SECTION "Overlay - Sprite Attributes Multiplayer Crown YOU 1 (right)", ROM0[$10d6]
DB $23
SECTION "Overlay - Sprite Attributes Multiplayer Crown YOU 2 (left)", ROM0[$10da]
DB $03
SECTION "Overlay - Sprite Attributes Multiplayer Crown YOU 2 (right)", ROM0[$10de]
DB $23
SECTION "Overlay - Sprite Attributes Multiplayer Crown YOU 3 (left)", ROM0[$10e2]
DB $03
SECTION "Overlay - Sprite Attributes Multiplayer Crown YOU 3 (right)", ROM0[$10e6]
DB $23
SECTION "Overlay - Sprite Attributes Multiplayer Crown COM 1 (left)", ROM0[$10ea]
DB $03
SECTION "Overlay - Sprite Attributes Multiplayer Crown COM 1 (right)", ROM0[$10ee]
DB $23
SECTION "Overlay - Sprite Attributes Multiplayer Crown COM 2 (left)", ROM0[$10f2]
DB $03
SECTION "Overlay - Sprite Attributes Multiplayer Crown COM 2 (right)", ROM0[$10f6]
DB $23
SECTION "Overlay - Sprite Attributes Multiplayer Crown COM 3 (left)", ROM0[$10fa]
DB $03
SECTION "Overlay - Sprite Attributes Multiplayer Crown COM 3 (right)", ROM0[$10fe]
DB $23
SECTION "Overlay - Sprite Attributes Dr. Mario Multiplayer Win (0)", ROM0[$1032]
DB $11
SECTION "Overlay - Sprite Attributes Dr. Mario Multiplayer Win (1)", ROM0[$1036]
DB $11
SECTION "Overlay - Sprite Attributes Dr. Mario Multiplayer Win (2)", ROM0[$103a]
DB $11
SECTION "Overlay - Sprite Attributes Dr. Mario Multiplayer Win (3)", ROM0[$103e]
DB $11
SECTION "Overlay - Sprite Attributes Dr. Mario Multiplayer Win (4)", ROM0[$1042]
DB $11
SECTION "Overlay - Sprite Attributes Dr. Mario Multiplayer Win (5)", ROM0[$1046]
DB $11
SECTION "Overlay - Sprite Attributes Dr. Mario Multiplayer Win (6)", ROM0[$104a]
DB $11
SECTION "Overlay - Sprite Attributes Dr. Mario Multiplayer Win (7)", ROM0[$104e]
DB $11
SECTION "Overlay - Sprite Attributes Dr. Mario Multiplayer Win (8)", ROM0[$1052]
DB $11
SECTION "Overlay - Sprite Attributes Dr. Mario Multiplayer Win (9)", ROM0[$1056]
DB $11
SECTION "Overlay - Sprite Attributes Dr. Mario Multiplayer Win (10)", ROM0[$105a]
DB $11

SECTION "Overlay - Sprite Attributes Virus Blue Ending", ROM0[$1948]
DB $04
SECTION "Overlay - Sprite Attributes Virus Red Ending", ROM0[$194c]
DB $05
SECTION "Overlay - Sprite Attributes Virus Yellow Ending", ROM0[$1950]
DB $06
SECTION "Overlay - Sprite Attributes Bubble 1 Ending", ROM0[$1978]
DB $06
SECTION "Overlay - Sprite Attributes Bubble 2 Ending", ROM0[$1997]
DB $06

SECTION "Overlay - Sprite Attributes Ammonite 1 Ending", ROM0[$19e4]
DB $01
SECTION "Overlay - Sprite Attributes Ammonite 2 Ending", ROM0[$19e8]
DB $01
SECTION "Overlay - Sprite Attributes Ammonite 3 Ending", ROM0[$19ec]
DB $01
SECTION "Overlay - Sprite Attributes Ammonite 4 Ending", ROM0[$19f0]
DB $01

SECTION "Overlay - Sprite Attributes Fish 1 Ending", ROM0[$19ff]
DB $02
SECTION "Overlay - Sprite Attributes Fish 2 Ending", ROM0[$1a03]
DB $02
SECTION "Overlay - Sprite Attributes Fish 3 Ending", ROM0[$1a07]
DB $02
SECTION "Overlay - Sprite Attributes Fish 4 Ending", ROM0[$1a0b]
DB $02

SECTION "Overlay - Sprite Attributes Flying Fish 1 Ending", ROM0[$1a35]
DB $03
SECTION "Overlay - Sprite Attributes Flying Fish 2 Ending", ROM0[$1a39]
DB $03
SECTION "Overlay - Sprite Attributes Flying Fish 3 Ending", ROM0[$1a3d]
DB $03
SECTION "Overlay - Sprite Attributes Flying Fish 4 Ending", ROM0[$1a41]
DB $03

SECTION "Overlay - Sprite Attributes Crab 1 Ending", ROM0[$1a1a]
DB $00+$02
SECTION "Overlay - Sprite Attributes Crab 2 Ending", ROM0[$1a1e]
DB $20+$02
SECTION "Overlay - Sprite Attributes Crab 3 Ending", ROM0[$1a22]
DB $00+$02
SECTION "Overlay - Sprite Attributes Crab 4 Ending", ROM0[$1a26]
DB $20+$02

SECTION "Overlay - Sprite Attributes UFO Ending (1)", ROM0[$1a50]
DB $00+$02
SECTION "Overlay - Sprite Attributes UFO Ending (2)", ROM0[$1a54]
DB $20+$02
SECTION "Overlay - Sprite Attributes UFO Ending (3)", ROM0[$1a58]
DB $00+$02
SECTION "Overlay - Sprite Attributes UFO Ending (4)", ROM0[$1a5c]
DB $20+$02

SECTION "Overlay - Sprite Attributes Coelacanth Ending (1)", ROM0[$1a6b]
DB $03
SECTION "Overlay - Sprite Attributes Coelacanth Ending (2)", ROM0[$1A6F]
DB $03
SECTION "Overlay - Sprite Attributes Coelacanth Ending (3)", ROM0[$1A73]
DB $03
SECTION "Overlay - Sprite Attributes Coelacanth Ending (4)", ROM0[$1A77]
DB $03
SECTION "Overlay - Sprite Attributes Coelacanth Ending (5)", ROM0[$1A7B]
DB $03
SECTION "Overlay - Sprite Attributes Coelacanth Ending (6)", ROM0[$1A7F]
DB $03
SECTION "Overlay - Sprite Attributes Coelacanth Ending (7)", ROM0[$1A83]
DB $03
SECTION "Overlay - Sprite Attributes Coelacanth Ending (8)", ROM0[$1A87]
DB $03
SECTION "Overlay - Sprite Attributes Coelacanth Ending (9)", ROM0[$1A8B]
DB $03
SECTION "Overlay - Sprite Attributes Coelacanth Ending (10)", ROM0[$1A8F]
DB $03
SECTION "Overlay - Sprite Attributes Coelacanth Ending (11)", ROM0[$1A93]
DB $03
SECTION "Overlay - Sprite Attributes Coelacanth Ending (12)", ROM0[$1A97]
DB $03
SECTION "Overlay - Sprite Attributes Coelacanth Ending (13)", ROM0[$1A9B]
DB $03
SECTION "Overlay - Sprite Attributes Coelacanth Ending (14)", ROM0[$1A9F]
DB $03
SECTION "Overlay - Sprite Attributes Coelacanth Ending (15)", ROM0[$1AA3]
DB $03
SECTION "Overlay - Sprite Attributes Coelacanth Ending (16)", ROM0[$1AA7]
DB $03
SECTION "Overlay - Sprite Attributes Coelacanth Ending (17)", ROM0[$1AAB]
DB $03
SECTION "Overlay - Sprite Attributes Coelacanth Ending (18)", ROM0[$1AAF]
DB $03
SECTION "Overlay - Sprite Attributes Coelacanth Ending (19)", ROM0[$1AB3]
DB $03
SECTION "Overlay - Sprite Attributes Coelacanth Ending (20)", ROM0[$1AB7]
DB $03
SECTION "Overlay - Sprite Attributes Coelacanth Ending (21)", ROM0[$1ABB]
DB $03

SECTION "Overlay - Sprite Attributes Playable vitamin", ROM0[$2087]
DB $07
SECTION "Overlay - Sprite Attributes Next vitamin", ROM0[$208f]
DB $07
SECTION "Overlay - Sprite Attributes Demo vitamin", ROM0[$209f]
DB $07

SECTION "Overlay - Sprite Attributes Dr. Mario (0)", ROM0[$26a3]
DB $11
SECTION "Overlay - Sprite Attributes Dr. Mario (1)", ROM0[$26a7]
DB $11
SECTION "Overlay - Sprite Attributes Dr. Mario (2)", ROM0[$26ab]
DB $11
SECTION "Overlay - Sprite Attributes Dr. Mario (3)", ROM0[$26af]
DB $11
SECTION "Overlay - Sprite Attributes Dr. Mario (4)", ROM0[$26b3]
DB $11
SECTION "Overlay - Sprite Attributes Dr. Mario (5)", ROM0[$26b7]
DB $11
SECTION "Overlay - Sprite Attributes Dr. Mario (6)", ROM0[$26bb]
DB $11
SECTION "Overlay - Sprite Attributes Dr. Mario (7)", ROM0[$26bf]
DB $11
SECTION "Overlay - Sprite Attributes Dr. Mario (8)", ROM0[$26c3]
DB $11
SECTION "Overlay - Sprite Attributes Dr. Mario (9)", ROM0[$26c7]
DB $11

; since our new sprite viruses a little bigger now, we also move them so they fit better in the HUD
SECTION "Overlay - Sprite Attributes Virus Blue", ROM0[$26c9]
DB $8d-1, $6b, $20, $14
DB $8d-1, $73, $21, $14
DB $95-1, $6b, $30, $14
DB $95-1, $73, $31, $14
SECTION "Overlay - Sprite Attributes Virus Red", ROM0[$26ec]
DB $8d-1, $7b+1, $40, $15
DB $8d-1, $83+1, $41, $15
DB $95-1, $7b+1, $50, $15
DB $95-1, $83+1, $51, $15
SECTION "Overlay - Sprite Attributes Virus Yellow", ROM0[$2718]
DB $8d-1, $8b+2, $60, $16
DB $8d-1, $93+2, $61, $16
DB $95-1, $8b+2, $70, $16
DB $95-1, $93+2, $71, $16
SECTION "Overlay - Sprite Attributes Virus Multiplayer Lose", ROM0[$26fd]
DB $75,$38,$40,$15
DB $75,$40,$41,$15
DB $7d,$38,$50,$15
DB $7d,$40,$51,$15


; overwrite old tileset with newer one
SECTION "Overlay - Tiles Dr. Mario", ROM0[$3daa]
DB $00,$00,$00,$00,$00,$00,$00,$00,$30,$30,$30,$00,$58,$20,$33,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$F0,$00
DB $00,$00,$36,$08,$23,$08,$23,$08,$00,$3F,$00,$7C,$00,$78,$00,$00
DB $00,$00,$00,$C0,$00,$CC,$00,$94,$00,$F4,$00,$EC,$00,$30,$00,$70
DB $00,$00,$00,$00,$00,$00,$01,$04,$01,$1C,$01,$00,$00,$00,$00,$00
DB $00,$13,$20,$0F,$70,$00,$D5,$00,$B8,$00,$BB,$00,$0B,$00,$3B,$00
DB $00,$E0,$18,$80,$7C,$00,$7C,$00,$EE,$00,$EE,$00,$0E,$00,$C0,$00
DB $1B,$00,$1D,$00,$00,$00,$06,$00,$02,$00,$1C,$1C,$3E,$3E,$00,$00
DB $C0,$1E,$E0,$0E,$00,$00,$F0,$00,$C0,$00,$38,$38,$FC,$FC,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$1A,$00,$1E,$00,$1C,$03,$08,$07,$00
DB $00,$00,$36,$08,$23,$08,$23,$08,$00,$3F,$00,$7C,$00,$78,$80,$00
DB $03,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $C0,$13,$E0,$0F,$70,$00,$15,$00,$38,$00,$3B,$00,$0B,$00,$3B,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$36,$88,$23,$88,$23,$08,$80,$3F,$00,$7C,$00,$78,$80,$00
DB $40,$13,$60,$0F,$30,$00,$15,$00,$38,$00,$3B,$00,$0B,$00,$3B,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$03,$03,$00,$00,$01,$00,$1C,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$C0,$C0,$C0,$00,$E0,$40,$C8,$00
DB $00,$00,$06,$11,$0C,$51,$0C,$41,$00,$7F,$00,$57,$00,$23,$00,$30
DB $00,$00,$C0,$10,$60,$16,$60,$06,$00,$FE,$00,$DA,$00,$8C,$00,$1C
DB $00,$00,$00,$02,$00,$0E,$01,$00,$03,$00,$01,$00,$00,$00,$00,$00
DB $00,$1F,$20,$07,$50,$00,$D4,$00,$BA,$00,$BC,$00,$22,$00,$3E,$00
DB $00,$F8,$04,$C0,$1E,$00,$5D,$00,$BE,$00,$7E,$00,$86,$00,$FC,$00
DB $00,$00,$08,$48,$04,$7C,$88,$08,$C0,$00,$00,$00,$00,$00,$00,$00
DB $3E,$00,$1E,$00,$00,$00,$07,$00,$03,$00,$1C,$1C,$3F,$3F,$00,$00
DB $FC,$00,$F8,$00,$00,$00,$70,$00,$40,$00,$38,$38,$7C,$7C,$00,$00
DB $00,$00,$06,$11,$0C,$51,$0C,$41,$00,$7F,$00,$57,$00,$23,$10,$30
DB $00,$00,$C0,$10,$60,$16,$60,$06,$00,$FE,$00,$DA,$00,$8C,$18,$1C
DB $00,$00,$00,$03,$00,$03,$00,$03,$00,$00,$00,$00,$00,$00,$00,$00
DB $1F,$3F,$0F,$9E,$23,$8F,$70,$03,$D8,$00,$BA,$00,$3D,$00,$22,$00
DB $F8,$FC,$F0,$79,$C4,$F1,$0E,$C0,$3B,$00,$BD,$00,$7C,$00,$C4,$00
DB $00,$00,$00,$C0,$00,$C0,$00,$80,$40,$00,$80,$00,$00,$00,$00,$00
SECTION "Overlay - Tiles Dr. Mario Multiplayer Win", ROMX[$408a],BANK[1]
DB $01,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $DF,$1F,$CF,$1E,$E3,$0F,$30,$03,$18,$00,$3A,$00,$3D,$00,$22,$00
SECTION "Overlay - Tiles Dr. Mario Multiplayer Win 2 and unused?", ROMX[$416a],BANK[1]
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$07,$00,$07,$00,$02,$00,$00
DB $0C,$E0,$1F,$80,$77,$00,$7B,$00,$FC,$00,$FC,$00,$1C,$00,$FC,$00
DB $00,$00,$80,$00,$E0,$00,$C0,$00,$80,$30,$00,$70,$00,$60,$00,$00
DB $F8,$00,$F8,$00,$00,$00,$F0,$00,$C0,$00,$38,$38,$FC,$FC,$00,$00


SECTION "Overlay - Sprite Virus Blue Top (Bank 0)", ROM0[$3faa]
DB $00,$00,$00,$00,$3E,$3E,$41,$7F,$BC,$FF,$5E,$5F,$3E,$3F,$5F,$7D
DB $00,$00,$00,$00,$7C,$7C,$82,$FE,$3D,$FF,$7A,$FA,$7C,$FC,$FA,$BE
DB $3E,$3E,$41,$7F,$7C,$7F,$0E,$0F,$06,$07,$1F,$1D,$2F,$3D,$26,$3F
DB $1A,$1A,$7F,$75,$9F,$F1,$7E,$FA,$E7,$FD,$F3,$7F,$F2,$7E,$E1,$FF
DB $58,$58,$FE,$AE,$F9,$8F,$7E,$5F,$E7,$BF,$CF,$FE,$4F,$7E,$87,$FF
DB $7C,$7C,$82,$FE,$3E,$FE
SECTION "Overlay - Sprite Virus Blue Top (Bank 1)", ROMX[$4000],BANK[1]
DB                         $70,$F0,$60,$E0,$F8,$B8,$F4,$BC,$64,$FC
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$55,$55,$FA,$AF,$FD,$9F
DB $00,$00,$00,$00,$18,$18,$78,$68,$7C,$44,$BC,$B4,$48,$F8,$B4,$FC
DB $00,$00,$00,$00,$18,$18,$1E,$16,$3E,$22,$3D,$2D,$12,$1F,$2D,$3F
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$AA,$AA,$5F,$F5,$BF,$F9
DB $00,$00,$00,$00,$1D,$1D,$62,$7F,$8E,$FF,$7E,$7F,$5F,$7D,$4E,$7D
DB $00,$00,$00,$00,$B8,$B8,$46,$FE,$71,$FF,$7E,$FE,$FA,$BE,$72,$BE
SECTION "Overlay - Sprite Virus Blue Bottom", ROMX[$40aa],BANK[1]
DB $4F,$7D,$A0,$FF,$FF,$FE,$F3,$9F,$E8,$AF,$57,$5F,$3E,$22,$3E,$3E
DB $F2,$BE,$05,$FF,$FF,$7F,$CF,$F9,$17,$F5,$EA,$FA,$7C,$44,$7C,$7C
DB $28,$3F,$6F,$7C,$77,$5F,$77,$5F,$39,$3F,$7E,$47,$7D,$7D,$00,$00
DB $19,$FF,$F9,$FF,$FA,$FE,$F4,$FC,$C8,$F8,$38,$F8,$FC,$C4,$7C,$7C
DB $98,$FF,$9F,$FF,$5F,$7F,$2F,$3F,$13,$1F,$1C,$1F,$3F,$23,$3E,$3E
DB $14,$FC,$F6,$3E,$EE,$FA,$EE,$FA,$9C,$FC,$7E,$E2,$BE,$BE,$00,$00
DB $63,$7F,$FF,$9E,$F3,$9F,$F8,$8F,$70,$7F,$10,$1F,$0C,$0F,$03,$03
DB $CA,$FE,$FA,$7E,$CA,$FE,$04,$FC,$0E,$FA,$1E,$F2,$3C,$E4,$D8,$D8
DB $53,$7F,$5F,$7E,$53,$7F,$20,$3F,$70,$5F,$78,$4F,$3C,$27,$1B,$1B
DB $C6,$FE,$FF,$79,$CF,$F9,$1F,$F1,$0E,$FE,$08,$F8,$30,$F0,$C0,$C0
DB $40,$7F,$A7,$FE,$FF,$FF,$FF,$9F,$F3,$BF,$5C,$5F,$3F,$23,$3E,$3E
DB $02,$FE,$E5,$7F,$FF,$FF,$FF,$F9,$CF,$FD,$3A,$FA,$FC,$C4,$7C,$7C
SECTION "Overlay - Sprite Virus Red Top", ROMX[$41aa],BANK[1]
DB $00,$00,$24,$24,$5F,$7B,$68,$5F,$77,$5D,$2F,$3F,$2E,$3F,$41,$7F
DB $00,$00,$24,$24,$FA,$DE,$16,$FA,$EE,$BA,$F4,$FC,$74,$FC,$82,$FE
DB $02,$02,$07,$05,$1C,$1F,$73,$6F,$8F,$FD,$7C,$57,$7B,$7F,$5B,$7F
DB $50,$70,$F0,$D0,$30,$F0,$C8,$F8,$F4,$FC,$74,$FC,$82,$FE,$3A,$FE
DB $0A,$0E,$0F,$0B,$0C,$0F,$13,$1F,$2F,$3F,$2E,$3F,$41,$7F,$5C,$7F
DB $40,$40,$E0,$A0,$38,$F8,$CE,$F6,$F1,$BF,$3E,$EA,$DE,$FE,$DA,$FE
DB $00,$00,$00,$00,$20,$20,$F0,$D0,$F7,$97,$F9,$BF,$77,$7F,$28,$3F
DB $00,$00,$00,$00,$00,$00,$00,$00,$E0,$E0,$96,$F6,$EF,$F9,$17,$FD
SECTION "Overlay - Sprite Virus All Die Top", ROMX[$422a],BANK[1]
DB $00,$01,$00,$01,$00,$21,$00,$10,$00,$08,$00,$00,$00,$00,$00,$E0
DB $00,$00,$00,$00,$00,$08,$00,$10,$00,$20,$00,$00,$00,$00,$00,$0E
SECTION "Overlay - Sprite Virus Red Top (2)", ROMX[$424a],BANK[1]
DB $00,$00,$24,$24,$5F,$7B,$68,$5F,$77,$5D,$2F,$3F,$26,$3F,$49,$7F
DB $00,$00,$24,$24,$FA,$DE,$16,$FA,$EE,$BA,$F4,$FC,$64,$FC,$92,$FE
SECTION "Overlay - Sprite Virus Red Bottom", ROMX[$42aa],BANK[1]
DB $4C,$7F,$DF,$BB,$DF,$FE,$EF,$BF,$F0,$9F,$FB,$FF,$3F,$23,$3F,$3F
DB $32,$FE,$FB,$DD,$FB,$7F,$F7,$FD,$0F,$F9,$DF,$FF,$7C,$C4,$FC,$FC
DB $58,$7F,$E7,$BD,$FF,$9F,$7F,$5D,$27,$3C,$7F,$46,$7D,$7D,$00,$00
DB $FA,$DE,$FB,$FF,$F7,$7D,$EF,$3D,$F3,$33,$D8,$78,$BC,$C4,$7C,$7C
DB $5F,$7B,$DF,$FF,$EF,$BE,$F7,$BC,$CF,$CC,$1B,$1E,$3D,$23,$3E,$3E
DB $1A,$FE,$E7,$BD,$FF,$F9,$FE,$BA,$E4,$3C,$FE,$62,$BE,$BE,$00,$00
DB $27,$3F,$4F,$7B,$4F,$7F,$6C,$7F,$70,$5F,$78,$4F,$3C,$27,$1B,$1B
DB $E6,$FE,$FF,$DD,$FF,$F9,$1F,$F9,$0E,$FE,$08,$F8,$30,$F0,$C0,$C0
SECTION "Overlay - Sprite Virus All Die Bottom", ROMX[$432a],BANK[1]
DB $00,$00,$00,$00,$00,$08,$00,$11,$00,$21,$00,$01,$00,$01,$00,$00
DB $00,$00,$00,$00,$00,$20,$00,$10,$00,$08,$00,$00,$00,$00,$00,$00
SECTION "Overlay - Sprite Virus Red Bottom (2)", ROMX[$434a],BANK[1]
DB $5C,$7F,$DF,$BB,$DF,$FF,$CF,$BE,$F0,$BF,$FF,$FF,$3F,$23,$3F,$3F
DB $3A,$FE,$FB,$DD,$FB,$FF,$F3,$7D,$0F,$FD,$FF,$FF,$7C,$C4,$FC,$FC
SECTION "Overlay - Sprite Virus Yellow Top", ROMX[$43aa],BANK[1]
DB $00,$00,$32,$32,$2F,$3D,$10,$1F,$0B,$0F,$57,$5D,$AF,$ED,$58,$7F
DB $00,$00,$4C,$4C,$F4,$BC,$08,$F8,$D0,$F0,$EA,$BA,$F5,$B7,$1A,$FE
DB $00,$00,$19,$19,$17,$1E,$08,$0F,$05,$07,$2B,$2E,$57,$76,$2C,$3F
DB $00,$00,$26,$26,$FA,$DE,$04,$FC,$E8,$F8,$F6,$DE,$FF,$D9,$0F,$F9
DB $00,$00,$64,$64,$5F,$7B,$20,$3F,$17,$1F,$6F,$7B,$FF,$9B,$F0,$9F
DB $00,$00,$98,$98,$E8,$78,$10,$F0,$A0,$E0,$D4,$74,$EA,$6E,$34,$FC
DB $00,$00,$00,$00,$08,$08,$1E,$16,$3E,$22,$3F,$37,$09,$0F,$17,$1F
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$E6,$E6,$9F,$F9,$EF,$F9
SECTION "Overlay - Sprite Virus Yellow Top (2)", ROMX[$444a],BANK[1]
DB $00,$00,$12,$12,$2F,$3D,$18,$1F,$13,$1F,$17,$1D,$28,$2F,$54,$7F
DB $00,$00,$48,$48,$F4,$BC,$18,$F8,$C8,$F8,$E8,$B8,$14,$F4,$2A,$FE
SECTION "Overlay - Sprite Virus Yellow Bottom", ROMX[$44aa],BANK[1]
DB $20,$3F,$23,$3F,$64,$7F,$F8,$9F,$FF,$9F,$7A,$7E,$3E,$22,$3E,$3E
DB $04,$FC,$C4,$FC,$26,$FE,$1F,$F9,$FF,$F9,$5E,$7E,$7C,$44,$7C,$7C
DB $10,$1F,$27,$3F,$E8,$FF,$F0,$BF,$EF,$BF,$FF,$99,$66,$66,$00,$00
DB $06,$FE,$F2,$FE,$0A,$FE,$04,$FC,$F8,$F8,$58,$78,$7C,$44,$7C,$7C
DB $60,$7F,$4F,$7F,$50,$7F,$20,$3F,$1F,$1F,$1A,$1E,$3E,$22,$3E,$3E
DB $08,$F8,$E4,$FC,$17,$FF,$0F,$FD,$F7,$FD,$FF,$99,$66,$66,$00,$00
DB $18,$1F,$23,$3F,$27,$3F,$30,$3F,$48,$7F,$44,$7F,$24,$3F,$1B,$1B
DB $1E,$FE,$D1,$FF,$F1,$FF,$11,$FF,$0E,$FE,$08,$F8,$30,$F0,$C0,$C0
SECTION "Overlay - Sprite Virus Yellow Bottom (2)", ROMX[$454a],BANK[1]
DB $2F,$3F,$6F,$75,$EF,$BD,$F3,$9F,$6C,$6F,$1B,$1F,$3E,$22,$3E,$3E
DB $F4,$FC,$F6,$AE,$F7,$BD,$CF,$F9,$36,$F6,$D8,$F8,$7C,$44,$7C,$7C




SECTION "Overlay - Tiles Level Border 1", ROMX[$50aa],BANK[1]
DB $00,$00,$00,$07,$07,$1F,$1D,$38,$38,$60,$30,$60,$43,$C3,$66,$C7
DB $00,$00,$00,$FF,$FF,$FF,$FF,$00,$00,$00,$00,$00,$FF,$FF,$00,$FF
DB $00,$00,$00,$E0,$E0,$F8,$B8,$1C,$1C,$06,$0C,$06,$C2,$C3,$66,$E3
DB $65,$C7,$65,$C7,$65,$C7,$65,$C7,$65,$C7,$65,$C7,$65,$C7,$65,$C7
DB $A6,$E3,$A6,$E3,$A6,$E3,$A6,$E3,$A6,$E3,$A6,$E3,$A6,$E3,$A6,$E3
DB $46,$C7,$63,$C3,$20,$60,$38,$60,$1D,$38,$07,$1F,$00,$07,$00,$00
DB $00,$FF,$FF,$FF,$00,$00,$00,$00,$FF,$00,$FF,$FF,$00,$FF,$00,$00
DB $62,$E3,$C6,$C3,$04,$06,$1C,$06,$B8,$1C,$E0,$F8,$00,$E0,$00,$00
DB $00,$0F,$00,$0F,$00,$0F,$00,$0F,$00,$F0,$00,$F0,$00,$F0,$00,$F0
DB $00,$00,$07,$3F,$39,$7F,$7C,$E6,$62,$C3,$62,$C3,$32,$63,$32,$63
DB $22,$E3,$62,$C3,$C5,$87,$05,$07,$09,$0F,$33,$3F,$C7,$FF,$1F,$FF
DB $44,$C7,$46,$C3,$23,$E1,$A0,$E0,$90,$F0,$CC,$FC,$E3,$FF,$F8,$FF
DB $00,$00,$E0,$FC,$1C,$FE,$BE,$E7,$46,$C3,$46,$C3,$4C,$C6,$4C,$C6
DB $00,$0F,$00,$0F,$00,$0F,$00,$0F,$00,$F0,$00,$F0,$00,$F0,$00,$F0
SECTION "Overlay - Tiles Level Border 2", ROMX[$528a],BANK[1]
DB $FF,$FF,$AA,$FF,$55,$55,$AA,$AA,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
DB $00,$00,$FF,$FF,$55,$FF,$AA,$AA,$55,$55,$FF,$FF,$FF,$FF,$FF,$FF




SECTION "Overlay - Tiles Clipboard 1", ROMX[$51aa],BANK[1]
DB $00,$FF,$1F,$FF,$20,$E0,$40,$C0,$43,$C3,$43,$C2,$43,$C2,$43,$C2
DB $00,$FF,$FF,$FF,$00,$00,$00,$00,$FF,$FF,$FF,$00,$FF,$00,$FF,$00
DB $00,$FF,$F8,$FF,$04,$07,$02,$03,$C2,$C3,$C2,$43,$C2,$43,$C2,$43
DB $43,$C2,$43,$C2,$43,$C2,$43,$C2,$43,$C2,$43,$C2,$43,$C2,$43,$C2
DB $C2,$43,$C2,$43,$C2,$43,$C2,$43,$C2,$43,$C2,$43,$C2,$43,$C2,$43
DB $7F,$43,$7F,$43,$7F,$60,$7F,$5F,$3F,$E0,$1F,$FF,$00,$F0,$00,$F0
DB $FF,$FF,$FF,$FF,$FF,$00,$FF,$FF,$FF,$00,$FF,$FF,$00,$F0,$00,$F0
DB $FE,$C3,$FE,$C3,$FE,$07,$FE,$FB,$FC,$04,$F8,$F8,$00,$F0,$00,$F0
SECTION "Overlay - Tiles Clipboard 2", ROMX[$52aa],BANK[1]
DB $00,$0F,$00,$0F,$00,$0F,$00,$0F,$00,$F0,$03,$F3,$0F,$FC,$1F,$F5
DB $00,$0F,$00,$0F,$00,$0F,$00,$0F,$00,$F0,$FF,$FF,$FF,$00,$FF,$00
DB $00,$0F,$00,$0F,$00,$0F,$00,$0F,$00,$F0,$E0,$F0,$F0,$30,$F8,$A8
DB $14,$F4,$F7,$F7,$14,$14,$17,$17,$F6,$F6,$F3,$12,$FE,$0E,$FF,$07
DB $00,$00,$FF,$FF,$00,$00,$FF,$FF,$00,$00,$FF,$00,$00,$00,$FF,$FF
DB $28,$2F,$EF,$EF,$28,$28,$E8,$E8,$6F,$6F,$CF,$48,$7F,$70,$FF,$E0


SECTION "Overlay - Tiles Borders", ROMX[$530a],BANK[1]
DB $00,$00,$00,$00,$07,$07,$08,$0F,$13,$1C,$24,$3B,$28,$37,$28,$37
DB $00,$00,$00,$00,$FF,$FF,$00,$FF,$FF,$00,$00,$FF,$00,$FF,$FF,$FF
DB $00,$00,$00,$00,$E0,$E0,$10,$F0,$C8,$38,$24,$DC,$14,$EC,$14,$EC
DB $29,$37,$29,$37,$29,$37,$29,$37,$29,$37,$29,$37,$29,$37,$29,$37
DB $94,$EC,$94,$EC,$94,$EC,$94,$EC,$94,$EC,$94,$EC,$94,$EC,$94,$EC
DB $28,$37,$28,$37,$24,$3B,$13,$1C,$08,$0F,$07,$07,$00,$00,$00,$00
DB $FF,$FF,$00,$FF,$00,$FF,$FF,$00,$00,$FF,$FF,$FF,$00,$00,$00,$00
DB $14,$EC,$14,$EC,$24,$DC,$C8,$38,$10,$F0,$E0,$E0,$00,$00,$00,$00


SECTION "Overlay - Tiles Borders Multiplayer", ROMX[$542a],BANK[1]
DB $00,$00,$00,$00,$FF,$FF,$00,$FF,$FF,$00,$18,$E7,$18,$E7,$DB,$E7
DB $DB,$E7,$18,$E7,$18,$E7,$FF,$00,$00,$FF,$FF,$FF,$00,$00,$00,$00
DB $DB,$E7,$DB,$E7,$DB,$E7,$DB,$E7,$DB,$E7,$DB,$E7,$DB,$E7,$DB,$E7
DB $FF,$FF,$FF,$FF,$00,$FF,$FF,$00,$00,$FF,$FF,$FF,$FF,$FF,$FF,$FF
DB $DB,$E7,$DB,$E7,$18,$E7,$FF,$00,$00,$FF,$FF,$FF,$FF,$FF,$FF,$FF
DB $29,$37,$29,$37,$28,$37,$2F,$30,$28,$37,$28,$37,$29,$37,$29,$37
DB $94,$EC,$94,$EC,$14,$EC,$F4,$0C,$14,$EC,$14,$EC,$94,$EC,$94,$EC


SECTION "Overlay - Tiles Menu Selector", ROMX[$46da],BANK[1]

SECTION "Overlay - Tiles Megavitamins 1", ROMX[$45aa],BANK[1]
DB $7E,$00,$FE,$3C,$FE,$40,$FE,$00,$FE,$00,$FE,$00,$7E,$00,$00,$00
DB $00,$7E,$3C,$FE,$40,$FE,$00,$FE,$00,$FE,$00,$FE,$00,$7E,$00,$00
DB $7E,$7E,$FE,$C2,$FE,$BE,$FE,$FE,$FE,$FE,$FE,$FE,$7E,$7E,$00,$00
SECTION "Overlay - Tiles Megavitamins 2", ROMX[$46aa],BANK[1]
DB $FC,$00,$FE,$F8,$FE,$00,$FE,$00,$FE,$00,$FE,$00,$FC,$00,$00,$00
DB $00,$FC,$F8,$FE,$00,$FE,$00,$FE,$00,$FE,$00,$FE,$00,$FC,$00,$00
DB $FC,$FC,$FE,$06,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FE,$FC,$FC,$00,$00
SECTION "Overlay - Tiles Megavitamins 3", ROMX[$47aa],BANK[1]
DB $7C,$00,$FE,$20,$FE,$40,$FE,$40,$FE,$40,$FE,$40,$FE,$00,$00,$00
DB $00,$7C,$20,$FE,$40,$FE,$40,$FE,$40,$FE,$40,$FE,$00,$FE,$00,$00
DB $7C,$7C,$FE,$DE,$FE,$BE,$FE,$BE,$FE,$BE,$FE,$BE,$FE,$FE,$00,$00
SECTION "Overlay - Tiles Megavitamins 4", ROMX[$48aa],BANK[1]
DB $FE,$40,$FE,$40,$FE,$40,$FE,$40,$FE,$40,$FE,$00,$7C,$00,$00,$00
DB $40,$FE,$40,$FE,$40,$FE,$40,$FE,$40,$FE,$00,$FE,$00,$7C,$00,$00
DB $FE,$BE,$FE,$BE,$FE,$BE,$FE,$BE,$FE,$BE,$FE,$FE,$7C,$7C,$00,$00
SECTION "Overlay - Tiles Megavitamins 5", ROMX[$49aa],BANK[1]
DB $7C,$00,$FE,$20,$FE,$40,$FE,$40,$FE,$40,$FE,$00,$7C,$00,$00,$00
DB $00,$7C,$20,$FE,$40,$FE,$40,$FE,$40,$FE,$00,$FE,$00,$7C,$00,$00
DB $7C,$7C,$FE,$DE,$FE,$BE,$FE,$BE,$FE,$BE,$FE,$FE,$7C,$7C,$00,$00
SECTION "Overlay - Tiles Megavitamins disappearing", ROMX[$4aaa],BANK[1]
DB $7C,$00,$82,$00,$82,$00,$82,$00,$82,$00,$82,$00,$7C,$00,$00,$00
DB $00,$7C,$00,$82,$00,$82,$00,$82,$00,$82,$00,$82,$00,$7C,$00,$00
DB $7C,$7C,$82,$82,$82,$82,$82,$82,$82,$82,$82,$82,$7C,$7C,$00,$00
SECTION "Overlay - Tiles Virus", ROMX[$4baa],BANK[1]
DB $C6,$00,$7C,$00,$10,$00,$AA,$28,$FE,$00,$D6,$10,$7C,$00,$00,$00
DB $02,$3A,$80,$EC,$28,$82,$00,$FE,$28,$AA,$80,$46,$00,$7C,$02,$00
DB $28,$00,$BA,$BA,$44,$44,$EE,$C6,$FE,$FE,$82,$82,$7C,$7C,$00,$00
DB $00,$00,$7C,$00,$D6,$00,$AA,$28,$FE,$00,$D6,$10,$44,$00,$00,$00
DB $80,$B8,$02,$6E,$28,$82,$00,$FE,$28,$AA,$02,$C4,$00,$7C,$80,$00
DB $28,$00,$BA,$BA,$6C,$6C,$28,$00,$7C,$7C,$44,$44,$38,$38,$00,$00
SECTION "Overlay - Tiles Virus disappearing", ROMX[$4caa],BANK[1]
DB $82,$00,$54,$00,$38,$00,$7C,$00,$38,$00,$54,$00,$82,$00,$00,$00
DB $00,$82,$00,$54,$00,$38,$00,$7C,$00,$38,$00,$54,$00,$82,$00,$00
DB $82,$82,$54,$54,$38,$38,$7C,$7C,$38,$38,$54,$54,$82,$82,$00,$00


SECTION "Overlay - Tiles Virus (Ending)", ROMX[$59aa],BANK[1]
DB $38,$FE,$82,$FE,$EE,$FE,$7C,$D6,$00,$FE,$38,$EE,$82,$FE,$7C,$7C
DB $C6,$FC,$92,$7E,$7C,$D6,$00,$FE,$7C,$D6,$B8,$7E,$82,$FE,$7E,$7C
DB $BA,$92,$44,$FE,$BA,$FE,$38,$D6,$00,$FE,$7C,$FE,$82,$FE,$7C,$7C
DB $7C,$7C,$82,$FE,$28,$FE,$7C,$D6,$00,$FE,$38,$EE,$BA,$FE,$44,$44
DB $C6,$7E,$92,$FC,$7C,$D6,$00,$FE,$7C,$D6,$3A,$FC,$82,$FE,$FC,$7C
DB $BA,$92,$44,$FE,$92,$FE,$7C,$54,$00,$7C,$38,$7C,$44,$7C,$38,$38





;startup_original: called during boot, we replace it with a new one in bank 3, that will copy the vblank subroutine to RAM and set the default CGB palettes to VRAM
SECTION "startup_original", ROM0[$20a3]
startup_original:
	SWITCH_BANK 3
	call	startup_dx
	SWITCH_BANK 1
	ret
	nop


;copy_static_screen_original: originally copied 20x18 tiles from [de] to $9800
;(alternatively, it can be called from $20cc and skip the first operation, thus allowing to copy anywhere else)
;we will replace it with a new subroutine at bank 3 that will do the same plus setting the correct color attributes to CGB VRAM bank 1
;but first we need to copy the static screen to RAM, as source offsets are on bank 1 (which would be unaccessible in bank 3)
SECTION "copy_static_screen_to_9800_original", ROM0[$20c9]
copy_static_screen_to_9800_original:
	ld		hl, $9800
SECTION "copy_static_screen_to_hl_original", ROM0[$20cc]
copy_static_screen_to_hl_original:
	push	hl
	ld		hl, TEMP_VAR_COPIED_MAP
	ld		bc, 18*20

mem_copy_static_screen:
	ld		a, [de]
	ld		[hli], a	
	dec		bc

	inc		de
	;check if bc==0
	ld		a, c 
	or		b
	jr		nz, mem_copy_static_screen

	pop		hl
	SWITCH_BANK 3
	di
	call copy_static_screen_to_hl_dx
	SWITCH_BANK 1
	reti

;originally, after subroutine $20c9's ret, there was another subroutine (at $20e2) that copied the win/lose results window for multiplayer that appears when match is over
;but now it's partially overlapped by the new $20c9 subroutine above
;there was only a call to this one (at $0bdd), and already set hl=$c900 and de=$3d08
;it was almost the same as the original $20c9 (but focused on a smaller part of the window BG map)
;in order to ensure this subroutine doesn't get too big (and thus, won't overlap the next one), what we will do here is to reuse code from $20c9
copy_map_multiplayer_results_dx:
	push	hl
	ld		hl, TEMP_VAR_COPIED_MAP
	ld		bc, 18*9
	jr		mem_copy_static_screen
	nop ;$20f4 --> fill with nops the old code, for beauty purposes :-)
	nop
	nop
	nop
	nop
	nop



;only call to (original) copy_map_multiplayer_results, but since it's partially overlapped now with the new copy_static_screen_to_9800 it's unusable now
;we will replace this call to the new one, which is shifted a little bit
SECTION "Overlay $0bdd", ROM0[$0bdd]
	call	copy_map_multiplayer_results_dx




;this is run during vblank, refreshes game board tiles in a row (by copying game board data stored at $c800 to VRAM)
;run from bottom to top only during vblank when viruses are eliminated or when win/lose messages appear, both in 1P and 2P modes
;we need to modify it so it also changes palettes (for win/lose messages, which don't look good with main game palette BG7)
;this needs to be as fast as possible as it's ran during vblank, so we will avoid switching bank, our new code will be stored in RAM
SECTION "refresh_game_board_row_tiles_loop_original", ROM0[$2f4e]
refresh_game_board_row_tiles_loop_original:
	ld		hl,$d023
	ld		a,[hli]
	ld		b,a
	ld		a,[hli]
	ld		c,a
	ld		d,$c8
	inc		hl
	ld		e,[hl]
	push	bc
	pop		hl
	
	; original code just sets DMG tiles in VRAM bank 0
;	ld		b,$08 ;8 columns
;.eight_tiles:
;	ld		a,[de]
;	ld		[hli],a
;	inc		e
;	dec		b
;	jr		nz, .eight_tiles

	; our code will set both DMG tiles and CGB attributes in VRAM banks 0 and 1
	call	NEW_VBLANK_CODE

	ld		hl,$ffef
	dec		[hl]
	ld		a,[hl]
	dec		a
	ret		nz
	ld		[hl],a
	ret
	
	




















;SOME USEFUL ORIGINAL SUBROUTINES FOUND DURING RESEARCH
SECTION "repaint_game_board_after_ending_original", ROM0[$156c]
repaint_game_board_after_ending_original:

SECTION "initialize_ending_original", ROM0[$18d1]
initialize_ending_original:

;empty_game_board is called when 1P presses start after win/lose game, it fills the game board (RAM $C800) to $FF
SECTION "empty_game_board", ROM0[$0b83]
empty_game_board:

SECTION "empty_oam", ROM0[$1e40]
empty_oam:

SECTION "prepare_1p_win_lose_window", ROM0[$22cd]
prepare_1p_win_lose_window:

SECTION "Shadow OAM", WRAM0[$C000]
_shadow_oam:

SECTION "Playable field tile map", WRAM0[$C800]
_playable_field_tile_map:

SECTION "wait_for_vblank", ROM0[$2250]
wait_for_vblank:

SECTION "mem_copy", ROM0[$20b2]
mem_copy: ;hl:source, de:target, bc:number of bytes

;copies the current playable megavitamin to shadow OAM ($C000)
SECTION "get_next_megavitamin_original", ROM0[$1185]
get_next_megavitamin_original:

SECTION "set_playable_megavitamin_shadow_oam_original", ROM0[$2460]
set_playable_megavitamin_shadow_oam_original:

SECTION "Possible free space (start)", ROMX[$7fd2],BANK[1]
free_rom:
SECTION "Possible free space (end)", ROMX[$7fef],BANK[1]
free_rom_end:




















SECTION "bank_dx", ROMX[$4000],BANK[3]
copy_static_screen_to_hl_dx:
	; keep a copy of the map id (current offset in de) we are copying
	; only need to store the second byte
	; $5d 9a=title screen
	; $5c 32=configure game screen
	; $3a 38=main game
	; $3b a0=main game (multiplayer)
	; $3d 08=ending
	; $3d aa=multiplayer results windows (special 9x18 treatment)

	ld		a, e
	ld		[TEMP_VAR_COPIED_MAP_ORIGINAL_OFFSET], a

	; if we are copying multiplayer results window, go to the 9x18 copy loop
	cp		$aa
	ld		de, TEMP_VAR_COPIED_MAP
	jp		z, .copy_static_screen_9x18		


	


.copy_static_screen_20x18:
	ld		b, 18	
.copy_static_screen_20x18_row_loop:
	ld		c, 20
.copy_static_screen_20x18_column_loop:
	ld		a, [de]
	ld		[hl], a
	
	push	de

	ld		e, a

	; if we are copying ending, we will get palettes from _PALETTES_BY_TILE_ENDING
	ld		a, [TEMP_VAR_COPIED_MAP_ORIGINAL_OFFSET]
	cp		$08
	jr		nz, .set_normal_tile_palette

	ld		d, HIGH(_PALETTES_BY_TILE_ENDING)
	jr		.copy_tile

.set_normal_tile_palette:
	ld		d, HIGH(_PALETTES_BY_TILE)

.copy_tile:
	; go to CGB VRAM bank 1
	ld		a, 1
	ld		[$FF4F], a
	ld		a, [de]
	ld		[hli], a

	; return to DMG VRAM bank 0
	ld		a, 0
	ld		[$FF4F], a

	pop		de
	inc		de

	dec		c
	jr		nz, .copy_static_screen_20x18_column_loop

	REPT 12
		inc		hl
	ENDR
	dec		b
	jr		nz, .copy_static_screen_20x18_row_loop

	; check which map we were copying
	;ending screen needs fixes in water
	ld		a, [TEMP_VAR_COPIED_MAP_ORIGINAL_OFFSET]
	cp		$08
	jp		z, .fix_screen_ending

	;main game needs a fix in clipboard and pause window needs fix in pause text, and also applies current level palette (or restore it after ending)
	cp		$38	
	ret		nz


	; go to CGB VRAM bank 1
	ld		a, 1
	ld		[$FF4F], a

	ld		a, h
	cp		$9a
	jr		z, .apply_level_palette


	;fix pause text palette
.fix_pause_text_palette:
	ld		a, 4	
	ld		hl, $9d02
	REPT 8
		ld	[hli], a
	ENDR
	;window does need to reapply the level palettes (just for efficiency purposes)
	jr		z, .fix_clipboard_palette
	

.apply_level_palette:
	call	set_level_palettes
.fix_clipboard_palette:
	;fix clipboard palette
	ld		a, 3	
	ld		hl, $994c
	REPT 7
		ld	[hli], a
	ENDR
	ld		l, $6c
	REPT 7
		ld	[hli], a
	ENDR
	ld		l, $8c
	REPT 7
		ld	[hli], a
	ENDR
	ld		l, $ac
	REPT 7
		ld	[hli], a
	ENDR
	
	ld		hl, $9d4c
	REPT 7
		ld	[hli], a
	ENDR
	ld		l, $6c
	REPT 7
		ld	[hli], a
	ENDR
	ld		l, $8c
	REPT 7
		ld	[hli], a
	ENDR
	ld		l, $ac
	REPT 7
		ld	[hli], a
	ENDR

	; return to DMG VRAM bank 0
	ld		a, 0
	ld		[$FF4F], a

	ret





.fix_screen_ending:
	; go to CGB VRAM bank 1
	ld		a, 1
	ld		[$FF4F], a

	ld		hl, $9860
	REPT 20
		ld	[hli], a
	ENDR
	ld		l, $80
	REPT 20
		ld	[hli], a
	ENDR
	ld		l, $a0
	REPT 20
		ld	[hli], a
	ENDR

	ld		l, $c0
	ld		a, 2
	REPT 20
		ld	[hli], a
	ENDR
	ld		l, $e0
	REPT 20
		ld	[hli], a
	ENDR
	ld		hl, $9900
	REPT 20
		ld	[hli], a
	ENDR

	ld		a, 4
	ld		hl, $99e1
	ld		[hl], a
	ld		l, $f2
	ld		[hl], a


	; return to DMG VRAM bank 0
	ld		a, 0
	ld		[$FF4F], a
	

	;set default palettes
	ld		h, HIGH(_PALETTES_ENDING_BG)
	call	set_all_palettes

	ret

.copy_static_screen_9x18:
	ld		b, 18	
.copy_static_screen_9x18_row_loop:
	ld		c, 9
.copy_static_screen_9x18_column_loop:
	ld		a, [de]
	ld		[hl], a
	
	push	de
	ld		d, HIGH(_PALETTES_BY_TILE)
	ld		e, a
	; go to CGB VRAM bank 1
	ld		a, 1
	ld		[$FF4F], a
	ld		a, [de]
	ld		[hli], a

	; return to DMG VRAM bank 0
	ld		a, 0
	ld		[$FF4F], a

	pop		de
	inc		de

	dec		c
	jr		nz, .copy_static_screen_9x18_column_loop

	REPT 23
		inc		hl
	ENDR
	dec		b
	jr		nz, .copy_static_screen_9x18_row_loop
	ret

	
















;our new additional code needs to be as fast as possible, so we unroll all loops
additional_vblank_code_dx:
	push	hl

	;set tiles in DMG bank 0
	REPT 8
		ld		a,[de]
		ld		[hli],a	
		inc		e
	ENDR

	;check last column tile
	cp		$fe
	pop		hl
	
	;if last column is $fe, it's an empty message box tile
	jr		z, .message
	;if last column is <$25, it's a character in a message box (usually an exclamation mark)
	cp		$26
	jr		c, .message


	; go to CGB VRAM bank 1
	ld		a, 1
	ld		[$FF4F], a

	ld		a, $07
	;set tiles in CGB bank 1
	REPT 8
		ld		[hli], a
	ENDR

	; return to DMG VRAM bank 0
	ld		a, 0
	ld		[$FF4F], a

	ret

.message:
	; go to CGB VRAM bank 1
	ld		a, 1
	ld		[$FF4F], a

	ld		a, $06
	;set tiles in CGB bank 1
	REPT 8
		ld		[hli], a
	ENDR

	; return to DMG VRAM bank 0
	ld		a, 0
	ld		[$FF4F], a


	ret
additional_vblank_code_dx_end:








;h=higher byte for palettes
set_all_palettes:
	ld		l, $00

	;prepare CGB registers
	ld		a, $c0
	ld		[$FF68], a
	ld		[$FF6a], a

	; CGB palettes - BG
	ld		de, $ff69
	REPT 8*8 ;8 palettes, 8 bytes per palette
		ld		a, [hli]
		ld		[$ff69], a
	ENDR

	; CGB palettes - OBJ
	ld		de, $ff6b
	REPT 8*8 ;8 palettes, 8 bytes per palette
		ld		a, [hli]
		ld		[$ff6b], a
	ENDR
	
	ret

set_level_palettes:
	ld		hl, _PALETTES_BG
	ld		a, [$FFC2] ;current level
	
	;if level is >6
	cp		6
	jr		c, .if_level_gt_11
	inc		h

.if_level_gt_11:
	cp		11
	jr		c, .if_level_gt_16
	inc		h

.if_level_gt_16:
	cp		16
	jr		c, .colorize_level
	inc		h

.colorize_level
	;prepare CGB registers
	ld		a, $c0
	ld		[$FF68], a
	ld		[$FF6a], a

	; CGB palettes - BG
	ld		de, $ff69
	REPT 8*8 ;8 palettes, 8 bytes per palette
		ld		a, [hli]
		ld		[$ff69], a
	ENDR
	
	ld		hl, _PALETTES_OBJ
	; CGB palettes - OBJ
	ld		de, $ff6b
	REPT 8*8 ;8 palettes, 8 bytes per palette
		ld		a, [hli]
		ld		[$ff6b], a
	ENDR
	
	ret

	
	
	












startup_dx:
	;since the game has almost no empty space in ROM, we copy new vblank code to RAM, so it can be run without worrying about bank switching
	ld		de, NEW_VBLANK_CODE
	ld		hl, additional_vblank_code_dx
	ld		bc, additional_vblank_code_dx_end-additional_vblank_code_dx
	call	mem_copy



	;set default palettes
	ld		h, HIGH(_PALETTES_BG)
	call	set_all_palettes

fake_20a3:
	ld		hl, $9bff
	ld		bc, $0400
.fake_20a9:
	ld		a, $ff
	ld		[hld], a
	dec		bc
	ld		a, b
	or		c
	jr		nz, .fake_20a9

	ret







SECTION "Palettes by tile - Main game", ROMX[$7900],BANK[3]
_PALETTES:

_PALETTES_BY_TILE:
DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
DB $01, $01, $01, $01, $01, $01, $01, $01, $00, $01, $01, $01, $01, $00, $00, $00
DB $03, $03, $03, $03, $03, $02, $02, $02, $00, $00, $00, $00, $00, $00, $01, $01
DB $02, $02, $02, $03, $03, $03, $04, $04, $04, $04, $04, $04, $04, $04, $00, $00
DB $00, $00, $00, $00, $00, $00, $00, $00, $04, $04, $04, $04, $04, $04, $04, $02
DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

DB $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
DB $00, $00, $00, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05
DB $00, $00, $00, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05
DB $00, $00, $00, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05
DB $00, $00, $00, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05
DB $00, $00, $00, $00, $00, $00, $05, $05, $05, $05, $05, $05, $05, $05, $00, $00
DB $00, $00, $00, $00, $00, $00, $05, $05, $05, $05, $05, $05, $05, $05, $00, $07

_PALETTES_BG: ;$7a00
DW $1204, $0000, $0980, $7fff ;0: default palette
DW $1204, $37d6, $7f07, $1000 ;1: level border
DW $1204, $0a1c, $0980, $0002 ;2: clipboard (1)
DW $0e5e, $7fff, $1204, $0024 ;3: clipboard (2)
DW $1204, $737f, $34dd, $0000 ;4: HUD borders
DW $0f3d, $7fff, $6884, $0000 ;5: logo
DW $7c1f, $1084, $7c1f, $37d6 ;6: win/lose message box
DW $0000, $7b20, $415d, $27de ;7: megavitamins

_PALETTES_OBJ:
DW $0000, $7fff, $0fdd, $309f ;0: menu selectors
DW $0000, $7fff, $5b1f, $00d8 ;1: Dr. Mario
DW $0000, $0000, $309f, $0ff7 ;2: Multiplayer big score
DW $0000, $0f7f, $0e9f, $0297 ;3: Multiplayer crowns
DW $0000, $27de, $7b20, $2042 ;4: Blue virus
DW $0000, $27de, $415d, $0848 ;5: Red virus
DW $0000, $7b20, $27de, $00c6 ;6: Yellow virus
DW $0000, $7b20, $415d, $27de ;7: playable megavitamins



SECTION "Palettes by tile - Main game (levels 6-10)", ROMX[$7b00],BANK[3]
_PALETTES_BG1:
DW $699a, $0000, $767f, $7fff ;0: default palette
DW $699a, $7b3f, $7f07, $1000 ;1: level border
DW $699a, $7143, $767f, $0002 ;2: clipboard (1)
DW $7a25, $7fff, $699a, $0024 ;3: clipboard (2)
DW $699a, $679f, $09df, $0000 ;4: HUD borders
DW $1b5e, $7fff, $192c, $0000 ;5: logo
DW $7c1f, $1084, $7c1f, $7b3f ;6: win/lose message box
DW $0000, $7b20, $415d, $27de ;7: playable megavitamins


SECTION "Palettes by tile - Main game (levels 11-15)", ROMX[$7c00],BANK[3]
_PALETTES_BG2:
DW $7d8e, $0000, $78e9, $7fff ;0: default palette
DW $7d8e, $7ed8, $1390, $1000 ;1: level border
DW $7d8e, $445b, $78e9, $0002 ;2: clipboard (1)
DW $589d, $7fff, $7d8e, $0024 ;3: clipboard (2)
DW $7d8e, $3bb5, $06aa, $0000 ;4: HUD borders
DW $075e, $7fff, $290b, $0000 ;5: logo
DW $7c1f, $1084, $7c1f, $7f32 ;6: win/lose message box
DW $0000, $7b20, $415d, $27de ;7: playable megavitamins


SECTION "Palettes by tile - Main game (levels 16-20)", ROMX[$7d00],BANK[3]
_PALETTES_BG3:
DW $0b1f, $0000, $027e, $7fff ;0: default palette
DW $0b1f, $7fff, $113c, $1000 ;1: level border
DW $0b1f, $294a, $027e, $0002 ;2: clipboard (1)
DW $3def, $7fff, $0b1f, $0024 ;3: clipboard (2)
DW $0b1f, $7ed6, $7508, $0000 ;4: HUD borders
DW $30df, $777e, $34a4, $0000 ;5: logo
DW $7c1f, $1084, $7c1f, $0b5e ;6: win/lose message box
DW $0000, $7b20, $415d, $27de ;7: playable megavitamins









;align this one to $xx00 so higher byte is always the same
SECTION "Palettes by tile - Ending", ROMX[$7e00],BANK[3]

_PALETTES_BY_TILE_ENDING:
DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

DB $00, $00, $04, $05, $05, $00, $05, $05, $05, $05, $05, $05, $05, $03, $03, $03
DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $04
DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03

_PALETTES_ENDING_BG:
DW $6dab, $22bd, $7c1f, $7c1f ;0: sky
DW $6dab, $6dab, $7c1f, $0000 ;1: water 1
DW $654b, $654b, $7c1f, $0000 ;2: water 2
DW $5d29, $654b, $1d61, $29e3 ;3: water 3
DW $3254, $1d8d, $1d61, $29e3 ;4: sand 1
DW $3254, $1d8d, $1575, $10ec ;5: sand 2
DW $7fff, $56b5, $2d6b, $0000 ;6: unused
DW $7fff, $56b5, $2d6b, $0000 ;7: unused

_PALETTES_ENDING_OBJ:
DW $0000, $7fff, $03f5, $249c ;0: Fishes
DW $0000, $16fa, $1952, $1109 ;1: Ammonite
DW $0000, $733d, $2899, $1064 ;2: UFO/Fish/Crab
DW $0000, $6366, $6a83, $2125 ;3: Coelacanth/Flying fish
DW $0000, $27de, $7b20, $2042 ;4: Blue virus
DW $0000, $27de, $415d, $0848 ;5: Red virus
DW $0000, $7b20, $27de, $00c6 ;6: Yellow virus / bubbles
DW $7fff, $56b5, $2d6b, $0000 ;7: unused

_PALETTES_END:
