class_name DCActionNode
extends DCBaseGraphNode



func get_action_name_node() -> LineEdit:
	return $Label/HBoxContainer/ActionNameLineEdit


func get_action_text_node() -> TextEdit:
	return $VBoxContainer/ActionTextLineEdit


func get_node_params_js():
	var params = get_node_base_params_js()
	
	params["ActionName"] = get_action_name_node().text

	params["ActionText"] = {}
	params["ActionText"]["Text"] = get_action_text_node().text

	var children = get_children()

	# Add Output Texts
	if children.size() > 3:
		params["ActionPorts"] = []

		if children.size() > 3:
			for i in range(children.size()):
				if i > 1 and i != children.size() - 1:
					var port = children[i] as DCActionNodePort

					var new_text = {}
					new_text["Text"] = port.get_text_node().text

					params["ActionPorts"].append(new_text)

	return [params, DCGUtils.ActionNode]


func add_action_port() -> DCActionNodePort:
	var port_node = DCGraph.action_port_res.instantiate() as DCActionNodePort
	add_child(port_node)

	var slot_id = get_children().size() - 2
	move_child(port_node, slot_id)

	port_node.DeleteDialogueText.connect(self.delete_action_port)
	port_node.UpDialogueText.connect(self.up_action_port)
	port_node.DownDialogueText.connect(self.down_action_port)

	set_slot( slot_id, false, 0, Color.WHITE, true, 0, Color.WHITE)

	return port_node


func up_action_port(the_node: Node):
	var children = get_children()
	var id = children.find(the_node)

	if id > 2:
		self.reverse_texts_up(the_node)


func down_action_port(the_node: Node):
	var children = get_children()
	var id = children.find(the_node)

	if id < children.size() - 2:
		self.reverse_texts_down(the_node)


func delete_action_port(the_node: Node):
	var children = get_children()
	var id = children.find(the_node)

	var node_to_del: Node = the_node

	if id < children.size() - 2:
		node_to_del = down_text_by_number((children.size() - 2) - id, node_to_del)

	clear_ports(node_to_del)
	clear_slot(get_children().find(node_to_del))

	node_to_del.queue_free()


func _on_add_action_button_pressed():
	add_action_port()
