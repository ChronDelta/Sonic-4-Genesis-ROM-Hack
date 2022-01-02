PalCycle_SuperSonic:
	move.b	(Super_Sonic_palette).w,d0
	beq.s	return_2186
	bmi.w	loc_21E6
	subq.b	#1,d0
	bne.s	loc_2188
	subq.b	#1,(Palette_frame_count).w
	bpl.s	return_2186
	move.b	#3,(Palette_frame_count).w
	lea	(Pal_2246).l,a0
	move.w	($FFFFF65C).w,d0
	addq.w	#8,($FFFFF65C).w
	cmpi.w	#$30,($FFFFF65C).w
	bcs.s	sonclolz
	move.b	#-1,(Super_Sonic_palette).w
	move.b	#0,(MainCharacter+obj_control).w
sonclolz:
	lea	(Normal_palette+4).w,a1
	move.l	(a0,d0.w),(a1)+
	move.l	4(a0,d0.w),(a1)

return_2186:
	rts
; ===========================================================================

loc_2188:
	subq.b	#1,(Palette_frame_count).w
	bpl.s	return_2186
	move.b	#3,(Palette_frame_count).w
	lea	(Pal_2246).l,a0
	move.w	($FFFFF65C).w,d0
	subq.w	#8,($FFFFF65C).w
	bcc.s	loc_21B0
	move.b	#0,($FFFFF65C).w
	move.b	#0,(Super_Sonic_palette).w
loc_21B0:
	lea	(Normal_palette+4).w,a1
	move.l	(a0,d0.w),(a1)+
	move.l	4(a0,d0.w),(a1)
	lea	(Pal_22C6).l,a0
	cmpi.b	#$D,(Current_Zone).w
	beq.s	callbackbruh
	cmpi.b	#$F,(Current_Zone).w
	bne.s	return_2186
	lea	(Pal_2346).l,a0
callbackbruh:
	lea	(Underwater_palette+4).w,a1
	move.l	(a0,d0.w),(a1)+
	move.l	4(a0,d0.w),(a1)
	rts
; ===========================================================================

loc_21E6:
	subq.b	#1,(Palette_frame_count).w
	bpl.s	return_2186
	move.b	#7,(Palette_frame_count).w
	lea	(Pal_2246).l,a0
	move.w	($FFFFF65C).w,d0
	addq.w	#8,($FFFFF65C).w
	cmpi.w	#$78,($FFFFF65C).w
	bcs.s	segergener
	move.w	#$30,($FFFFF65C).w
segergener:
	lea	(Normal_palette+4).w,a1
	move.l	(a0,d0.w),(a1)+
	move.l	4(a0,d0.w),(a1)
	lea	(Pal_22C6).l,a0
	cmpi.b	#$D,(Current_Zone).w
	beq.s	Brrrrruh
	cmpi.b	#$F,(Current_Zone).w
	bne.w	return_2186
	lea	(Pal_2346).l,a0
Brrrrruh:
	lea	(Underwater_palette+4).w,a1
	move.l	(a0,d0.w),(a1)+
	move.l	4(a0,d0.w),(a1)
	rts
; End of function PalCycle_SuperSonic

;----------------------------------------------------------------------------
;Palette for transformation to Super Sonic
;----------------------------------------------------------------------------
Pal_2246:	INCLUDE	"pallet/sonic.bin"
;----------------------------------------------------------------------------
;Palette for transformation to Super Sonic while underwater in CPZ
;----------------------------------------------------------------------------
Pal_22C6:	INCLUDE	"pallet/sonic.bin"
;----------------------------------------------------------------------------
;Palette for transformation to Super Sonic while underwater in ARZ
;----------------------------------------------------------------------------
Pal_2346:	INCLUDE	"pallet/sonic.bin"
