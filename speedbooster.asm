; ----------------------------------------------------------------------------
; Object 06 - Booster things from CPZ
; ----------------------------------------------------------------------------

SpeedBooster:				; DATA XREF: ROM:0001600Co
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Booster_Index(pc,d0.w),d1
		jmp	Booster_Index(pc,d1.w)
; ===========================================================================
Booster_Index:	dc.w Booster_Init-Booster_Index; 0 ; DATA XREF: h+B346o h+B348o
		dc.w Booster_Loop-Booster_Index; 1
word_222BE:	dc.w $1000		; 0
		dc.w  $A00		; 1
; ===========================================================================

Booster_Init:				; DATA XREF: h+B346o
		addq.b	#2,obRoutine(a0)
		move.l	#Map_SpeedBooster,obMap(a0)
		
		;move.w	#$372,obGfx(a0) ; SYZ2 specific code
		;cmpi.w	#(id_SYZ<<8)+1,(v_zone).w ; check if level is SY2
		;beq.s	@Continue	; if yes, branch
		move.w	#$0400*$20,obGfx(a0) ; 0 = palette line, XXX = Tile address (VRAM address / $20)

	@Continue:	
		;bsr.w	loc_22402
		ori.b	#4,obRender(a0)
		move.b	#$20,obActWid(a0) ; ' '
		move.b	#1,obPriority(a0)
		move.b	obSubtype(a0),d0
		andi.w	#2,d0
		move.w	word_222BE(pc,d0.w),$30(a0)

Booster_Loop:				; DATA XREF: h+B346o
		;move.b	(obTimeFrame).w,obFrame(a0)
		;andi.b	#2,d0
		;move.b	d0,obFrame(a0)
		;move.b	(v_ani1_frame).w,obFrame(a0)
		move.w	$8(a0),d0
		move.w	d0,d1
		subi.w	#$10,d0
		addi.w	#$10,d1
		move.w	obY(a0),d2
		move.w	d2,d3
		subi.w	#$10,d2
		addi.w	#$10,d3
		;lea	($FFFFB000).w,a1
		lea	(v_player).w,a1
		btst	#1,obStatus(a1)
		bne.s	loc_22384
		move.w	$8(a1),d4
		cmp.w	d0,d4
		bcs.w	loc_22384
		cmp.w	d1,d4
		bcc.w	loc_22384
		move.w	obY(a1),d4
		cmp.w	d2,d4
		bcs.w	loc_22384
		cmp.w	d3,d4
		bcc.w	loc_22384
		move.w	d0,-(sp)
		bsr.w	loc_22388
		move.w	(sp)+,d0
		;bsr.w	loc_22388

;loc_22354:				; CODE XREF: h+B3B6j h+B3BEj ...
		;lea	(v_player).w,a1 ; a1=character
		;btst	#1,$22(a1)
		;bne.s	loc_22384
		;move.w	8(a1),d4
		;cmp.w	d0,d4
		;bcs.w	loc_22384
		;cmp.w	d1,d4
		;bcc.w	loc_22384
		;move.w	$C(a1),d4
		;cmp.w	d2,d4
		;bcs.w	loc_22384
		;cmp.w	d3,d4
		;bcc.w	loc_22384
		;bsr.w	loc_22388
jmp_loc_223FC
		jmp	loc_223FC
loc_22384:				; CODE XREF: h+B3EAj h+B3F2j ...
		bra.w	jmp_loc_223FC
; ===========================================================================

loc_22388:				; CODE XREF: h+B3DAp h+B40Cp
		move.w	obVelX(a1),d0
		btst	#0,obStatus(a0)
		beq.s	loc_22396
		neg.w	d0

loc_22396:				; CODE XREF: h+B41Ej
		cmpi.w	#$1000,d0 			; is the character already going super fast?
		bge.s	loc_223D8 			; if yes, branch to not change the speed
		move.w	$30(a0),obVelX(a1)  ; make the character go super fast
		bclr	#0,obStatus(a1)		; turn him right
		btst	#0,obStatus(a0)		; was that the correct direction?
		beq.s	loc_223BA 			; if yes, branch
		bset	#0,obStatus(a1)		; turn him left
		neg.w	obVelX(a1)			; make the boosting direction left

loc_223BA:				; CODE XREF: h+B43Aj
		;move.w	#$F,$2E(a1)
		move.w	obVelX(a1),obInertia(a1)
		bclr	#5,obStatus(a0)
		bclr	#6,obStatus(a0)
		bclr	#5,obStatus(a1)
		
		;addq.w	#5,obY(a1)

loc_223D8:				; CODE XREF: h+B426j
		;move.w	#$D1,d0	; 'Ì'
		;jmp	(play_SFX).l
		bset	#2,obStatus(a1)		;set rolling bit
		move.b	#$E,obHeight(a1) 	; change hitbox
		move.b	#7,obWidth(a1)	  	; change hitbox
		move.b	#2,obAnim(a1) ; use "rolling" animation
		move.w	#$CC,d0
		jsr	(PlaySound_Special).l ;	play spring sound
		rts