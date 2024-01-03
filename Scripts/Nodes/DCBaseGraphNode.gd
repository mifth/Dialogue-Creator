class_name DCBaseGraphNode
extends GraphNode


func _exit_tree():
	queue_free()


func GetInputPortID(the_node: Node) -> int:
	var children = get_children()
	
	for i in range(get_input_port_count()):
		var slot_id = get_input_port_slot(i)
		var slot_node = children[slot_id]
		
		if slot_node == the_node:
			return i

	return -1


func GetOutputPortID(the_node: Node) -> int:
	var children = get_children()
	
	for i in range(get_output_port_count()):
		var slot_id = get_output_port_slot(i)
		var slot_node = children[slot_id]
		
		if slot_node == the_node:
			return i

	return -1


func ClearPorts(the_node: Node):
	var graph = get_parent() as GraphEdit
	
	var connections = graph.get_connection_list()

	var input_port := GetInputPortID(the_node)
	var output_port := GetOutputPortID(the_node)

	for i in range(connections.size() - 1, -1, -1):
		var conn = connections[i]

		if conn["from_node"] == name and conn["from_port"] == output_port and output_port > -1:
			graph.disconnect_node(conn["from_node"], conn["from_port"], conn["to_node"], conn["to_port"])
		elif conn["to_node"] == name and conn["to_port"] == input_port and input_port > -1:
			graph.disconnect_node(conn["from_node"], conn["from_port"], conn["to_node"], conn["to_port"])


func GetFirstID(the_node: Node):
	var children = get_children()
	
	for i in range(children.size()):
		var child = children[i]
	
		if child.get_class() == the_node.get_class():
			return i
	
	return -1


func UpPort(the_node: Node):
	var first_id = GetFirstID(the_node)

	if get_children().find(the_node) == first_id:
		return

	var second_node: Node

	var graph = get_parent() as GraphEdit
	var connections = graph.get_connection_list()

	var input_port := GetInputPortID(the_node)
	var output_port := GetOutputPortID(the_node)
	
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


func DownPort(the_node: Node):
	if get_children().find(the_node) == get_children().size() - 1:
		return

	var second_node: Node

	var graph = get_parent() as GraphEdit
	var connections = graph.get_connection_list()

	var input_port := GetInputPortID(the_node)
	var output_port := GetOutputPortID(the_node)
	
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


func ReverseTexts(nodes):
	if nodes and nodes[0] and nodes[1]:
		var text_1: DCDialogueNodeText = nodes[0] as DCDialogueNodeText
		var text_2: DCDialogueNodeText = nodes[1] as DCDialogueNodeText

		var tmp_txt_1 = text_1.GetTextNode().text
		var tmp_txt_2 = text_2.GetTextNode().text
		
		text_1.GetTextNode().text = tmp_txt_2
		text_2.GetTextNode().text = tmp_txt_1


func ReverseTextsUp(the_node: Node):
	var nodes = UpPort(the_node)
	
	if nodes:
		ReverseTexts(nodes)


func ReverseTextsDown(the_node: Node):
	var nodes = DownPort(the_node)
	
	if nodes:
		ReverseTexts(nodes)
