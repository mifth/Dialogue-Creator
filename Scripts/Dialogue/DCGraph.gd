extends Control

@onready var _graph: GraphEdit = $VBoxContainer/DCGraphEdit

@onready var file_button: MenuButton = $VBoxContainer/MenuBar/HBoxContainer/FileButton
@onready var nodes_button: DCNodesMenu = $VBoxContainer/MenuBar/HBoxContainer/NodesButton


# Preload Nodes
@onready var _start_node_res = preload("res://addons/dialoguecreator/Assets/Nodes/DCStartNode.tscn")
@onready var _text_node_res = preload("res://addons/dialoguecreator/Assets/Nodes/DCTextNode.tscn")
@onready var _en_dis_node_res = preload("res://addons/dialoguecreator/Assets/Nodes/DCEnDisTextNode.tscn")
@onready var _reroute_node_res = preload("res://addons/dialoguecreator/Assets/Nodes/DCRerouteNode.tscn")


func _ready():
	nodes_button.add_node.connect(self._add_node)


func _add_node(node_name: String):
	var node_res: Resource
	
	if node_name == "Start":
		node_res = _start_node_res
	elif node_name == "Reroute":
		node_res = _reroute_node_res
	elif node_name == "Text":
		node_res = _text_node_res
	elif node_name == "Enable/Disable Text":
		node_res = _en_dis_node_res

	var new_node: GraphNode = node_res.instantiate()
	_graph.add_child(new_node)
	new_node.position_offset = _graph.scroll_offset + (Vector2(get_viewport().size) / 2.5)


func _input(event):
	if Input.is_key_pressed(KEY_DELETE):
		var nodes = _graph.get_children()
		for i in range(nodes.size() - 1, -1, -1):
			var node2: GraphNode = nodes[i]
			if node2.selected:
				node2.queue_free()


func _on_connection_request(from_node, from_port, to_node, to_port):
	if not _graph.is_node_connected(from_node, from_port, to_node, to_port):
		_graph.connect_node(from_node, from_port, to_node, to_port)
	else:
		_graph.disconnect_node(from_node, from_port, to_node, to_port)


func _on_dc_graph_edit_disconnection_request(from_node, from_port, to_node, to_port):
	_graph.disconnect_node(from_node, from_port, to_node, to_port)


