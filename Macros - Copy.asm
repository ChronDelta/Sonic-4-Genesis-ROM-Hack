; ===========================================================================
; ---------------------------------------------------------------------------
; Macros
; ---------------------------------------------------------------------------

	; --- Alignment ---

align		macro	Size,Value
		dcb.b	Size-(*%Size),Value
		endm

	; --- Stop Z80 ---

StopZ80		macro
		move.w	#$0100,($A11100).l			; request Z80 stop (ON)
		btst.b	#$00,($A11100).l			; has the Z80 stopped yet?
		bne.s	*-$08					; if not, branch
		endm

	; --- Start Z80 ---

StartZ80	macro
		move.w	#$0000,($A11100).l			; request Z80 stop (OFF)
		endm

	; --- Turning DMA mode on ---

Z80DMA_ON	macro
		StopZ80
		move.b	#(Flush&$FF),($A00000+FL_FlushSwitch+1).l	; change the "jp" instruction address to "Flush" routine loop
		StartZ80
		move.w	#$0180,d7				; set delay time (give z80 time to get out of the "CatchUp" routine...
		nop						; ...and into the "Flush" routine, so the 68k doesn't start DMA before...
		nop						; ...the z80 has a chance to stop reading from the window
		dbf	d7,*-$04				; loop back and perform the nops again...
		endm

	; --- Turning DMA mode off ---

Z80DMA_OFF	macro
		StopZ80
		move.b	#(CatchUp&$FF),($A00000+FL_FlushSwitch+1).l	; change the "jp" instruction address to "CatchUp" routine loop
		StartZ80
		endm


	; --- Storing 68k address for Z80 as dc ---

dcz80		macro	Sample
		dc.b	(Sample&$FF)
		dc.b	(((Sample>>$08)&$7F)|$80)
		dc.b	((Sample&$7F8000)>>$0F)
		endm

; ===========================================================================