SndC2_Drown_Warning_Header:
	smpsHeaderStartSong 2, 1
	smpsHeaderVoice     SndBF_Get_Continue_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cFM5, SndC2_Drown_Warning_FM5,	$0C, $08

; FM5 Data
SndC2_Drown_Warning_FM5:
	smpsSetvoice        $00
	dc.b	nA4, $08, nA4, $25
	smpsStop