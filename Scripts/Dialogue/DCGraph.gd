class_name DCGraph
extends Control

@onready var _graph: GraphEdit = $VBoxContainer/DCGraphEdit

@onready var file_button: MenuButton = $VBoxContainer/MenuBar/HBoxContainer/FileButton
@onready var nodes_button: DCNodesMenu = $VBoxContainer/MenuBar/HBoxContainer/NodesButton


# Preload Nodes
@onready var _start_node_res = preload("res://addons/dialoguecreator/Assets/Nodes/DCStartNode.tscn")
@onready var _dialogue_node_res = preload("res://addons/dialoguecreator/Assets/Nodes/DCDialogueNode.tscn")
@onready var _enable_node_res = preload("res://addons/dialoguecreator/Assets/Nodes/DCEnableTextNode.tscn")
@onready var _hide_node_res = preload("res://addons/dialoguecreator/Assets/Nodes/DCHideTextNode.tscn")
@onready var _reroute_node_res = preload("res://addons/dialoguecreator/Assets/Nodes/DCRerouteNode.tscn")
@onready var _reroute_text_node_res = preload("res://addons/dialoguecreator/Assets/Nodes/DCRerouteTextNode.tscn")
@onready var _action_node_res = preload("res://addons/dialoguecreator/Assets/Nodes/DCActionNode.tscn")
@onready var _note_node_res = preload("res://addons/dialoguecreator/Assets/Nodes/DCNoteNode.tscn")
@onready var _settext_node_res = preload("res://addons/dialoguecreator/Assets/Nodes/DCSetTextNode.tscn")
@onready var _text_node_res = preload("res://addons/dialoguecreator/Assets/Nodes/DCTextNode.tscn")


func _ready():
	nodes_button.add_node.connect(self._add_node)


func _add_node(node_name: String):
	var node_res: Resource
	
	if node_name == "Start":
		node_res = _start_node_res
	elif node_name == "Reroute":
		node_res = _reroute_node_res
	elif node_name == "Reroute Text":
		node_res = _reroute_text_node_res
	elif node_name == "Dialogue":
		node_res = _dialogue_node_res
	elif node_name == "Enable/Disable Text":
		node_res = _enable_node_res
	elif node_name == "Hide/Unhide Text":
		node_res = _hide_node_res
	elif node_name == "Action":
		node_res = _action_node_res
	elif node_name == "Note":
		node_res = _note_node_res
	elif node_name == "Set Text":
		node_res = _settext_node_res
	elif node_name == "Text":
		node_res = _text_node_res

	var new_node: GraphNode = node_res.instantiate()
	_graph.add_child(new_node)
	new_node.position_offset = _graph.scroll_offset + (Vector2(get_viewport().size) / 2.5)


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
		var connections = _graph.get_connection_list()
		
		# Remove Old Conncetion
		if from_graph_nd.get_input_port_type(from_port) == 0:
			for conn in connections:
				if conn["from_node"] == from_node and from_port == conn["from_port"]:
					_graph.disconnect_node(conn["from_node"], conn["from_port"], conn["to_node"], conn["to_port"])
					break
		
		_graph.connect_node(from_node, from_port, to_node, to_port)
	else:
		_graph.disconnect_node(from_node, from_port, to_node, to_port)


func _on_dc_graph_edit_disconnection_request(from_node, from_port, to_node, to_port):
	_graph.disconnect_node(from_node, from_port, to_node, to_port)


