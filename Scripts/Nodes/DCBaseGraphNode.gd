class_name DCBaseNode
extends GraphNode


func _exit_tree():
	queue_free()


func ClearPorts(text_node: DCDialogueNodeText):
	var graph = get_parent() as GraphEdit
	
	var connections = graph.get_connection_list()
	
	var input_port: int = -1
	var output_port: int = -1

	# Get Input Port
	for i in range(get_input_port_count()):
		var slot_id = get_input_port_slot(i)
		var slot_node = get_children()[slot_id]
		
		if slot_node == text_node:
			input_port = i
			break
		
	# Get Output Port
	for i in range(get_output_port_count()):
		var slot_id = get_output_port_slot(i)
		var slot_node = get_children()[slot_id]
		
		if slot_node == text_node:
			output_port = i
			break

	for i in range(connections.size() - 1, -1, -1):
		var conn = connections[i]
		
		if conn["to_node"] == name and conn["to_port"] == input_port and input_port > -1:
			graph.disconnect_node(conn["from_node"], conn["from_port"], conn["to_node"], conn["to_port"])
		elif conn["from_node"] == name and conn["from_port"] == output_port and output_port > -1:
			graph.disconnect_node(conn["from_node"], conn["from_port"], conn["to_node"], conn["to_port"])
