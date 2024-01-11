class_name DCUtils
extends Object


const ActionNode = "DCActionNode"
const DialogueNode = "DCDialogueNode"
const EnableTextNode = "DCEnableTextNode"
const HideTextNode = "DCHideTextNode"
const NoteNode = "DCNoteNode"
const RerouteNode = "DCRerouteNode"
const RerouteTextNode = "DCRerouteTextNode"
const SetTextNode = "DCSetTextNode"
const StartNode = "DCStartNode"
const TextNode = "DCTextNode"
const CharacterNode = "DCCharacterNode"

const version = [0, 1]


static func GenerateID(ids, start_value: int) -> int:
	var new_id: int = start_value

	while true:
		if new_id not in ids:
			return new_id
		else:
			new_id += 1
		
	return -1
