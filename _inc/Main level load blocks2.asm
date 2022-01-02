; ---------------------------------------------------------------------------
; Main level load blocks
;
; ===FORMAT===
; level	patterns + (1st	PLC num	* 10^6)
; 16x16	mappings + (2nd	PLC num	* 10^6)
; 256x256 mappings
; blank, music (unused), pal index (unused), pal index
; ---------------------------------------------------------------------------
	dc.l Nem_GHZ2_2nd+$4000000
	dc.l Blk16_GHZ2+$5000000
	dc.l Blk256_GHZ2
	dc.b 0,	$81, 4,	4
	dc.l Nem_LZ2+$6000000
	dc.l Blk16_LZ2+$7000000
	dc.l Blk256_LZ2
	dc.b 0,	$82, 5,	5
	dc.l Nem_MZ2+$8000000
	dc.l Blk16_MZ2+$9000000
	dc.l Blk256_MZ2
	dc.b 0,	$83, 6,	6
	dc.l Nem_SLZ2+$A000000
	dc.l Blk16_SLZ2+$B000000
	dc.l Blk256_SLZ2
	dc.b 0,	$84, 7,	7
	dc.l Nem_SYZ2+$C000000
	dc.l Blk16_SYZ2+$D000000
	dc.l Blk256_SYZ2
	dc.b 0,	$85, 8,	8
	dc.l Nem_SBZ2+$E000000
	dc.l Blk16_SBZ2+$F000000
	dc.l Blk256_SBZ2
	dc.b 0,	$86, 9,	9
	dc.l Nem_GHZ2_2nd; main load block for ending
	dc.l Blk16_GHZ2
	dc.l Blk256_GHZ2
	dc.b 0,	$86, $13, $13
	even