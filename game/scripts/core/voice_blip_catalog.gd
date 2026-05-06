class_name VoiceBlipCatalog
extends RefCounted

const DEFAULT_VOICE_ID := "soft_synthetic"

const VOICE_EVENTS := {
	"soft_synthetic": "voice_sev_soft_synthetic",
	"warm_human": "voice_sev_warm_human",
	"low_quiet": "voice_sev_low_quiet",
	"sharp_clear": "voice_sev_sharp_clear",
}

const SPEAKER_EVENTS := {
	"CURATOR": "voice_curator",
	"MIRA": "voice_mira",
	"TOLL": "voice_toll",
}

func event_for_id(voice_id: String) -> String:
	return VOICE_EVENTS.get(voice_id, VOICE_EVENTS[DEFAULT_VOICE_ID])

func event_for_speaker(speaker: String) -> String:
	return SPEAKER_EVENTS.get(speaker.to_upper(), "")
