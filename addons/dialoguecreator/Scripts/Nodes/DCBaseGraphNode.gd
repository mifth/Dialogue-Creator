class_name DCBaseGraphNode
extends GraphNode


func _exit_tree():
	queue_free()


func get_input_port_id(the_node: Node) -> int:
	var children = get_children()
	
	for i in range(get_input_port_count()):
		var slot_id = get_input_port_slot(i)
		var slot_node = children[slot_id]
		
		if slot_node == the_node:
			return i

	return -1


func get_output_port_id(the_node: Node) -> int:
	var children = get_children()
	
	for i in range(get_output_port_count()):
		var slot_id = get_output_port_slot(i)
		var slot_node = children[slot_id]
		
		if slot_node == the_node:
			return i

	return -1


func clear_ports(the_node: Node):
	var graph = get_parent() as GraphEdit
	
	var connections = graph.get_connection_list()

	var input_port := get_input_port_id(the_node)
	var output_port := get_output_port_id(the_node)

	for i in range(connections.size() - 1, -1, -1):
		var conn = connections[i]

		if conn["from_node"] == name and conn["from_port"] == output_port and output_port > -1:
			graph.disconnect_node(conn["from_node"], conn["from_port"], conn["to_node"], conn["to_port"])
		elif conn["to_node"] == name and conn["to_port"] == input_port and input_port > -1:
			graph.disconnect_node(conn["from_node"], conn["from_port"], conn["to_node"], conn["to_port"])


func get_first_id(the_node: Node):
	var children = get_children()
	
	for i in range(children.size()):
		var child = children[i]
	
		if child.get_class() == the_node.get_class():
			return i
	
	return -1


func up_port(the_node: Node):
	var first_id = get_first_id(the_node)

	if get_children().find(the_node) == first_id:
		return

	var second_node: Node

	var graph = get_parent() as GraphEdit
	var connections = graph.get_connection_list()

	var input_port := get_input_port_id(the_node)
	var output_port := get_output_port_id(the_node)
	
	var up_input_port := -1
	var up_output_port := -1
	
	if input_port > -1:
		up_input_port = input_port - 1
		second_node = get_child(get_input_port_slot(up_input_port))
	if output_port > -1:
		up_output_port = output_port - 1
		second_node = get_child(get_output_port_slot(up_output_port))
	
	var new_connections = []

	for i in range(connections.size() - 1, -1, -1):
		var conn = connections[i]
		
		if conn["from_node"] == name and conn["from_port"] == output_port and output_port > -1:
			new_connections.append([conn["from_node"], conn["from_port"] - 1, conn["to_node"], conn["to_port"]])
			graph.disconnect_node(conn["from_node"], conn["from_port"], conn["to_node"], conn["to_port"])
		elif conn["to_node"] == name and conn["to_port"] == input_port and input_port > -1:
			new_connections.append([conn["from_node"], conn["from_port"], conn["to_node"], conn["to_port"] - 1])
			graph.disconnect_node(conn["from_node"], conn["from_port"], conn["to_node"], conn["to_port"])

		elif conn["from_node"] == name and conn["from_port"] == up_output_port and up_output_port > -1:
			new_connections.append([conn["from_node"], conn["from_port"] + 1, conn["to_node"], conn["to_port"]])
			graph.disconnect_node(conn["from_node"], conn["from_port"], conn["to_node"], conn["to_port"])
		elif conn["to_node"] == name and conn["to_port"] == up_input_port and up_input_port > -1:
			new_connections.append([conn["from_node"], conn["from_port"], conn["to_node"], conn["to_port"] + 1])
			graph.disconnect_node(conn["from_node"], conn["from_port"], conn["to_node"], conn["to_port"])
			
	for conn in new_connections:
		graph.connect_node(conn[0], conn[1], conn[2], conn[3])

	return [the_node, second_node]


func down_port(the_node: Node):
	var node_id = get_children().find(the_node)

	if node_id == get_children().size() - 1:
		return

	var second_node: Node

	var graph = get_parent() as GraphEdit
	var connections = graph.get_connection_list()

	var input_port := get_input_port_id(the_node)
	var output_port := get_output_port_id(the_node)
	
	var down_input_port := -1
	var down_output_port := -1
	
	if input_port > -1:
		down_input_port = input_port + 1
		second_node = get_child(get_input_port_slot(down_input_port))
	if output_port > -1:
		down_output_port = output_port + 1
		second_node = get_child(get_output_port_slot(down_output_port))
	
	var new_connections = []

	for i in range(connections.size() - 1, -1, -1):
		var conn = connections[i]
		
		if conn["from_node"] == name and conn["from_port"] == output_port and output_port > -1:
			new_connections.append([conn["from_node"], conn["from_port"] + 1, conn["to_node"], conn["to_port"]])
			graph.disconnect_node(conn["from_node"], conn["from_port"], conn["to_node"], conn["to_port"])
		elif conn["to_node"] == name and conn["to_port"] == input_port and input_port > -1:
			new_connections.append([conn["from_node"], conn["from_port"], conn["to_node"], conn["to_port"] + 1])
			graph.disconnect_node(conn["from_node"], conn["from_port"], conn["to_node"], conn["to_port"])

		elif conn["from_node"] == name and conn["from_port"] == down_output_port and down_output_port > -1:
			new_connections.append([conn["from_node"], conn["from_port"] - 1, conn["to_node"], conn["to_port"]])
			graph.disconnect_node(conn["from_node"], conn["from_port"], conn["to_node"], conn["to_port"])
		elif conn["to_node"] == name and conn["to_port"] == down_input_port and down_input_port > -1:
			new_connections.append([conn["from_node"], conn["from_port"], conn["to_node"], conn["to_port"] - 1])
			graph.disconnect_node(conn["from_node"], conn["from_port"], conn["to_node"], conn["to_port"])
			
	for conn in new_connections:
		graph.connect_node(conn[0], conn[1], conn[2], conn[3])
	
	return [the_node, second_node]


func down_text_by_number(numb: int, the_node: Node):
	var cur_node = the_node

	for i in range(numb):
		var ret_values = down_port(cur_node)
		reverse_texts(ret_values)
		cur_node = ret_values[1]
	
	return cur_node


func delete_text_port(the_node: Node):
	var children = get_children()
	var id = children.find(the_node)

	var node_to_del: Node = the_node

	if id < children.size() - 1:
		node_to_del = down_text_by_number((children.size() - 1) - id, node_to_del)

	clear_ports(node_to_del)
	clear_slot(get_children().find(node_to_del))

	node_to_del.queue_free()


func reverse_texts(nodes):
	if nodes and nodes[0] and nodes[1]:
		var text_1: Control = nodes[0]
		var text_2: Control = nodes[1]

		var tmp_txt_1 = text_1.get_text_node().text
		var tmp_txt_2 = text_2.get_text_node().text
		
		text_1.get_text_node().text = tmp_txt_2
		text_2.get_text_node().text = tmp_txt_1


func reverse_texts_up(the_node: Node):
	var nodes = up_port(the_node)
	
	if nodes:
		reverse_texts(nodes)


func reverse_texts_down(the_node: Node):
	var nodes = down_port(the_node)
	
	if nodes:
		reverse_texts(nodes)


func get_inputs_js():
	var inputs = []

	for i in range(get_input_port_count()):
		var input = {}
		input["Type"] = get_input_port_type(i)
		
		inputs.append(input)

	return inputs


func get_outputs_js():
	var outputs = []
	
	# Outputs
	for i in range(get_output_port_count()):
		var output = {}
		output["Type"] = get_output_port_type(i)
		
		outputs.append(output)
	
	return outputs


func get_node_base_params_js() -> Dictionary:
	var base_params = {}

	base_params["Inputs"] = get_inputs_js()
	base_params["Outputs"] = get_outputs_js()
	
	base_params["Name"] = name
	
	base_params["Position"] = [position_offset.x, position_offset.y]

	if resizable:
		base_params["Size"] = [size.x, size.y]
	else:
		base_params["Size"] = []

	return base_params


func get_text_nodes_js():
	var text_nodes_js = []
	var children = get_children()
	for i in range(children.size()):
		var child_node = children[i]
		
		if is_instance_of(child_node, DCDialogueNodeText):
			var text_node = child_node as DCDialogueNodeText
			
			var text_slot_dict = {}
			text_slot_dict["Text"] = text_node.get_text_node().text

			text_nodes_js.append(text_slot_dict)
	
	return text_nodes_js


func add_text_node(is_port_l:bool, port_l_type: int, port_l_color: Color,
				is_port_r:bool, port_r_type: int, port_r_color: Color) -> DCDialogueNodeText:
	var text_node = DCGraph.text_node_text_res.instantiate() as DCDialogueNodeText
	
	text_node.DeleteDialogueText.connect(self.delete_text_port)
	text_node.UpDialogueText.connect(self.reverse_texts_up)
	text_node.DownDialogueText.connect(self.reverse_texts_down)

	add_child(text_node)
	set_slot( get_children().size() - 1, is_port_l, port_l_type, port_l_color, is_port_r, port_r_type, port_r_color)
	
	return text_node

