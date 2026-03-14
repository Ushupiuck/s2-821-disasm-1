SndCB_Wall_Smash_Header:
	smpsHeaderStartSong 2
	smpsHeaderVoice     SndAC_Hit_Boss_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $02

	smpsHeaderSFXChannel cFM5, SndCB_Wall_Smash_FM5,	$00, $00
	smpsHeaderSFXChannel cPSG3, SndCB_Wall_Smash_PSG3,	$00, $00

; FM5 Data
SndCB_Wall_Smash_FM5:
	smpsSetvoice        $00
	smpsModSet          $03, $01, $20, $04

SndCB_Wall_Smash_Loop00:
	dc.b	nC0, $18
	smpsAlterVol        $0A
	smpsLoop            $00, $06, SndCB_Wall_Smash_Loop00
	smpsStop

; PSG3 Data
SndCB_Wall_Smash_PSG3:
	smpsModSet          $01, $01, $0F, $05
	smpsPSGform         $E7

SndCB_Wall_Smash_Loop01:
	dc.b	nB3, $18, smpsNoAttack
	smpsPSGAlterVol     $03
	smpsLoop            $00, $05, SndCB_Wall_Smash_Loop01
	smpsStop