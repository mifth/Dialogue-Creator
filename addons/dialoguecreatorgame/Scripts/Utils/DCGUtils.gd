class_name DCGUtils
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

const dialogue_nodes_types = [ActionNode, DialogueNode]
const live_nodes_types = [ActionNode, DialogueNode, SetTextNode]


static func GenerateID(ids, start_value: int) -> int:
	var new_id: int = start_value

	while true:
		if new_id not in ids:
			return new_id
		else:
			new_id += 1
		
	return -1


static func remove_children(parent: Node):
	var nodes_range = range(parent.get_children().size() -1, -1, -1)
	for i in nodes_range:
		var node = parent.get_children()[i]
		parent.remove_child(node)
		node.queue_free()
