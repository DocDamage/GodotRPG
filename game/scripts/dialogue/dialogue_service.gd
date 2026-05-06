class_name DialogueService
extends RefCounted

const PRONOUN_FORMS := {
	"they/them": {"they": "their", "them": "them", "subject": "they"},
	"she/her": {"they": "her", "them": "her", "subject": "she"},
	"he/him": {"they": "his", "them": "him", "subject": "he"},
}

func interpolate(line: String, profile: Dictionary) -> String:
	var pronouns: Dictionary = PRONOUN_FORMS.get(profile.get("pronouns", "they/them"), PRONOUN_FORMS["they/them"])
	return line.replace("{player_name}", profile.get("name", "Hero")) \
		.replace("{they}", pronouns.they) \
		.replace("{them}", pronouns.them) \
		.replace("{subject_pronoun}", pronouns.subject)

func prepare_lines(dialogue: Dictionary, profile: Dictionary) -> Array[String]:
	var prepared: Array[String] = []
	for line in dialogue.get("lines", []):
		prepared.append(interpolate(line, profile))
	return prepared
