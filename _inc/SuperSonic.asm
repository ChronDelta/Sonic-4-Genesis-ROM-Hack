; ---------------------------------------------------------------------------
; Subroutine called at the peak of a jump that transforms Sonic into Super Sonic
; if he has enough rings and emeralds
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; loc_1AB38: test_set_SS:
	tst.b	(Super_Sonic_flag).w	; is Sonic already Super?
	bne.s	return_1ABA4		; if yes, branch
;	cmpi.b	#6,(Emerald_count).w	; does Sonic have exactly 7 emeralds?
;	bne.s	return_1ABA4		; if not, branch
	cmpi.w	#50,(Ring_count).w	; does Sonic have at least 50 rings?
	bcs.s	return_1ABA4		; if not, branch

	move.b	#1,(Super_Sonic_palette).w
	move.b	#$F,(Palette_frame_count).w
	move.b	#1,(Super_Sonic_flag).w
	move.b	#$81,obj_control(a0)
	move.b	#$1F,anim(a0)			; use transformation animation
;	move.b	#$7E,(Object_RAM+$2040).w	; Obj7E is the ending sonic which is why it's commented out
	move.w	#$A00,(Sonic_top_speed).w
	move.w	#$30,(Sonic_acceleration).w
	move.w	#$100,(Sonic_deceleration).w
	move.w	#0,invincibility_time(a0)
		move.b	#1,($FFFFFE2D).w ; make	Sonic invincible		move.b	#$38,($FFFFD200).w ; load stars	object ($3801)
		move.b	#1,($FFFFD21C).w
		move.b	#$38,($FFFFD240).w ; load stars	object ($3802)
		move.b	#2,($FFFFD25C).w
		move.b	#$38,($FFFFD280).w ; load stars	object ($3803)
		move.b	#3,($FFFFD29C).w
		move.b	#$38,($FFFFD2C0).w ; load stars	object ($3804)
		move.b	#4,($FFFFD2DC).w	
        move.w	#$C3,d0         ; 
	jsr	(PlaySound).l	; Play special ring sound effect.
	move.w	#$9F,d0         
	jmp	(PlaySound_Special).l	; load the invincibility song and return also playmusic doesn't exist

; End of subroutine Sonic_CheckGoSuper

; ---------------------------------------------------------------------------
; Subroutine doing the extra logic for Super Sonic
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
rts:
	rts
; loc_1ABA6:
Sonic_Super:
	tst.b	(Super_Sonic_flag).w	; Ignore all this code if not Super Sonic
	beq.w	return_1AC3C
	tst.b	(Update_HUD_timer).w
	beq.s	Sonic_RevertToNormal ; ?
	subq.w	#1,(Super_Sonic_frame_count).w
	bpl.w	return_1AC3C
	move.w	#60,(Super_Sonic_frame_count).w	; Reset frame counter to 60
	tst.w	(Ring_count).w
	beq.s	Sonic_RevertToNormal
	ori.b	#1,(Update_HUD_rings).w
	cmpi.w	#1,(Ring_count).w
	beq.s	@update
	cmpi.w	#10,(Ring_count).w
	beq.s	@update
	cmpi.w	#100,(Ring_count).w
	bne.s	@update2
@update
	ori.b	#$80,(Update_HUD_rings).w
@update2
	subq.w	#1,(Ring_count).w
	bne.s	rts
; loc_1ABF2:
Sonic_RevertToNormal:
	move.b	#2,(Super_Sonic_palette).w	; Remove rotating palette
	move.w	#$28,($FFFFF65C).w	; Unknown
	move.b	#0,(Super_Sonic_flag).w
	move.b	#1,next_anim(a0)	; Change animation back to normal ?
	move.w	#1,invincibility_time(a0)	; Remove invincibility
	move.w	#$600,(Sonic_top_speed).w
	move.w	#$C,(Sonic_acceleration).w
	move.w	#$80,(Sonic_deceleration).w
	btst	#6,status(a0)	; Check if underwater, return if not
	beq.s	return_1AC3C
	move.w	#$300,(Sonic_top_speed).w
	move.w	#6,(Sonic_acceleration).w
	move.w	#$40,(Sonic_deceleration).w

return_1AC3C:
	rts
; End of subroutine Sonic_Super