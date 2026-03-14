SndB9_Collapse_Header:
	smpsHeaderStartSong 2
	smpsHeaderVoice     SndAC_Hit_Boss_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $04

	smpsHeaderSFXChannel cFM3, SndB9_Collapse_FM3,	$10, $00
	smpsHeaderSFXChannel cFM4, SndB9_Collapse_FM4,	$00, $00
	smpsHeaderSFXChannel cFM5, SndB9_Collapse_FM5,	$10, $00
	smpsHeaderSFXChannel cPSG3, SndB9_Collapse_PSG3,	$00, $00

; FM3 Data
SndB9_Collapse_FM3:
	smpsPan             panRight, $00
	dc.b	nRst, $02
	smpsJump            SndB9_Collapse_FM4

; FM5 Data
SndB9_Collapse_FM5:
	smpsPan             panLeft, $00
	dc.b	nRst, $01

; FM4 Data
SndB9_Collapse_FM4:
	smpsSetvoice        $00
	smpsModSet          $03, $01, $20, $04

SndB9_Collapse_Loop00:
	dc.b	nC0, $18
	smpsAlterVol        $0A
	smpsLoop            $00, $06, SndB9_Collapse_Loop00
	smpsStop

; PSG3 Data
SndB9_Collapse_PSG3:
	smpsModSet          $01, $01, $0F, $05
	smpsPSGform         $E7

SndB9_Collapse_Loop01:
	dc.b	nB3, $18, smpsNoAttack
	smpsPSGAlterVol     $03
	smpsLoop            $00, $05, SndB9_Collapse_Loop01
	smpsStop