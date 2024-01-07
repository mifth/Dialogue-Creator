class_name DCParse
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


static func CreateNodesArrays(nodes_js: Dictionary):
	nodes_js[ActionNode] = []
	nodes_js[DialogueNode] = []
	nodes_js[EnableTextNode] = []
	nodes_js[HideTextNode] = []
	nodes_js[NoteNode] = []
	nodes_js[RerouteNode] = []
	nodes_js[RerouteTextNode] = []
	nodes_js[SetTextNode] = []
	nodes_js[StartNode] = []
	nodes_js[TextNode] = []


static func SaveJS(graph: GraphEdit):
	var main_js = {}
	var nodes_js = {}
	CreateNodesArrays(nodes_js)
	var conns_js = []

	main_js["Nodes"] = nodes_js
	main_js["Connections"] = conns_js

	for node in graph.get_children():
		if is_instance_of(node, DCActionNode):
			node.GetNodeParamsJS()
		elif is_instance_of(node, DCDialogueNode):
			node.GetNodeParamsJS()
