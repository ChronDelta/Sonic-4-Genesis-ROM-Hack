v_objspace:	equ $FFFFD000	; object variable space ($40 bytes per object) ($2000 bytes)
v_player:	equ v_objspace	; object variable space for Sonic ($40 bytes)
v_screenposx:	equ $FFFFF700
v_objstate:	equ $FFFFFC00

; Object variables
obRender:	equ 1	; bitfield for x/y flip, display mode
obGfx:		equ 2	; palette line & VRAM setting (2 bytes)
obMap:		equ 4	; mappings address (4 bytes)
obX:		equ 8	; x-axis position (2-4 bytes)
obScreenY:	equ $A	; y-axis position for screen-fixed items (2 bytes)
obY:		equ $C	; y-axis position (2-4 bytes)
obVelX:		equ $10	; x-axis velocity (2 bytes)
obVelY:		equ $12	; y-axis velocity (2 bytes)
obInertia:	equ $14	; potential speed (2 bytes)
obHeight:	equ $16	; height/2
obWidth:	equ $17	; width/2
obPriority:	equ $18	; sprite stack priority -- 0 is front
obActWid:	equ $19	; action width
obFrame:	equ $1A	; current frame displayed
obAniFrame:	equ $1B	; current frame in animation script
obAnim:		equ $1C	; current animation
obNextAni:	equ $1D	; next animation
obTimeFrame:	equ $1E	; time to next frame
obDelayAni:	equ $1F	; time to delay animation
obColType:	equ $20	; collision response type
obColProp:	equ $21	; collision extra property
obStatus:	equ $22	; orientation or mode
obRespawnNo:	equ $23	; respawn list index number
obRoutine:	equ $24	; routine number
ob2ndRout:	equ $25	; secondary routine number
obAngle:	equ $26	; angle
obSubtype:	equ $28	; object subtype
obSolid:	equ ob2ndRout ; solid status flag
out_of_range:	macro exit,pos
		if (narg=2)
		move.w	pos,d0		; get object position (if specified as not obX)
		else
		move.w	obX(a0),d0	; get object position
		endc
		andi.w	#$FF80,d0	; round down to nearest $80
		move.w	(v_screenposx).w,d1 ; get screen position
		subi.w	#128,d1
		andi.w	#$FF80,d1
		sub.w	d1,d0		; approx distance between object and screen
		cmpi.w	#128+320+192,d0
		bhi.\0	exit
		endm
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

; =============
;Sonic 2 Macros
; =============

align macro
	cnop 0,\1
	endm
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Equates section - Names for variables.
; ---------------------------------------------------------------------------
; size variables - you'll get an informational error if you need to change these...
; they are all in units of bytes
Size_of_DAC_samples =		$2F00
Size_of_SEGA_sound =		$6174
Size_of_Snd_driver_guess =	$F64 ; approximate post-compressed size of the Z80 sound driver

; ---------------------------------------------------------------------------
; Object Status Table offsets (for everything between Object_RAM and Primary_Collision)
; ---------------------------------------------------------------------------
; universally followed object conventions:
render_flags =		  1 ; bitfield ; bit 7 = onscreen flag, bit 0 = x mirror, bit 1 = y mirror, bit 2 = coordinate system
art_tile =		  2 ; and 3 ; start of sprite's art
mappings =		  4 ; and 5 and 6 and 7
x_pos =			  8 ; and 9 ... some objects use $A and $B as well when extra precision is required (see ObjectMove) ... for screen-space objects this is called x_pixel instead
y_pos =			 $C ; and $D ... some objects use $E and $F as well when extra precision is required ... screen-space objects use y_pixel instead
priority =		$18 ; 0 = front
width_pixels =		$19
mapping_frame =		$1A
; ---------------------------------------------------------------------------
; conventions followed by most objects:
x_vel =			$10 ; and $11 ; horizontal velocity
y_vel =			$12 ; and $13 ; vertical velocity
y_radius =		$16 ; collision width / 2
x_radius =		$17 ; collision height / 2
anim_frame =		$1B
anim =			$1C
next_anim =		$1D
anim_frame_duration =	$1E
status =		$22 ; note: exact meaning depends on the object... for sonic/tails: bit 0: leftfacing. bit 1: inair. bit 2: spinning. bit 3: onobject. bit 4: rolljumping. bit 5: pushing. bit 6: underwater.
routine =		$24
routine_secondary =	$25
angle =			$26 ; angle about the z=0 axis (360 degrees = 256)
; ---------------------------------------------------------------------------
; conventions followed by many objects but NOT sonic/tails:
collision_flags =	$20
collision_property =	$21
respawn_index =		$23
subtype =		$28
; ---------------------------------------------------------------------------
; conventions specific to sonic/tails (Obj01, Obj02, and ObjDB):
; note: $1F, $20, and $21 are unused and available
inertia =		$14 ; and $15 ; directionless representation of speed... not updated in the air
flip_angle =		$27 ; angle about the x=0 axis (360 degrees = 256) (twist/tumble)
air_left =		$28
flip_turned =		$29 ; 0 for normal, 1 to invert flipping (it's a 180 degree rotation about the axis of Sonic's spine, so he stays in the same position but looks turned around)
obj_control =		$2A ; 0 for normal, 1 for hanging or for resting on a flipper, $81 for going through CNZ/OOZ/MTZ tubes or stopped in CNZ cages or stoppers or flying if Tails
status_secondary =	$2B
flips_remaining =	$2C ; number of flip revolutions remaining
flip_speed =		$2D ; number of flip revolutions per frame / 256
move_lock =		$2E ; and $2F ; horizontal control lock, counts down to 0
invulnerable_time =	$30 ; and $31 ; time remaining until you stop blinking
invincibility_time =	$32 ; and $33 ; remaining
speedshoes_time =	$34 ; and $35 ; remaining
next_tilt =		$36 ; angle on ground in front of sprite
tilt =			$37 ; angle on ground
stick_to_convex =	$38 ; 0 for normal, 1 to make Sonic stick to convex surfaces like the rotating discs in Sonic 1 and 3 (unused in Sonic 2 but fully functional)
spindash_flag =		$39 ; 0 for normal, 1 for charging a spindash or forced rolling
spindash_counter =	$3A ; and $3B
jumping =		$3C
interact =		$3D ; RAM address of the last object Sonic stood on, minus $FFFFB000 and divided by $40
layer =			$3E ; collision plane, track switching...
layer_plus =		$3F ; always same as layer+1 ?? used for collision somehow
; ---------------------------------------------------------------------------
; conventions followed by several objects but NOT sonic/tails:
y_pixel =		2+x_pos ; and 3+x_pos ; y coordinate for objects using screen-space coordinate system
x_pixel =		x_pos ; and 1+x_pos ; x coordinate for objects using screen-space coordinate system
parent =		$3E ; and $3F ; address of object that owns or spawned this one, if applicable
; ---------------------------------------------------------------------------
; unknown or inconsistently used offsets that are not applicable to sonic/tails:
; (provided because rearrangement of the above values sometimes requires making space in here too)
objoff_A =		2+x_pos ; note: x_pos can be 4 bytes, but sometimes the last 2 bytes of x_pos are used for other unrelated things
objoff_B =		3+x_pos
objoff_E =		2+y_pos
objoff_F =		3+y_pos
objoff_14 =		$14
objoff_15 =		$15
objoff_1F =		$1F
objoff_27 =		$27
objoff_28 =		$28 ; overlaps subtype, but a few objects use it for other things anyway
objoff_29 =		$29
objoff_2A =		$2A
objoff_2B =		$2B
objoff_2C =		$2C
objoff_2D =		$2D
objoff_2E =		$2E
objoff_2F =		$2F
objoff_30 =		$30
objoff_31 =		$31
objoff_32 =		$32
objoff_33 =		$33
objoff_34 =		$34
objoff_35 =		$35
objoff_36 =		$36
objoff_37 =		$37
objoff_38 =		$38
objoff_39 =		$39
objoff_3A =		$3A
objoff_3B =		$3B
objoff_3C =		$3C
objoff_3D =		$3D
objoff_3E =		$3E
objoff_3F =		$3F
; ---------------------------------------------------------------------------
; property of all objects:
next_object =		$40 ; the size of an object

; ---------------------------------------------------------------------------
; RAM variables
RAM_Start =			$FFFF0000
Metablock_Table =		$FFFF0000
Level_Layout =			$FFFF8000
Block_Table =			$FFFF9000
Decomp_Buffer =			$FFFFAA00
Sprite_Table_Input = 		$FFFFAC00 ; in custom format before being converted and stored in Sprite_Table/Sprite_Table_2
Object_RAM =			$FFFFB000 ; through $FFFFD5FF
MainCharacter =			$FFFFB000 ; first object (usually Sonic except in a Tails Alone game)
Sidekick =			$FFFFB040 ; second object (Tails in a Sonic and Tails game)
Tails_Tails =			$FFFFD000 ; address of the Tail's Tails object
Sonic_Dust =			$FFFFD100
Tails_Dust =			$FFFFD140

PNT_Buffer =			$FFFFD000 ; in special stage
Primary_Collision =		$FFFFD600
Horiz_Scroll_Buf_2 =		$FFFFD700 ; in special stage
Secondary_Collision =		$FFFFD900
VDP_Command_Buffer =		$FFFFDC00 ; stores VDP commands to issue the next time ProcessDMAQueue is called
VDP_Command_Buffer_Slot =	$FFFFDCFC ; stores the address of the next open slot for a queued VDP command
Sprite_Table_2 =		$FFFFDD00 ; Sprite attribute table buffer for the bottom split screen in 2-player mode
Horiz_Scroll_Buf =		$FFFFE000
Sonic_Stat_Record_Buf =		$FFFFE400
Sonic_Pos_Record_Buf =		$FFFFE500
Tails_Pos_Record_Buf =		$FFFFE600
Ring_Positions =		$FFFFE800
Camera_RAM =			$FFFFEE00
Camera_X_pos =			$FFFFEE00
Camera_Y_pos =			$FFFFEE04
Camera_Max_Y_pos =		$FFFFEEC6
Camera_Min_X_pos =		$FFFFEEC8
Camera_Max_X_pos =		$FFFFEECA
Camera_Min_Y_pos =		$FFFFEECC
Camera_Max_Y_pos_now =		$FFFFEECE ; was "Camera_max_scroll_spd"...
Sonic_Pos_Record_Index =	$FFFFEED2 ; into Sonic_Pos_Record_Buf and Sonic_Stat_Record_Buf
Tails_Pos_Record_Index =	$FFFFEED6 ; into Tails_Pos_Record_Buf
Camera_Y_pos_bias =		$FFFFEED8 ; added to y position for lookup/lookdown, $60 is center
Camera_Y_pos_bias_2P =		$FFFFEEDA ; for Tails
Dynamic_Resize_Routine =	$FFFFEEDF
Tails_Min_X_pos =		$FFFFEEF8
Tails_Max_X_pos =		$FFFFEEFA
Tails_Max_Y_pos =		$FFFFEEFE

Underwater_palette_2 = 		$FFFFF000 ; not sure what it's used for but it's only used when there's water
Underwater_palette = 		$FFFFF080 ; main palette for underwater parts of the screen
Underwater_palette_line4 = 	$FFFFF0E0

Game_Mode =			$FFFFF600 ; 1 byte ; see GameModesArray (master level trigger, Mstr_Lvl_Trigger)
Ctrl_1_Logical =		$FFFFF602 ; 2 bytes
Ctrl_1_Held_Logical =		$FFFFF602 ; 1 byte
Ctrl_1_Press_Logical =		$FFFFF603 ; 1 byte
Ctrl_1 =			$FFFFF604 ; 2 bytes
Ctrl_1_Held =			$FFFFF604 ; 1 byte ; (pressed and held were switched around before)
Ctrl_1_Press =			$FFFFF605 ; 1 byte
Ctrl_2 =			$FFFFF606 ; 2 bytes
Ctrl_2_Held =			$FFFFF606 ; 1 byte
Ctrl_2_Press =			$FFFFF607 ; 1 byte
Demo_Time_left =		$FFFFF614 ; 2 bytes

Vscroll_Factor =		$FFFFF616
Hint_counter_reserve =		$FFFFF624 ; Must contain a VDP command word, preferably a write to register $0A. Executed every V-INT.
Delay_Time =			$FFFFF62A ; number of frames to delay the game
RNG_seed =			$FFFFF636 ; used for random number generation
Game_paused =			$FFFFF63A
DMA_data_thunk =		$FFFFF640 ; Used as a RAM holder for the final DMA command word. Data will NOT be preserved across V-INTs, so consider this space reserved.

Water_Level_1 =			$FFFFF646
Water_Level_2 =			$FFFFF648
Water_Level_3 =			$FFFFF64A
Water_routine =			$FFFFF64D
Water_move =			$FFFFF64E
Water_on =			$FFFFF64C ; is set based on Water_flag
New_Water_Level =		$FFFFF650
Water_change_speed =		$FFFFF652
Palette_frame_count =		$FFFFF65E

Ctrl_2_Logical =		$FFFFF66A ; 2 bytes
Ctrl_2_Held_Logical =		$FFFFF66A ; 1 byte
Ctrl_2_Press_Logical =		$FFFFF66B ; 1 byte
Sonic_Look_delay_counter = 	$FFFFF66C ; 2 bytes
Tails_Look_delay_counter = 	$FFFFF66E ; 2 bytes
Super_Sonic_frame_count =	$FFFFF670
Plc_Buffer =			$FFFFF680 ; Pattern load queue

Misc_Variables =		$FFFFF700

; extra variables for the second player (CPU) in 1-player mode
Tails_control_counter =		$FFFFF702 ; how long until the CPU takes control
Tails_respawn_counter =		$FFFFF704
Tails_CPU_routine =		$FFFFF708
Tails_CPU_target_x =		$FFFFF70A
Tails_CPU_target_y =		$FFFFF70C
Tails_interact_ID =		$FFFFF70E ; object ID of last object stood on

Level_started_flag =		$FFFFF711
CNZ_Bumper_routine =		$FFFFF71A
Dirty_flag =			$FFFFF72C ; if whole screen needs to redraw
Water_flag =			$FFFFF730 ; if the level has water or oil

Sonic_top_speed =		$FFFFF760
Sonic_acceleration =		$FFFFF762
Sonic_deceleration =		$FFFFF764
Obj_placement_routine =		$FFFFF76C
Obj_load_addr_0 =		$FFFFF770
Obj_load_addr_1 =		$FFFFF774
Obj_load_addr_2 =		$FFFFF778
Obj_load_addr_3 =		$FFFFF77C
Demo_button_index =		$FFFFF790 ; index into button press demo data, for player 1
Demo_press_counter =		$FFFFF792 ; frames remaining until next button press, for player 1
Demo_button_index_2P =		$FFFFF732 ; index into button press demo data, for player 2
Demo_press_counter_2P =		$FFFFF734 ; frames remaining until next button press, for player 2
Collision_addr =		$FFFFF796
Current_Boss_ID =		$FFFFF7AA
Control_Locked =		$FFFFF7CC
Chain_Bonus_counter =		$FFFFF7D0 ; counts up when you destroy things that give points, resets when you touch the ground
Bonus_Countdown_1 =		$FFFFF7D2 ; level results time bonus or special stage sonic ring bonus
Bonus_Countdown_2 =		$FFFFF7D4 ; level results ring bonus or special stage tails ring bonus
Update_Bonus_score =		$FFFFF7D6
Camera_X_pos_coarse =		$FFFFF7DA ; (Camera_X_pos - 128) / 256

Sprite_Table =			$FFFFF800 ; Sprite attribute table buffer

Normal_palette =		$FFFFFB00
Normal_palette_line2 =		$FFFFFB20
Normal_palette_line3 =		$FFFFFB40
Normal_palette_line4 =		$FFFFFB60
Second_palette =		$FFFFFB80
Second_palette_line2 =		$FFFFFBA0
Second_palette_line3 =		$FFFFFBC0
Second_palette_line4 =		$FFFFFBE0

Object_Respawn_Table =		$FFFFFC00
System_Stack =			$FFFFFE00
Level_Inactive_flag = 		$FFFFFE02 ; (2 bytes)
Timer_frames =			$FFFFFE04 ; (2 bytes)
Debug_object =			$FFFFFE06
Debug_placement_mode =		$FFFFFE08
Current_ZoneAndAct =		$FFFFFE10 ; 2 bytes
Current_Zone =			$FFFFFE10 ; 1 byte
Current_Act =			$FFFFFE11 ; 1 byte
Life_count =			$FFFFFE12
Current_Special_Stage =		$FFFFFE16
Continue_count =		$FFFFFE18
Super_Sonic_flag =		$FFFFFE19
Time_Over_flag =		$FFFFFE1A
Extra_life_flags =		$FFFFFE1B

; If set, the respective HUD element will be updated.
Update_HUD_lives =		$FFFFFE1C
Update_HUD_rings =		$FFFFFE1D
Update_HUD_timer =		$FFFFFE1E
Update_HUD_score =		$FFFFFE1F

Ring_count =			$FFFFFE20 ; 2 bytes
Timer =				$FFFFFE22 ; 4 bytes
Timer_minute_word =		$FFFFFE22 ; 2 bytes
Timer_minute =			$FFFFFE23 ; 1 byte
Timer_second =			$FFFFFE24 ; 1 byte
Timer_centisecond =		$FFFFFE25 ; 1 byte
Score =				$FFFFFE26 ; 4 bytes
Last_star_pole_hit =		$FFFFFE30 ; 1 byte -- max activated starpole ID in this act

Saved_Last_star_pole_hit =	$FFFFFE31
Saved_x_pos =			$FFFFFE32
Saved_y_pos =			$FFFFFE34
Saved_Ring_count =		$FFFFFE36
Saved_Timer =			$FFFFFE38
Saved_art_tile =		$FFFFFE3C
Saved_layer =			$FFFFFE3E
Saved_Camera_X_pos =		$FFFFFE40
Saved_Camera_Y_pos =		$FFFFFE42
Saved_Water_Level =		$FFFFFE50
Saved_Water_routine =		$FFFFFE52
Saved_Water_move =		$FFFFFE53
Saved_Extra_life_flags =	$FFFFFE54
Saved_Extra_life_flags_2P =	$FFFFFE55
Saved_Camera_Max_Y_pos =	$FFFFFE56
Saved_Dynamic_Resize_Routine =	$FFFFFE58

Logspike_anim_counter =		$FFFFFEA0
Logspike_anim_frame =		$FFFFFEA1
Rings_anim_counter =		$FFFFFEA2
Rings_anim_frame =		$FFFFFEA3
Unknown_anim_counter =		$FFFFFEA4 ; I think this was $FFFFFEC4 in the alpha
Unknown_anim_frame =		$FFFFFEA5
Ring_spill_anim_counter =	$FFFFFEA6 ; scattered rings
Ring_spill_anim_frame =		$FFFFFEA7
Ring_spill_anim_accum =		$FFFFFEA8

; values for the second player (some of these only apply to 2-player games)
Tails_top_speed =		$FFFFFEC0 ; Tails_max_vel
Tails_acceleration =		$FFFFFEC2
Tails_deceleration =		$FFFFFEC4
Life_count_2P =			$FFFFFEC6
Extra_life_flags_2P =		$FFFFFEC7
Update_HUD_lives_2P =		$FFFFFEC8
Update_HUD_rings_2P =		$FFFFFEC9
Update_HUD_timer_2P =		$FFFFFECA
Update_HUD_score_2P =		$FFFFFECB ; mostly unused
Time_Over_flag_2P =		$FFFFFECC
Ring_count_2P =			$FFFFFED0
Timer_2P =			$FFFFFED2 ; 4 bytes
Timer_minute_word_2P =		$FFFFFED2 ; 2 bytes
Timer_minute_2P =		$FFFFFED3 ; 1 byte
Timer_second_2P =		$FFFFFED4 ; 1 byte
Timer_centisecond_2P =		$FFFFFED5 ; 1 byte
Score_2P =			$FFFFFED6
Last_star_pole_hit_2P =		$FFFFFEE0

Saved_Last_star_pole_hit_2P =	$FFFFFEE1
Saved_x_pos_2P =		$FFFFFEE2
Saved_y_pos_2P =		$FFFFFEE4
Saved_Ring_count_2P =		$FFFFFEE6
Saved_Timer_2P =		$FFFFFEE8
Saved_art_tile_2P =		$FFFFFEEC
Saved_layer_2P =		$FFFFFEEE

Loser_Time_Left =		$FFFFFEF8
Results_Screen_2P =		$FFFFFF10 ; 0 = act, 1 = zone, 2 = game, 3 = SS, 4 = SS all
Results_Data_2P =		$FFFFFF20 ; $18 bytes
EHZ_Results_2P =		$FFFFFF20 ; 6 bytes
MCZ_Results_2P =		$FFFFFF26 ; 6 bytes
CNZ_Results_2P =		$FFFFFF2C ; 6 bytes
SS_Results_2P =			$FFFFFF32 ; 6 bytes
SS_Total_Won =			$FFFFFF38 ; 2 bytes (player 1 then player 2)
Perfect_rings_left =		$FFFFFF40
Player_mode =			$FFFFFF70 ; 0 = Sonic and Tails, 1 = Sonic, 2 = Tails
Player_option =			$FFFFFF72 ; 0 = Sonic and Tails, 1 = Sonic, 2 = Tails

Two_player_items =		$FFFFFF74
Level_select_zone =		$FFFFFF82
Sound_test_sound =		$FFFFFF84
Title_screen_option =		$FFFFFF86
Current_Zone_2P =		$FFFFFF88
Current_Act_2P =		$FFFFFF89
Two_player_mode_copy =		$FFFFFF8A
Options_menu_box =		$FFFFFF8C
Level_Music =			$FFFFFF90
Game_Over_2P =			$FFFFFF98
Got_Emerald =			$FFFFFFB0
Emerald_count =			$FFFFFFB1
Got_Emeralds_array =		$FFFFFFB2 ; 7 bytes
Next_Extra_life_score =		$FFFFFFC0
Next_Extra_life_score_2P =	$FFFFFFC4
Level_Has_Signpost =		$FFFFFFC8 ; 1 byte ; 1 = signpost, 0 = boss or nothing
Level_select_flag =		$FFFFFFD0
Correct_cheat_entries =		$FFFFFFD4
Correct_cheat_entries_2 =	$FFFFFFD6 ; for 14 continues or 7 emeralds codes
Two_player_mode =		$FFFFFFD8 ; flag (0 for main game)

; Values in these variables are passed to the sound driver during V-INT.
; They use a playlist index, not a sound test index.
Music_to_play =			$FFFFFFE0
SFX_to_play =			$FFFFFFE1 ; normal
SFX_to_play_2 =			$FFFFFFE2 ; alternating stereo
Music_to_play_2 =		$FFFFFFE4 ; alternate (higher priority?) slot

Demo_mode_flag =		$FFFFFFF0 ; 1 if a demo is playing (2 bytes)
Demo_number =			$FFFFFFF2 ; which demo will play next (2 bytes)
Graphics_Flags =		$FFFFFFF8 ; misc. bitfield
Checksum_fourcc =		$FFFFFFFC ; (4 bytes)

; ---------------------------------------------------------------------------
; VDP addressses
VDP_data_port =			$C00000 ; (8=r/w, 16=r/w)
VDP_control_port =		$C00004 ; (8=r/w, 16=r/w)

; ---------------------------------------------------------------------------
; Z80 addresses
Z80_RAM =			$A00000 ; start of Z80 RAM
Z80_RAM_End =			$A02000 ; end of non-reserved Z80 RAM
Z80_Version =			$A10001
Z80_Port_1_Data =		$A10002
Z80_Port_1_Control =		$A10008
Z80_Port_2_Control =		$A1000A
Z80_Expansion_Control =		$A1000C
Z80_Bus_Request =		$A11100
Z80_Reset =			$A11200

Security_Addr =			$A14000	
