; ---------------------------------------------------------------------------
; Main level load blocks
;
; ===FORMAT===
; level	patterns + (1st	PLC num	* 10^6)
; 16x16	mappings + (2nd	PLC num	* 10^6)
; 256x256 mappings
; blank, music (unused), pal index (unused), pal index
; ---------------------------------------------------------------------------
	dc.l Nem_GHZ3_2nd+$4000000
	dc.l Blk16_GHZ3+$5000000
	dc.l Blk256_GHZ3
	dc.b 0,	$81, 4,	4
	dc.l Nem_LZ3+$6000000
	dc.l Blk16_LZ3+$7000000
	dc.l Blk256_LZ3
	dc.b 0,	$82, 5,	5
	dc.l Nem_MZ3+$8000000
	dc.l Blk16_MZ3+$9000000
	dc.l Blk256_MZ3
	dc.b 0,	$83, 6,	6
	dc.l Nem_SLZ3+$A000000
	dc.l Blk16_SLZ3+$B000000
	dc.l Blk256_SLZ3
	dc.b 0,	$84, 7,	7
	dc.l Nem_SYZ3+$C000000
	dc.l Blk16_SYZ3+$D000000
	dc.l Blk256_SYZ3
	dc.b 0,	$85, 8,	8
	dc.l Nem_SBZ3+$E000000
	dc.l Blk16_SBZ3+$F000000
	dc.l Blk256_SBZ3
	dc.b 0,	$86, 9,	9
	dc.l Nem_GHZ3_2nd; main load block for ending
	dc.l Blk16_GHZ3
	dc.l Blk256_GHZ3
	dc.b 0,	$86, $13, $13
	even