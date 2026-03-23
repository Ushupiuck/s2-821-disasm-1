; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Equates section - Names for variables.

; ---------------------------------------------------------------------------
; size variables - you'll get an informational error if you need to change these...
; they are all in units of bytes
Size_of_DAC_samples =		$3000
Size_of_SEGA_sound =		$6174
	if FixBugs
; To be on the safe side, we'll use a larger guess size.
Size_of_Snd_driver_guess =	$F00 ; approximate post-compressed size of the Z80 sound driver
	else
Size_of_Snd_driver_guess =	$E7E ; approximate post-compressed size of the Z80 sound driver
	endif

; ---------------------------------------------------------------------------
; Object Status Table offsets (for everything between Object_RAM and Primary_Collision)
; ---------------------------------------------------------------------------
; universally followed object conventions:
id =			  0 ; object ID (if you change this, change insn1op and insn2op in s2.macrosetup.asm, if you still use them)
render_flags =		  1 ; bitfield ; bit 7 = onscreen flag, bit 0 = x mirror, bit 1 = y mirror, bit 2 = coordinate system, bit 6 = render subobjects
art_tile =		  2 ; and 3 ; start of sprite's art
mappings =		  4 ; and 5 and 6 and 7
x_pos =			  8 ; and 9 ... some objects use $A and $B as well when extra precision is required (see ObjectMove) ... for screen-space objects this is called x_pixel instead
x_sub =			 $A ; and $B
y_pos =			 $C ; and $D ... some objects use $E and $F as well when extra precision is required ... screen-space objects use y_pixel instead
y_sub =			 $E ; and $F
priority =		$18 ; 0 = front
width_pixels =		$19
mapping_frame =		$1A
; ---------------------------------------------------------------------------
; conventions followed by most objects:
x_vel =			$10 ; and $11 ; horizontal velocity
y_vel =			$12 ; and $13 ; vertical velocity
y_radius =		$16 ; collision height / 2
x_radius =		$17 ; collision width / 2
anim_frame =		$1B
anim =			$1C
prev_anim =		$1D
anim_frame_duration =	$1E
status =		$22 ; note: exact meaning depends on the object... for Sonic/Tails: bit 0: left-facing. bit 1: in-air. bit 2: spinning. bit 3: on-object. bit 4: roll-jumping. bit 5: pushing. bit 6: underwater.
routine =		$24
routine_secondary =	$25
angle =			$26 ; angle about the z axis (360 degrees = 256)
; ---------------------------------------------------------------------------
; conventions followed by many objects but NOT Sonic/Tails:
collision_flags =	$20
collision_property =	$21
respawn_index =		$23
subtype =		$28
; ---------------------------------------------------------------------------
; conventions specific to Sonic/Tails (Obj01, Obj02, and ObjDB):
; note: $1F, $20, and $21 are unused and available (however, $1F is cleared by loc_A53A and ObjB2_Landed_on_plane)
inertia =		$14 ; and $15 ; directionless representation of speed... not updated in the air
flip_angle =		$27 ; angle about the x axis (360 degrees = 256) (twist/tumble)
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
pinball_mode =		spindash_flag
spindash_counter =	$3A ; and $3B
restart_countdown =	spindash_counter; and 1+spindash_counter
jumping =		$3C
interact =		$3D ; RAM address of the last object Sonic stood on, minus $FFFFB000 and divided by $40
top_solid_bit =		$3E ; the bit to check for top solidity (either $C or $E)
lrb_solid_bit =		$3F ; the bit to check for left/right/bottom solidity (either $D or $F)
; ---------------------------------------------------------------------------
; conventions followed by several objects but NOT Sonic/Tails:
y_pixel =		2+x_pos ; and 3+x_pos ; y coordinate for objects using screen-space coordinate system
x_pixel =		x_pos ; and 1+x_pos ; x coordinate for objects using screen-space coordinate system
parent =		objoff_3E ; and $3F ; address of object that owns or spawned this one, if applicable
; TODO: $2C is often parent instead (see LoadChildObject); consider defining parent2 = $2C and changing some objoff_2Cs to that
; ---------------------------------------------------------------------------
; conventions followed by some/most bosses:
boss_subtype		= objoff_A
boss_invulnerable_time	= objoff_14
boss_sine_count		= mapping_frame
boss_routine		= angle
boss_defeated		= objoff_2C
boss_hitcount2		= objoff_32
boss_hurt_sonic		= objoff_38	; flag set by collision response routine when Sonic has just been hurt (by boss?)
; ---------------------------------------------------------------------------
; when childsprites are activated (i.e. bit #6 of render_flags set)
next_subspr		= 6
mainspr_mapframe	= objoff_B
mainspr_width		= objoff_E
mainspr_childsprites	= objoff_F	; amount of child sprites
mainspr_height		= objoff_14
subspr_data		= $10
sub2_x_pos		= subspr_data+next_subspr*0+0	;x_vel
sub2_y_pos		= subspr_data+next_subspr*0+2	;y_vel
sub2_mapframe		= subspr_data+next_subspr*0+5
sub3_x_pos		= subspr_data+next_subspr*1+0	;y_radius
sub3_y_pos		= subspr_data+next_subspr*1+2	;priority
sub3_mapframe		= subspr_data+next_subspr*1+5	;anim_frame
sub4_x_pos		= subspr_data+next_subspr*2+0	;anim
sub4_y_pos		= subspr_data+next_subspr*2+2	;anim_frame_duration
sub4_mapframe		= subspr_data+next_subspr*2+5	;collision_property
sub5_x_pos		= subspr_data+next_subspr*3+0	;status
sub5_y_pos		= subspr_data+next_subspr*3+2	;routine
sub5_mapframe		= subspr_data+next_subspr*3+5
sub6_x_pos		= subspr_data+next_subspr*4+0	;subtype
sub6_y_pos		= subspr_data+next_subspr*4+2
sub6_mapframe		= subspr_data+next_subspr*4+5
sub7_x_pos		= subspr_data+next_subspr*5+0
sub7_y_pos		= subspr_data+next_subspr*5+2
sub7_mapframe		= subspr_data+next_subspr*5+5
sub8_x_pos		= subspr_data+next_subspr*6+0
sub8_y_pos		= subspr_data+next_subspr*6+2
sub8_mapframe		= subspr_data+next_subspr*6+5
sub9_x_pos		= subspr_data+next_subspr*7+0
sub9_y_pos		= subspr_data+next_subspr*7+2
sub9_mapframe		= subspr_data+next_subspr*7+5
; ---------------------------------------------------------------------------
; unknown or inconsistently used offsets that are not applicable to Sonic/Tails:
; (provided because rearrangement of the above values sometimes requires making space in here too)
objoff_A =		x_sub+0 ; note: x_pos can be 4 bytes, but sometimes the last 2 bytes of x_pos are used for other unrelated things
objoff_B =		x_sub+1 ; unused
objoff_E =		y_sub+0	; unused
objoff_F =		y_sub+1 ; unused
objoff_10 =		x_vel
objoff_14 =		inertia+0
objoff_15 =		inertia+1
objoff_1F =		anim_frame_duration+1
objoff_27 =		$27
objoff_28 =		subtype ; overlaps subtype, but a few objects use it for other things anyway
 enum				objoff_29=$29,objoff_2A=$2A,objoff_2B=$2B,objoff_2C=$2C,objoff_2D=$2D,objoff_2E=$2E,objoff_2F=$2F
 enum objoff_30=$30,objoff_31=$31,objoff_32=$32,objoff_33=$33,objoff_34=$34,objoff_35=$35,objoff_36=$36,objoff_37=$37
 enum objoff_38=$38,objoff_39=$39,objoff_3A=$3A,objoff_3B=$3B,objoff_3C=$3C,objoff_3D=$3D,objoff_3E=$3E,objoff_3F=$3F

; ---------------------------------------------------------------------------
; property of all objects:
object_size_bits =	6
object_size =		1<<object_size_bits ; the size of an object
next_object =		object_size

; ---------------------------------------------------------------------------
; Controller Buttons
;
; Buttons bit numbers
button_up:			EQU	0
button_down:			EQU	1
button_left:			EQU	2
button_right:			EQU	3
button_B:			EQU	4
button_C:			EQU	5
button_A:			EQU	6
button_start:			EQU	7
; Buttons masks (1 << x == pow(2, x))
button_up_mask:			EQU	1<<button_up	; $01
button_down_mask:		EQU	1<<button_down	; $02
button_left_mask:		EQU	1<<button_left	; $04
button_right_mask:		EQU	1<<button_right	; $08
button_B_mask:			EQU	1<<button_B	; $10
button_C_mask:			EQU	1<<button_C	; $20
button_A_mask:			EQU	1<<button_A	; $40
button_start_mask:		EQU	1<<button_start	; $80

; ---------------------------------------------------------------------------
; some variables and functions to help define those constants (redefined before a new set of IDs)
offset :=	0		; this is the start of the pointer table
ptrsize :=	1		; this is the size of a pointer (should be 1 if the ID is a multiple of the actual size)
idstart :=	0		; value to add to all IDs

; function using these variables
id function ptr,((ptr-offset)/ptrsize+idstart)

; Music IDs
offset :=	zMasterPlaylist
ptrsize :=	1
idstart :=	$81
; $80 is reserved for silence, so if you make idstart $80 or less,
; you may need to insert a dummy zMusIDPtr in the $80 slot

MusID__First = idstart
MusID_2PResults =		id(zMusIDPtr_2PResults)
MusID_GHZ =		id(zMusIDPtr_GHZ)
MusID_DHZ2P =		id(zMusIDPtr_DHZ2P)
MusID_OOZ2 =		id(zMusIDPtr_OOZ2)
MusID_MTZ =		id(zMusIDPtr_MTZ)
MusID_HTZ =		id(zMusIDPtr_HTZ)
MusID_NGHZ =		id(zMusIDPtr_NGHZ)
MusID_OOZ =		id(zMusIDPtr_OOZ)
MusID_CNZ =		id(zMusIDPtr_CNZ)
MusID_DEZ =	id(zMusIDPtr_DEZ)
MusID_DHZ =	id(zMusIDPtr_DHZ)
MusID_GHZ2P =	id(zMusIDPtr_GHZ2P)
MusID_SCZ =		id(zMusIDPtr_SCZ)
MusID_CPZ =		id(zMusIDPtr_CPZ)
MusID_SFZ =		id(zMusIDPtr_SFZ)
MusID_HPZ =		id(zMusIDPtr_HPZ)
MusID_LevelSel =		id(zMusIDPtr_LevelSel)
MusID_SpecStg =		id(zMusIDPtr_SpecStg)
MusID_Boss =		id(zMusIDPtr_Boss)
MusID_FinalBoss =		id(zMusIDPtr_FinalBoss)
MusID_Ending =		id(zMusIDPtr_Ending)
MusID_SuperSonic =		id(zMusIDPtr_SuperSonic)
MusID_Invinc =		id(zMusIDPtr_Invinc)
MusID_ExtraLife =	id(zMusIDPtr_ExtraLife)
MusID_Title =		id(zMusIDPtr_Title)
MusID_ActClear =	id(zMusIDPtr_ActClear)
MusID_GameOver =	id(zMusIDPtr_GameOver)
MusID_Continue =	id(zMusIDPtr_Continue)
MusID_Emerald =		id(zMusIDPtr_Emerald)
MusID_HPZDup =	id(zMusIDPtr_HPZDup)
MusID__End =		id(zMusIDPtr__End)

; Leftover Music IDs from Simon Wai
MusID_Boss_Prev =	$8E

; Whenever the music references a slot that was its placement in Sonic 1
S1MusID_LZ =		$82
S1MusID_Invinc =	$87
S1MusID_ExtraLife =	$88
S1MusID_SpecStg =	$89
S1MusID_Boss =		$8C
S1MusID_ActClear =	$8E
S1MusID_Emerald =	$93
S1SndID_Waterfall =	$D0
S1MusID_Stop =		$E0

; Sound IDs
offset :=	SoundIndex
ptrsize :=	2
idstart :=	$A0
; $80 is reserved for silence, so if you make idstart $80 or less,
; you may need to insert a dummy SndPtr in the $80 slot

SndID__First = idstart
SndID_Jump =		id(SndPtr_Jump)			; A0
SndID_Checkpoint =	id(SndPtr_Checkpoint)		; A1
SndID_SpikeSwitch =	id(SndPtr_SpikeSwitch)		; A2
SndID_Hurt =		id(SndPtr_Hurt)			; A3
SndID_Skidding =	id(SndPtr_Skidding)		; A4
SndID_MissileDissolve =	id(SndPtr_MissileDissolve)	; A5
SndID_HurtBySpikes =	id(SndPtr_HurtBySpikes)		; A6
SndID_PushBlock =	id(SndPtr_PushBlock)		; A7
SndID_SSGoal =		id(SndPtr_SSGoal)		; A8
SndID_Bwoop =		id(SndPtr_Bwoop)		; A9
SndID_Splash =		id(SndPtr_Splash)		; AA
SndID_Swish =		id(SndPtr_Swish)		; AB
SndID_BossHit =		id(SndPtr_BossHit)		; AC
SndID_InhalingBubble =	id(SndPtr_InhalingBubble)	; AD
SndID_ArrowFiring =	id(SndPtr_ArrowFiring)		; AE
SndID_LavaBall =	id(SndPtr_LavaBall)		; AE
SndID_Shield =		id(SndPtr_Shield)		; AF
SndID_Saw =		id(SndPtr_Saw)			; B0
SndID_Electric =	id(SndPtr_Electric)		; B1
SndID_Drown =		id(SndPtr_Drown)		; B2
SndID_FireBurn =	id(SndPtr_FireBurn)		; B3
SndID_Bumper =		id(SndPtr_Bumper)		; B4
SndID_Ring =		id(SndPtr_Ring)			; B5
SndID_RingRight =	id(SndPtr_RingRight)		; B5
SndID_SpikesMove =	id(SndPtr_SpikesMove)		; B6
SndID_Rumbling =	id(SndPtr_Rumbling)		; B7
SndID_Smash =		id(SndPtr_Smash)		; B9
SndID_SSGlass =		id(SndPtr_SSGlass)		; BA
SndID_DoorSlam =	id(SndPtr_DoorSlam)		; BB
SndID_SpindashRelease =	id(SndPtr_SpindashRelease)	; BC
SndID_Hammer =		id(SndPtr_Hammer)		; BD
SndID_Roll =		id(SndPtr_Roll)			; BE
SndID_ContinueJingle =	id(SndPtr_ContinueJingle)	; BF
SndID_BasaranFlap =	id(SndPtr_BasaranFlap)		; C0
SndID_Explosion =	id(SndPtr_Explosion)		; C1
SndID_WaterWarning =	id(SndPtr_WaterWarning)		; C2
SndID_EnterGiantRing =	id(SndPtr_EnterGiantRing)	; C3
SndID_BossExplosion =	id(SndPtr_BossExplosion)	; C4
SndID_TallyEnd =	id(SndPtr_TallyEnd)		; C5
SndID_RingSpill =	id(SndPtr_RingSpill)		; C6
SndID_Flamethrower =	id(SndPtr_Flamethrower)		; C8
SndID_Bonus =		id(SndPtr_Bonus)		; C9
SndID_SpecStageEntry =	id(SndPtr_SpecStageEntry)	; CA
SndID_SlowSmash =	id(SndPtr_SlowSmash)		; CB
SndID_Spring =		id(SndPtr_Spring)		; CC
SndID_Blip =		id(SndPtr_Blip)			; CD
SndID_RingLeft =	id(SndPtr_RingLeft)		; CE
SndID_Signpost =	id(SndPtr_Signpost)		; CF
SndID_CNZBossZap =	id(SndPtr_CNZBossZap)		; D0
SndID_Signpost2P =	id(SndPtr_Signpost2P)		; D3
SndID_OOZLidPop =	id(SndPtr_OOZLidPop)		; D4
SndID_SlidingSpike =	id(SndPtr_SlidingSpike)		; D5
SndID_CNZElevator =	id(SndPtr_CNZElevator)		; D6
SndID_PlatformKnock =	id(SndPtr_PlatformKnock)	; D7
SndID_BonusBumper =	id(SndPtr_BonusBumper)		; D8
SndID_LargeBumper =	id(SndPtr_LargeBumper)		; D9
SndID_Gloop =		id(SndPtr_Gloop)		; DA
SndID_PreArrowFiring =	id(SndPtr_PreArrowFiring)	; DB
SndID_Fire =		id(SndPtr_Fire)			; DC
SndID_ArrowStick =	id(SndPtr_ArrowStick)		; DD
SndID_Helicopter =	id(SndPtr_Helicopter)		; DE
SndID_SuperTransform =	id(SndPtr_SuperTransform)	; DF
SndID_SpindashRev =	id(SndPtr_SpindashRev)		; E0
SndID__End =		id(SndPtr__End)			; EA

; Sound command IDs
offset :=	zCommandIndex
ptrsize :=	4
idstart :=	$F8

CmdID__First = idstart
MusID_StopSFX =		id(CmdPtr_StopSFX)	; F8
MusID_FadeOut =		id(CmdPtr_FadeOut)	; F9
SndID_SegaSound =	id(CmdPtr_SegaSound)	; FA
MusID_SpeedUp =		id(CmdPtr_SpeedUp)	; FB
MusID_SlowDown =	id(CmdPtr_SlowDown)	; FC
MusID_Stop =		id(CmdPtr_Stop)		; FD
CmdID__End =		id(CmdPtr__End)		; FE

MusID_Pause =		$7E+$80			; FE
MusID_Unpause =		$7F+$80			; FF

; Constants

gm_SEGALogo					   equ $00
gm_TitleScreen				   equ $04
gm_DemoMode					   equ $08
gm_PlayMode					   equ $0C
gm_SpecialStage				   equ $10
gm_Continue					   equ $14

Obj_Id						   equ $0000
Obj_Flags					   equ $0001
Obj_Art_VRAM				   equ $0002
Obj_Map						   equ $0004
Obj_X						   equ $0008
Obj_Sub_Y					   equ $000A
Obj_Y						   equ $000C
Obj_Speed					   equ $0010
Obj_Speed_Y					   equ $0012
Obj_Inertia					   equ $0014
Obj_Height_2				   equ $0016
Obj_Width_2					   equ $0017
Obj_Priority				   equ $0018
Obj_Width					   equ $0019
Obj_Map_Id					   equ $001A
Obj_Ani_Frame				   equ $001B
Obj_Ani_Number				   equ $001C
Obj_Ani_Flag				   equ $001D
Obj_Ani_Time				   equ $001E
Obj_Ani_Time_2				   equ $001F
Obj_Col_Flags				   equ $0020
Obj_Col_Prop				   equ $0021
Obj_Status					   equ $0022
Obj_Respaw_Ref				   equ $0023
Obj_Routine					   equ $0024
Obj_Routine_2				   equ $0025
Obj_Angle					   equ $0026
Obj_Flip_Angle				   equ $0027
Obj_Subtype					   equ $0028
Obj_Timer					   equ $002A
Obj_Control_Var_00			   equ $002C
Obj_Control_Var_01			   equ $002D
Obj_Control_Var_02			   equ $002E
Obj_Control_Var_03			   equ $002F
Obj_Control_Var_04			   equ $0030
Obj_Control_Var_05			   equ $0031
Obj_Control_Var_06			   equ $0032
Obj_Control_Var_07			   equ $0033
Obj_Control_Var_08			   equ $0034
Obj_Control_Var_09			   equ $0035
Obj_Control_Var_0A			   equ $0036
Obj_Control_Var_0B			   equ $0037
Obj_Control_Var_0C			   equ $0038
Obj_Control_Var_0D			   equ $0039
Obj_Control_Var_0E			   equ $003A
Obj_Control_Var_0F			   equ $003B
Obj_Control_Var_10			   equ $003C
Obj_Control_Var_11			   equ $003D
Obj_Control_Var_12			   equ $003E
Obj_Control_Var_13			   equ $003F
Obj_Size					   equ $0040

Obj_Player_Flip_Flag		   equ $0029
Obj_Player_Status			   equ $002B
Obj_P_Flips_Remaining		   equ $002C
Obj_Player_Flip_Speed		   equ $002D
Obj_Player_Control			   equ $002E
Obj_P_Invunerblt_Time		   equ $0030
Obj_P_Invcbility_Time		   equ $0032
Obj_P_Spd_Shoes_Time		   equ $0034
Obj_Player_Next_Tilt		   equ $0036
Obj_Player_Tilt				   equ $0037
Obj_Player_St_Convex		   equ $0038
Obj_Player_Spdsh_Flag		   equ $0039
Obj_Player_Spdsh_Cnt		   equ $003A
Obj_Player_Jump				   equ $003C
Obj_Player_Last				   equ $003D
Obj_Player_Top_Solid		   equ $003E
Obj_Player_LRB_Solid		   equ $003F

Obj_Boss_Routine			   equ $000A
Obj_Boss_Ani_Map			   equ $000B
Obj_Ani_Boss_Cnt			   equ $000F
Obj_Ani_Boss_Frame			   equ $0015
Obj_Boss_Hit				   equ $0021
Obj_Ani_Boss_Routine		   equ $0026
Obj_Boss_Hit_2				   equ $0032

HTz_Robotnik_Pos_X			   equ $0010
HTz_Robotnik_Pos_Y			   equ $0012

NGHz_Robotnik_Pos_X			   equ $0010
NGHz_Robotnik_Pos_Y			   equ $0012
NGHz_Hammer_Pos_X			   equ $0016
NGHz_Hammer_Pos_Y			   equ $0018
NGHz_Ship_Boost_Pos_X		   equ $001C
NGHz_Ship_Boost_Pos_Y		   equ $001E

DHz_Front_Drill_Pos_X		   equ $0010
DHz_Front_Drill_Pos_Y		   equ $0012
DHz_Ship_Boost_Pos_X		   equ $0016
DHz_Ship_Boost_Pos_Y		   equ $0018
DHz_Robotnik_Pos_X			   equ $001C
DHz_Robotnik_Pos_Y			   equ $001E
DHz_Back_Drill_Pos_X		   equ $0022
DHz_Back_Drill_Pos_Y		   equ $0024

CNz_R_Catcher_Pos_X			   equ $0010
CNz_R_Catcher_Pos_Y			   equ $0012
CNz_Boss_Ship_Pos_X			   equ $0016
CNz_Boss_Ship_Pos_Y			   equ $0018
CNz_Robotnik_Pos_X			   equ $001C
CNz_Robotnik_Pos_Y			   equ $001E
CNz_L_Catcher_Pos_X			   equ $0022
CNz_L_Catcher_Pos_Y			   equ $0024
CNz_L_Catcher_Pos_Y_1		   equ $002E
CNz_R_Catcher_Fall_Y		   equ $0034
CNz_L_Catcher_Fall_Y		   equ $003A

Obj_Page_Size_2P			   equ $000C

; Z80

Z80_RAM_Start				   equ $00A00000

; I/O

IO_Hardware_Version			   equ $00A10001
IO_Joypad_Port_0			   equ $00A10003
IO_Port_0_Control			   equ $00A10008
IO_Port_1_Control			   equ $00A1000A
IO_Expansion_Control		   equ $00A1000C

; VDP

VDP_Data_Port				   equ $00C00000
VDP_Control_Port			   equ $00C00004

; ---------------------------------------------------------------------------
; I run the main 68k RAM addresses through this function
; to let them work in both 16-bit and 32-bit addressing modes.
ramaddr function x,-(-x)&$FFFFFFFF

; RAM

M68K_RAM_Start				   equ ramaddr($FFFF0000)

SS_Ram_Layout_Address		   equ M68K_RAM_Start+$4000

Level_Map_Buffer			   equ M68K_RAM_Start+$8000
Level_Map_Bg_Buffer			   equ Level_Map_Buffer+$0080

Blocks_Mem_Address			   equ M68K_RAM_Start+$9000

Obj_Memory_Address			   equ M68K_RAM_Start+$B000
Player_One					   equ Obj_Memory_Address
Player_One_Position_X		   equ Player_One+Obj_X
Player_One_Position_Y		   equ Player_One+Obj_Y
Player_Two					   equ Obj_Memory_Address+$0040
Player_Two_Position_X		   equ Player_Two+Obj_X
Player_Two_Position_Y		   equ Player_Two+Obj_Y
Title_Card_RAM_Obj_Data		   equ Obj_Memory_Address+$0080
HUD_RAM_Obj_Data			   equ Obj_Memory_Address+$0380
Level_Results_RAM_Obj_Data	   equ Obj_Memory_Address+$05C0

Obj_Start_Addr_2P			   equ M68K_RAM_Start+$BE00
Obj_Page_01_2P_Addr			   equ M68K_RAM_Start+$C100
Obj_Page_02_2P_Addr			   equ M68K_RAM_Start+$C400
Obj_Page_03_2P_Addr			   equ M68K_RAM_Start+$C700
Obj_Page_04_2P_Addr			   equ M68K_RAM_Start+$CA00
Obj_Page_05_2P_Addr			   equ M68K_RAM_Start+$CD00

Special_Stage_Memory_Address   equ M68K_RAM_Start+$D000

Primary_Colision_Data_Buffer   equ M68K_RAM_Start+$D000
Secundary_Colision_Data_Buffer equ M68K_RAM_Start+$D600

DMA_Buffer_List				   equ M68K_RAM_Start+$DC00
DMA_Buffer_List_End			   equ M68K_RAM_Start+$DCFC

Scroll_Buffer_Data			   equ M68K_RAM_Start+$E000
Camera_X					   equ M68K_RAM_Start+$EE00
Camera_Y					   equ M68K_RAM_Start+$EE04
Camera_X_x2					   equ M68K_RAM_Start+$EE08
Camera_Y_x4					   equ M68K_RAM_Start+$EE0C
Camera_Y_x4_Mod_10			   equ M68K_RAM_Start+$EE14
Camera_X_x8					   equ M68K_RAM_Start+$EE10
Camera_X_x4					   equ M68K_RAM_Start+$EE18
Camera_Y_x4_Mod_10_2		   equ M68K_RAM_Start+$EE1C
Camera_X_2					   equ M68K_RAM_Start+$EE20
Camera_Y_2					   equ M68K_RAM_Start+$EE24
Scroll_Flag_Array			   equ M68K_RAM_Start+$EE50
Scroll_Flag_Array_2			   equ M68K_RAM_Start+$EEA0
Horizontal_Scrolling		   equ M68K_RAM_Start+$EEB0
Vertical_Scrolling			   equ M68K_RAM_Start+$EEB2
Horizontal_Scrolling_Sub	   equ M68K_RAM_Start+$EEB4
Vertical_Scrolling_Sub		   equ M68K_RAM_Start+$EEB6
Sonic_Level_Limits_Min_X	   equ M68K_RAM_Start+$EEC8
Sonic_Level_Limits_Max_X	   equ M68K_RAM_Start+$EECA
Sonic_Level_Limits_Min_Y	   equ M68K_RAM_Start+$EECC
Sonic_Level_Limits_Max_Y	   equ M68K_RAM_Start+$EECE
Level_Scroll_Flag			   equ M68K_RAM_Start+$EEDC
Vertical_Scroll_Flag		   equ M68K_RAM_Start+$EEDE
Dyn_Resize_Routine			   equ M68K_RAM_Start+$EEDF
Miles_Level_Limits_Min_X	   equ M68K_RAM_Start+$EEF8
Miles_Level_Limits_Max_X	   equ M68K_RAM_Start+$EEFA
Miles_Level_Limits_Max_Y	   equ M68K_RAM_Start+$EEFE
Game_Mode					   equ M68K_RAM_Start+$F600
Control_Ports_Buffer_Data	   equ M68K_RAM_Start+$F604
Timer_Count_Down			   equ M68K_RAM_Start+$F614
Horizontal_Interrupt_Count	   equ M68K_RAM_Start+$F624
Scanlines_Count				   equ M68K_RAM_Start+$F625
VBlank_Index				   equ M68K_RAM_Start+$F62A
Pause_Status				   equ M68K_RAM_Start+$F63A
Water_Level					   equ M68K_RAM_Start+$F646
Water_Level_Change			   equ M68K_RAM_Start+$F648
Water_Level_New				   equ M68K_RAM_Start+$F64A
PLC_Buffer					   equ M68K_RAM_Start+$F680
Refresh_Level_Layout		   equ M68K_RAM_Start+$F720
Water_Level_Flag			   equ M68K_RAM_Start+$F730
Boss_Animate_Buffer			   equ M68K_RAM_Start+$F740
Boss_Move_Buffer			   equ M68K_RAM_Start+$F750
Sonic_Max_Speed				   equ M68K_RAM_Start+$F760
Sonic_Acceleration			   equ M68K_RAM_Start+$F762
Sonic_Deceleration			   equ M68K_RAM_Start+$F764
Current_Colision_Pointer	   equ M68K_RAM_Start+$F796
Boss_Defeated_Flag			   equ M68K_RAM_Start+$F7A7
Boss_Flag					   equ M68K_RAM_Start+$F7AA
Player_Status_Flag			   equ M68K_RAM_Start+$F7CA
Palette_Buffer				   equ M68K_RAM_Start+$FB00
Palette_Underwater_Buffer	   equ M68K_RAM_Start+$FB80
Exception_Index				   equ M68K_RAM_Start+$FC44
StackPointer				   equ M68K_RAM_Start+$FE00
Debug_Mode_Flag_Index		   equ M68K_RAM_Start+$FE08
Level_Id					   equ M68K_RAM_Start+$FE10
Act_Id						   equ M68K_RAM_Start+$FE11
Life_Count					   equ M68K_RAM_Start+$FE12
Special_Stage_Id			   equ M68K_RAM_Start+$FE16
Super_Sonic_Flag			   equ M68K_RAM_Start+$FE19
Ring_Life_Flag				   equ M68K_RAM_Start+$FE1B
HUD_Life_Refresh_Flag		   equ M68K_RAM_Start+$FE1C
HUD_Rings_Refresh_Flag		   equ M68K_RAM_Start+$FE1D
HUD_Timer_Refresh_Flag		   equ M68K_RAM_Start+$FE1E
HUD_Score_Refresh_Flag		   equ M68K_RAM_Start+$FE1F
Ring_Count					   equ M68K_RAM_Start+$FE20
Time_Count					   equ M68K_RAM_Start+$FE22
Time_Count_Minutes			   equ M68K_RAM_Start+$FE23
Time_Count_Seconds			   equ M68K_RAM_Start+$FE24
Time_Count_CentiSeconds		   equ M68K_RAM_Start+$FE25
Score_Count					   equ M68K_RAM_Start+$FE26
Shield_Flag					   equ M68K_RAM_Start+$FE2C
Invincibility_Flag			   equ M68K_RAM_Start+$FE2D
Hi_Speed_Flag				   equ M68K_RAM_Start+$FE2E
Saved_Level_Flag			   equ M68K_RAM_Start+$FE30
Emerald_Count				   equ M68K_RAM_Start+$FE57
Emerald_Collected_Flag_List	   equ M68K_RAM_Start+$FE58
Object_Frame_Buffer			   equ M68K_RAM_Start+$FEA0
Miles_Max_Speed				   equ M68K_RAM_Start+$FEC0
Miles_Acceleration			   equ M68K_RAM_Start+$FEC2
Miles_Deceleration			   equ M68K_RAM_Start+$FEC4
Two_Player_Flag				   equ M68K_RAM_Start+$FFD8
Sound_Buffer_Id				   equ M68K_RAM_Start+$FFE0
Auto_Control_Player_Flag	   equ M68K_RAM_Start+$FFF0
Hardware_Id					   equ M68K_RAM_Start+$FFF8
Debug_Mode_Active_Flag		   equ M68K_RAM_Start+$FFFA
Init_Flag					   equ M68K_RAM_Start+$FFFC

; CRAM
Color_RAM_Address			   equ $C0000000

; ---------------------------------------------------------------------------
; Clocks
Master_Clock	= 53693175
M68000_Clock	= Master_Clock/7
Z80_Clock		= Master_Clock/15
FM_Sample_Rate	= M68000_Clock/(6*6*4)
PSG_Sample_Rate = Z80_Clock/16

; ---------------------------------------------------------------------------
; VDP addressses
VDP_data_port =			$C00000 ; (8=r/w, 16=r/w)
VDP_control_port =		$C00004 ; (8=r/w, 16=r/w)
PSG_input =			$C00011

; ---------------------------------------------------------------------------
; Z80 addresses
Z80_RAM =			$A00000 ; start of Z80 RAM
Z80_RAM_End =			$A02000 ; end of non-reserved Z80 RAM
Z80_Bus_Request =		$A11100
Z80_Reset =			$A11200

Security_Addr =			$A14000

; ---------------------------------------------------------------------------
; I/O Area
HW_Version =			$A10001
HW_Port_1_Data =		$A10003
HW_Port_2_Data =		$A10005
HW_Expansion_Data =		$A10007
HW_Port_1_Control =		$A10009
HW_Port_2_Control =		$A1000B
HW_Expansion_Control =		$A1000D
HW_Port_1_TxData =		$A1000F
HW_Port_1_RxData =		$A10011
HW_Port_1_SCtrl =		$A10013
HW_Port_2_TxData =		$A10015
HW_Port_2_RxData =		$A10017
HW_Port_2_SCtrl =		$A10019
HW_Expansion_TxData =		$A1001B
HW_Expansion_RxData =		$A1001D
HW_Expansion_SCtrl =		$A1001F

; ---------------------------------------------------------------------------
; VRAM and tile art base addresses.
; VRAM Reserved regions.
VRAM_Plane_A_Name_Table				= $C000	; Extends until $CFFF
VRAM_Plane_B_Name_Table				= $E000	; Extends until $EFFF
VRAM_Plane_A_Name_Table_2P			= $A000	; Extends until $AFFF
VRAM_Plane_B_Name_Table_2P			= $8000	; Extends until $8FFF
VRAM_Plane_Window_Name_Table		= $A000 ; Extends until $FFFF
VRAM_Plane_Table_Size				= $1000	; 64 cells x 32 cells x 2 bytes per cell
VRAM_Sprite_Attribute_Table			= $F800	; Extends until $FA7F
VRAM_Sprite_Attribute_Table_Size	= $280	; 640 bytes
VRAM_Horiz_Scroll_Table				= $FC00	; Extends until $FF7F
VRAM_Horiz_Scroll_Table_Size		= $380	; 224 lines * 2 bytes per entry * 2 PNTs