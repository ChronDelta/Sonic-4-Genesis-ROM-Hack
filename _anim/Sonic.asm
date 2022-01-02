; ---------------------------------------------------------------------------
; Animation script - Sonic
; ---------------------------------------------------------------------------
		dc.w SonAni_Walk-SonicAniData	; 0
		dc.w SonAni_Run-SonicAniData	; 1
		dc.w SonAni_Roll-SonicAniData	; 2
		dc.w SonAni_Roll2-SonicAniData	; 3
		dc.w SonAni_Push-SonicAniData	; 4
		dc.w SonAni_Wait-SonicAniData	; 5
		dc.w SonAni_Balance-SonicAniData	; 6
		dc.w SonAni_LookUp-SonicAniData	; 7
		dc.w SonAni_Duck-SonicAniData	; 8
		dc.w SonAni_Warp1-SonicAniData	; 9
		dc.w SonAni_Warp2-SonicAniData	; A
		dc.w SonAni_Warp3-SonicAniData	; B
		dc.w SonAni_Warp4-SonicAniData	; C
		dc.w SonAni_Stop-SonicAniData	; D
		dc.w SonAni_Float1-SonicAniData	; E
		dc.w SonAni_Float2-SonicAniData	; F
		dc.w SonAni_Spring-SonicAniData	; 10
		dc.w SonAni_LZHang-SonicAniData	; 11
		dc.w SonAni_Leap1-SonicAniData	; 12
		dc.w SonAni_Leap2-SonicAniData	; 13
		dc.w SonAni_Surf-SonicAniData	; 14
		dc.w SonAni_Bubble-SonicAniData	; 15
		dc.w SonAni_Death-SonicAniData	; 16
		dc.w SonAni_Drown-SonicAniData	; 17
		dc.w SonAni_Hurt-SonicAniData	; 18
		dc.w SonAni_LZSlide-SonicAniData	; 19
		dc.w SonAni_Blank-SonicAniData	; 1A
		dc.w SonAni_Float3-SonicAniData	; 1B
		dc.w SonAni_Float4-SonicAniData	; 1C
		dc.w SonAni_Spindash-SonicAniData	; 1D
		dc.w SonAni_Blink-SonicAniData	; 1E
		dc.w SonAni_GetUp-SonicAniData	; 1F
		dc.w SonAni_Balance2-SonicAniData	; 20
		dc.w SonAni_Hang-SonicAniData		; 2A
		dc.w SonAni_Dash2-SonicAniData	; 2B
		dc.w SonAni_Dash3-SonicAniData	; 2C
		dc.w SonAni_Hang2-SonicAniData	; 2D
		dc.w SonAni_DeathBW-SonicAniData	; 2E	
		dc.w SonAni_Balance3-SonicAniData	; 2F
		dc.w SonAni_Balance4-SonicAniData	; 30		
		dc.w SonAni_Lying-SonicAniData	; 31
		dc.w SonAni_LieDown-SonicAniData	; 32
SonAni_Walk:	dc.b $FF, $F,$10,$11,$12,$13,$14, $D, $E,$FF
SonAni_Run:	dc.b $FF,$2D,$2E,$2F,$30,$FF,$FF,$FF,$FF,$FF
SonAni_Roll:	dc.b $FE,$3D,$41,$3E,$41,$3F,$41,$40,$41,$FF
SonAni_Roll2:	dc.b $FE,$3D,$41,$3E,$41,$3F,$41,$40,$41,$FF
SonAni_Push:	dc.b $FD,$48,$49,$4A,$4B,$FF,$FF,$FF,$FF,$FF
SonAni_Wait:
	dc.b   5,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1
	dc.b   1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  2
	dc.b   3,  3,  3,  3,  3,  4,  4,  4,  5,  5,  5,  4,  4,  4,  5,  5
	dc.b   5,  4,  4,  4,  5,  5,  5,  4,  4,  4,  5,  5,  5,  6,  6,  6
	dc.b   6,  6,  6,  6,  6,  6,  6,  4,  4,  4,  5,  5,  5,  4,  4,  4
	dc.b   5,  5,  5,  4,  4,  4,  5,  5,  5,  4,  4,  4,  5,  5,  5,  6
	dc.b   6,  6,  6,  6,  6,  6,  6,  6,  6,  4,  4,  4,  5,  5,  5,  4
	dc.b   4,  4,  5,  5,  5,  4,  4,  4,  5,  5,  5,  4,  4,  4,  5,  5
	dc.b   5,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  4,  4,  4,  5,  5
	dc.b   5,  4,  4,  4,  5,  5,  5,  4,  4,  4,  5,  5,  5,  4,  4,  4
	dc.b   5,  5,  5,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  7,  8,  8
	dc.b   8,  9,  9,  9,$FE,  6
SonAni_Balance:	dc.b   9,$CC,$CD,$CE,$CD,$FF
SonAni_LookUp:	dc.b   5, $B, $C,$FE,  1
SonAni_Duck:	dc.b   5,$4C,$4D,$FE,  1
SonAni_Warp1:	dc.b $3F, $33, $FF, 0
SonAni_Warp2:	dc.b $3F, $34, $FF, 0
SonAni_Warp3:	dc.b $3F, $35, $FF, 0
SonAni_Warp4:	dc.b $3F, $36, $FF, 0
SonAni_Blink:	dc.b   1,  2,$FD,  0
SonAni_GetUp:	dc.b   3, $A,$FD,  0
SonAni_Balance2:    dc.b   3,$C8,$C9,$CA,$CB,$FF
SonAni_Stop:	dc.b   5,$D2,$D3,$D4,$D5,$FD,  0 ; halt/skidding animation
SonAni_Float1:	dc.b   7,$54,$59,$FF
SonAni_Float2:	dc.b   7,$54,$55,$56,$57,$58,$FF
SonAni_Spring:	dc.b $2F,$5B,$FD,  0
SonAni_LZHang:	dc.b 4,	$41, $42, $FF
SonAni_Leap1:	dc.b $F, $43, $43, $43,	$FE, 1
SonAni_Leap2:	dc.b $F, $43, $44, $FE,	1, 0
SonAni_Surf:	dc.b $3F, $49, $FF, 0
SonAni_Bubble:	dc.b  $B,$5A,$5A,$11,$12,$FD,  0 ; breathe
SonAni_Drown:	dc.b $20,$5D,$FF
SonAni_Death:	dc.b $20,$5C,$FF
SonAni_Hurt:	dc.b $40,$4E,$FF
SonAni_LZSlide:	dc.b   9,$4E,$4F,$FF
SonAni_Blank:	dc.b $77, 0, $FD, 0
SonAni_Spindash: dc.b   0,$42,$43,$42,$44,$42,$45,$42,$46,$42,$47,$FF
SonAni_Hang:	dc.b   1,$50,$51,$FF
SonAni_Dash2:	dc.b  $F,$43,$43,$43,$FE,  1
SonAni_Dash3:	dc.b  $F,$43,$44,$FE,  1
SonAni_Hang2:	dc.b $13,$6B,$6C,$FF
SonAni_DeathBW:	dc.b $20,$5E,$FF
SonAni_Float3:	dc.b 3,	$3C, $3D, $53, $3E, $54, $FF, 0
SonAni_Float4:	dc.b 3,	$3C, $FD, 0
SonAni_Balance3:dc.b $13,$D0,$D1,$FF
SonAni_Balance4:dc.b   3,$CF,$C8,$C9,$CA,$CB,$FE,  4
SonAni_Lying:	dc.b   9,  8,  9,$FF
SonAni_LieDown:	dc.b   3,  7,$FD,  0
		even
; ---------------------------------------------------------------------------
; Animation script - Super Sonic
; (many of these point to the data above this)
; ---------------------------------------------------------------------------
SuperSonicAniData:
	dc.w SupSonAni_Walk-SuperSonicAniData		; 0
	dc.w SupSonAni_Run-SuperSonicAniData          ; 1
	dc.w SonAni_Roll-SuperSonicAniData            ; 2
	dc.w SonAni_Roll2-SuperSonicAniData           ; 3
	dc.w SupSonAni_Push-SuperSonicAniData         ; 4
	dc.w SupSonAni_Stand-SuperSonicAniData        ; 5
	dc.w SupSonAni_Balance-SuperSonicAniData      ; 6
	dc.w SonAni_LookUp-SuperSonicAniData          ; 7
	dc.w SupSonAni_Duck-SuperSonicAniData         ; 8
	dc.w SonAni_Spindash-SuperSonicAniData        ; 9
	dc.w SonAni_Blink-SuperSonicAniData           ; 10 ; $A
	dc.w SonAni_GetUp-SuperSonicAniData           ; 11 ; $B
	dc.w SonAni_Balance2-SuperSonicAniData        ; 12 ; $C
	dc.w SonAni_Stop-SuperSonicAniData            ; 13 ; $D
	dc.w SonAni_Float1-SuperSonicAniData           ; 14 ; $E
	dc.w SonAni_Float2-SuperSonicAniData          ; 15 ; $F
	dc.w SonAni_Spring-SuperSonicAniData          ; 16 ; $10
	dc.w SonAni_Hang-SuperSonicAniData            ; 17 ; $11
	dc.w SonAni_Dash2-SuperSonicAniData           ; 18 ; $12
	dc.w SonAni_Dash3-SuperSonicAniData           ; 19 ; $13
	dc.w SonAni_Hang2-SuperSonicAniData           ; 20 ; $14
	dc.w SonAni_Bubble-SuperSonicAniData          ; 21 ; $15
	dc.w SonAni_DeathBW-SuperSonicAniData         ; 22 ; $16
	dc.w SonAni_Drown-SuperSonicAniData           ; 23 ; $17
	dc.w SonAni_Death-SuperSonicAniData           ; 24 ; $18
	dc.w SonAni_Hurt-SuperSonicAniData            ; 25 ; $19
	dc.w SonAni_Hurt-SuperSonicAniData            ; 26 ; $1A
	dc.w SonAni_LZSlide-SuperSonicAniData           ; 27 ; $1B
	dc.w SonAni_Blank-SuperSonicAniData           ; 28 ; $1C
	dc.w SonAni_Balance3-SuperSonicAniData        ; 29 ; $1D
	dc.w SonAni_Balance4-SuperSonicAniData        ; 30 ; $1E
	dc.w SupSonAni_Transform-SuperSonicAniData    ; 31 ; $1F

SupSonAni_Walk:		dc.b $FF,$77,$78,$79,$7A,$7B,$7C,$75,$76,$FF
SupSonAni_Run:		dc.b $FF,$B5,$B9,$FF,$FF,$FF,$FF,$FF,$FF,$FF
SupSonAni_Push:		dc.b $FD,$BD,$BE,$BF,$C0,$FF,$FF,$FF,$FF,$FF
SupSonAni_Stand:	dc.b   7,$72,$73,$74,$73,$FF
SupSonAni_Balance:	dc.b   9,$C2,$C3,$C4,$C3,$C5,$C6,$C7,$C6,$FF
SupSonAni_Duck:		dc.b   5,$C1,$FF
SupSonAni_Transform:	dc.b   2,$6D,$6D,$6E,$6E,$6F,$70,$71,$70,$71,$70,$71,$70,$71,$FD,  0
	even		