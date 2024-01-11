class_name DCParse
extends Object


static func CreateNodesArraysJS():
	var nodes_js = {}
	
	nodes_js[DCUtils.ActionNode] = []
	nodes_js[DCUtils.DialogueNode] = []
	nodes_js[DCUtils.EnableTextNode] = []
	nodes_js[DCUtils.HideTextNode] = []
	nodes_js[DCUtils.NoteNode] = []
	nodes_js[DCUtils.RerouteNode] = []
	nodes_js[DCUtils.RerouteTextNode] = []
	nodes_js[DCUtils.SetTextNode] = []
	nodes_js[DCUtils.StartNode] = []
	nodes_js[DCUtils.TextNode] = []
	nodes_js[DCUtils.CharacterNode] = []

	return nodes_js


static func GetDataJS(graph: GraphEdit):
	var data_js = {}
	var nodes_js = CreateNodesArraysJS()
	var conns_js = []

	# Get Nodes Data
	for node in graph.get_children():
		if is_instance_of(node, DCBaseGraphNode):
			var node_params = node.GetNodeParamsJS()
			nodes_js[node_params[1]].append(node_params[0])

	for conn in graph.get_connection_list():
		var conn_js = {}
		conn_js["FromNode"] = conn["from_node"]
		conn_js["FromPort"] = conn["from_port"]
		conn_js["ToNode"] = conn["to_node"]
		conn_js["ToPort"] = conn["to_port"]
		
		conns_js.append(conn_js)

	data_js["Nodes"] = nodes_js
	data_js["Connections"] = conns_js
	data_js["Version"] = DCUtils.version

	return data_js


static func SaveFileJS(graph: GraphEdit, path: String):
	var data_js = GetDataJS(graph)
	
	var data_js_str = JSON.stringify(data_js, "   ")

	if FileAccess.file_exists(path):
		# Set Writable
		if FileAccess.get_read_only_attribute(path):
			FileAccess.set_read_only_attribute(path, false)

	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(data_js_str)
	
	
static func LoadFileJS(graph: GraphEdit, path: String):
	var text_js = FileAccess.get_file_as_string(path)
	var data_js = JSON.parse_string(text_js)

	var nodes_js = data_js["Nodes"]
	var conns_js = data_js["Connections"]
	
	var nodes_by_name = {}  # Nodes By Original Name

	for node_js in nodes_js[DCUtils.ActionNode]:
		var new_node = DCGraph.action_node_res.instantiate() as GraphNode
		graph.add_child(new_node)
		SetNodeParamsJS(new_node, node_js)
		nodes_by_name[node_js["Name"]] = new_node.name
		

	for node_js in nodes_js[DCUtils.DialogueNode]:
		var new_node = DCGraph.dialogue_node_res.instantiate() as DCDialogueNode
		graph.add_child(new_node)
		SetNodeParamsJS(new_node, node_js)
		nodes_by_name[node_js["Name"]] = new_node.name
		
		# Set Main Text
		var main_text = new_node.GetMainText()
		main_text.text = node_js["MainText"]["Text"]
		
		var char_id = new_node.GetCharacterIDSpinBox()
		char_id.value = node_js["CharacterID"] as int
		
		if node_js["TextSlots"]:
			AddTextTextSlotsJS(new_node, node_js["TextSlots"])
		

	for node_js in nodes_js[DCUtils.EnableTextNode]:
		var new_node = DCGraph.enable_node_res.instantiate() as GraphNode
		graph.add_child(new_node)
		SetNodeParamsJS(new_node, node_js)
		nodes_by_name[node_js["Name"]] = new_node.name

	for node_js in nodes_js[DCUtils.HideTextNode]:
		var new_node = DCGraph.hide_node_res.instantiate() as GraphNode
		graph.add_child(new_node)
		SetNodeParamsJS(new_node, node_js)
		nodes_by_name[node_js["Name"]] = new_node.name

	for node_js in nodes_js[DCUtils.NoteNode]:
		var new_node = DCGraph.note_node_res.instantiate() as GraphNode
		graph.add_child(new_node)
		SetNodeParamsJS(new_node, node_js)
		nodes_by_name[node_js["Name"]] = new_node.name

	for node_js in nodes_js[DCUtils.RerouteNode]:
		var new_node = DCGraph.reroute_node_res.instantiate() as GraphNode
		graph.add_child(new_node)
		SetNodeParamsJS(new_node, node_js)
		nodes_by_name[node_js["Name"]] = new_node.name

	for node_js in nodes_js[DCUtils.RerouteTextNode]:
		var new_node = DCGraph.reroute_text_node_res.instantiate() as GraphNode
		graph.add_child(new_node)
		SetNodeParamsJS(new_node, node_js)
		nodes_by_name[node_js["Name"]] = new_node.name

	for node_js in nodes_js[DCUtils.SetTextNode]:
		var new_node = DCGraph.settext_node_res.instantiate() as GraphNode
		graph.add_child(new_node)
		SetNodeParamsJS(new_node, node_js)
		
		if node_js["TextSlots"]:
			AddTextTextSlotsJS(new_node, node_js["TextSlots"])
		
		nodes_by_name[node_js["Name"]] = new_node.name

	for node_js in nodes_js[DCUtils.StartNode]:
		var new_node = DCGraph.start_node_res.instantiate() as GraphNode
		graph.add_child(new_node)
		SetNodeParamsJS(new_node, node_js)
		nodes_by_name[node_js["Name"]] = new_node.name

	for node_js in nodes_js[DCUtils.TextNode]:
		var new_node = DCGraph.text_node_res.instantiate() as GraphNode
		graph.add_child(new_node)
		SetNodeParamsJS(new_node, node_js)
		
		if node_js["TextSlots"]:
			AddTextTextSlotsJS(new_node, node_js["TextSlots"])
		
		nodes_by_name[node_js["Name"]] = new_node.name

	for node_js in nodes_js[DCUtils.CharacterNode]:
		var new_node = DCGraph.character_node_res.instantiate() as DCCharacterNode
		graph.add_child(new_node)
		SetNodeParamsJS(new_node, node_js)
		
		var char_id = new_node.GetCharacterIDSpinBox()
		char_id.value = node_js["CharacterID"] as int
		
		new_node.GetCharacterNameLineEdit().text = node_js["CharacterName"]
		
		nodes_by_name[node_js["Name"]] = new_node.name

	# Add Connections
	for conn_js in conns_js:
		graph.connect_node(nodes_by_name[conn_js["FromNode"]], conn_js["FromPort"], nodes_by_name[conn_js["ToNode"]], conn_js["ToPort"])


static func AddTextTextSlotsJS(base_graph_node: DCBaseGraphNode, texts: Array):
	for text in texts:
		var text_node = base_graph_node.AddTextTextNode() as DCDialogueNodeText
		text_node.GetTextNode().text = text["Text"]
		

static func SetNodeParamsJS(node: GraphNode, node_js):
	node.position_offset = Vector2(node_js["Position"][0], node_js["Position"][1])
	
	if node_js["Size"]:
		node.size = Vector2(node_js["Size"][0], node_js["Size"][1])
