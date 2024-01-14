class_name DCGraph
extends Control

@onready var _graph: GraphEdit = $VBoxContainer/DCGraphEdit

@onready var file_button: DCFileMenu = $VBoxContainer/MenuBar/HBoxContainer/FileButton
@onready var nodes_button: DCNodesMenu = $VBoxContainer/MenuBar/HBoxContainer/NodesButton

@onready var _file_dialogue = $SaveFileDialog


# Preload Nodes
const start_node_res := preload("res://addons/dialoguecreator/Assets/Nodes/DCStartNode.tscn")
const dialogue_node_res := preload("res://addons/dialoguecreator/Assets/Nodes/DCDialogueNode.tscn")
const enable_node_res := preload("res://addons/dialoguecreator/Assets/Nodes/DCEnableTextNode.tscn")
const hide_node_res := preload("res://addons/dialoguecreator/Assets/Nodes/DCHideTextNode.tscn")
const reroute_node_res := preload("res://addons/dialoguecreator/Assets/Nodes/DCRerouteNode.tscn")
const reroute_text_node_res := preload("res://addons/dialoguecreator/Assets/Nodes/DCRerouteTextNode.tscn")
const action_node_res := preload("res://addons/dialoguecreator/Assets/Nodes/DCActionNode.tscn")
const note_node_res := preload("res://addons/dialoguecreator/Assets/Nodes/DCNoteNode.tscn")
const settext_node_res := preload("res://addons/dialoguecreator/Assets/Nodes/DCSetTextNode.tscn")
const text_node_res := preload("res://addons/dialoguecreator/Assets/Nodes/DCTextNode.tscn")
const character_node_res := preload("res://addons/dialoguecreator/Assets/Nodes/DCCharacterNode.tscn")

const text_node_text_res := preload("res://addons/dialoguecreator/Assets/Nodes/DCDialogueNodeText.tscn")

const play_scene_res := preload("res://addons/dialoguecreator/Assets/PlayScene/PlayScene.tscn")


func _ready():
	file_button.NewFile.connect(self.NewScene)
	file_button.SaveFile.connect(self.SaveFileDialogue)
	file_button.LoadFile.connect(self.LoadFileDialogue)
	nodes_button.AddNode.connect(self.AddNode)

func ClearGraph():
	_graph.clear_connections()
	DCGUtils.remove_children(_graph)


func NewScene():
	ClearGraph()


func SaveFileDialogue():
	_file_dialogue.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	_file_dialogue.title = "Save To JSON"
	_file_dialogue.show()


func LoadFileDialogue():
	_file_dialogue.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	_file_dialogue.title = "Load JSON"
	_file_dialogue.show()


func _on_save_file_dialog_file_selected(path):
	if _file_dialogue.file_mode == FileDialog.FILE_MODE_SAVE_FILE:
		DCParse.SaveFileJS(_graph, path)
	else:
		ClearGraph()
		DCParse.LoadFileJS(_graph, path)


func AddNode(node_name: String):
	var node_res: Resource
	
	if node_name == "Start":
		node_res = start_node_res
	elif node_name == "Reroute":
		node_res = reroute_node_res
	elif node_name == "Reroute Text":
		node_res = reroute_text_node_res
	elif node_name == "Dialogue":
		node_res = dialogue_node_res
	elif node_name == "Enable/Disable Text":
		node_res = enable_node_res
	elif node_name == "Hide/Unhide Text":
		node_res = hide_node_res
	elif node_name == "Action":
		node_res = action_node_res
	elif node_name == "Note":
		node_res = note_node_res
	elif node_name == "Set Text":
		node_res = settext_node_res
	elif node_name == "Text":
		node_res = text_node_res
	elif node_name == "Character":
		node_res = character_node_res

	var new_node: GraphNode = node_res.instantiate()
	new_node.position_offset = _graph.scroll_offset + (Vector2(get_viewport().size) / 2.5)

	_graph.add_child(new_node)


func _input(event):
	if Input.is_key_pressed(KEY_DELETE):
		DeleteSelectedGraphNodes()


func DeleteSelectedGraphNodes():
	var nodes = _graph.get_children()
	var nodes_rng = range(nodes.size())
	nodes_rng.reverse()

	var del_names: Array[String] = []
	var connections = _graph.get_connection_list()

	# Delete Selected Nodes
	for i in nodes_rng:
		var node2: GraphNode = nodes[i] as GraphNode
		if node2.selected:
			del_names.append(node2.name)
			node2.queue_free()

	# Remove Connections of Deleted Nodes
	for conn in connections:
		if conn["from_node"] in del_names or conn["to_node"] in del_names:
			_graph.disconnect_node(conn["from_node"], conn["from_port"], conn["to_node"], conn["to_port"])


func _on_connection_request(from_node: StringName, from_port, to_node: StringName, to_port):
	if not _graph.is_node_connected(from_node, from_port, to_node, to_port):
		
		var from_graph_nd: GraphNode = _graph.get_node(NodePath(from_node)) as GraphNode
		var to_graph_nd: GraphNode = _graph.get_node(NodePath(to_node)) as GraphNode
		var connections = _graph.get_connection_list()
		
		# 0 Type.
		if from_graph_nd.get_output_port_type(from_port) == 0:
			# Remove Old Conncetion
			for conn in connections:
				if conn["from_node"] == from_node and from_port == conn["from_port"]:
					_graph.disconnect_node(conn["from_node"], conn["from_port"], conn["to_node"], conn["to_port"])
					break
		
		# 1 Type
		elif from_graph_nd.get_output_port_type(from_port) == 1:
			# If FROM is Enable/Hide and TO is not Dialogue
			if ( ( is_instance_of(from_graph_nd, DCEnableTextNode)
				or is_instance_of(from_graph_nd, DCHideTextNode) )
				and not is_instance_of(to_graph_nd, DCDialogueNode) ):
				return
			elif is_instance_of(to_graph_nd, DCDialogueNode):
				if to_port < 2:
					return
		
		_graph.connect_node(from_node, from_port, to_node, to_port)
	else:
		_graph.disconnect_node(from_node, from_port, to_node, to_port)


func _on_dc_graph_edit_disconnection_request(from_node, from_port, to_node, to_port):
	_graph.disconnect_node(from_node, from_port, to_node, to_port)


func _on_play_scene_button_pressed():
	add_child(play_scene_res.instantiate())
