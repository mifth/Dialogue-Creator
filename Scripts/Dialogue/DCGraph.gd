extends Control

@onready var _graph: GraphEdit = $VBoxContainer/DCGraphEdit


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
