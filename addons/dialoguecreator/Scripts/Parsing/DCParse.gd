class_name DCParse
extends Object


static func GetDataJS(main_graph: DCGraph):
	var graph = main_graph.graph
	
	var data_js = {}
	var nodes_js = {}
	var conns_js = []

	# Get Nodes Data
	for node in graph.get_children():
		if is_instance_of(node, DCBaseGraphNode):
			var node_params = node.GetNodeParamsJS()
			
			# Create Array
			if node_params[1] not in nodes_js:
				nodes_js[node_params[1]] = []

			# Add Params
			nodes_js[node_params[1]].append(node_params[0])

	for conn in graph.get_connection_list():
		var conn_js = {}
		conn_js["from_node"] = conn["from_node"]
		conn_js["from_port"] = conn["from_port"] as int
		conn_js["to_node"] = conn["to_node"]
		conn_js["to_port"] = conn["to_port"] as int
		
		conns_js.append(conn_js)

	data_js["Nodes"] = nodes_js
	data_js["Connections"] = conns_js

	var play_setts = {}
	play_setts["StartID"] = main_graph.play_start_id_spin.value as int
	play_setts["LangName"] = main_graph.play_lang_edit.text
	data_js["PlaySettings"] = play_setts
	

	data_js["Version"] = DCUtils.version

	return data_js


static func SaveFileJS(main_graph: DCGraph, path: String):
	var graph = main_graph.graph
	
	var data_js = GetDataJS(main_graph)
	var data_js_str = JSON.stringify(data_js, "   ")
	
	var final_path = path
	if not final_path.ends_with(".json"):
		final_path += ".json"

	if FileAccess.file_exists(final_path):
		# Set Writable
		if FileAccess.get_read_only_attribute(final_path):
			FileAccess.set_read_only_attribute(final_path, false)

	var file = FileAccess.open(final_path, FileAccess.WRITE)
	file.store_string(data_js_str)
	
	
static func LoadFileJS(main_graph: DCGraph, path: String):
	var graph = main_graph.graph
	
	var text_js = FileAccess.get_file_as_string(path)
	var data_js = JSON.parse_string(text_js)

	var nodes_js = data_js["Nodes"]
	
	var nodes_by_name = {}  # Nodes By Original Name

	if DCGUtils.ActionNode in nodes_js:
		for node_js in nodes_js[DCGUtils.ActionNode]:
			var new_node = DCGraph.action_node_res.instantiate() as DCActionNode
			graph.add_child(new_node)
			SetNodeParamsJS(new_node, node_js)
			
			new_node.get_action_name_node().text = node_js["ActionName"]
			new_node.get_action_text_node().text = node_js["ActionText"]
			
			nodes_by_name[node_js["Name"]] = new_node.name
		

	if DCGUtils.DialogueNode in nodes_js:
		for node_js in nodes_js[DCGUtils.DialogueNode]:
			var new_node = DCGraph.dialogue_node_res.instantiate() as DCDialogueNode
			graph.add_child(new_node)
			SetNodeParamsJS(new_node, node_js)
			nodes_by_name[node_js["Name"]] = new_node.name
			
			# Set Main Text
			var main_text = new_node.GetMainText()
			main_text.text = node_js["MainText"]["Text"]
			
			if "Character" in node_js.keys():
				var char_id = new_node.GetCharacterIDSpinBox()
				char_id.value = node_js["Character"]["Id"] as int
			
			if node_js["TextSlots"]:
				AddTextTextSlotsJS(new_node, node_js["TextSlots"])
		

	if DCGUtils.EnableTextNode in nodes_js:
		for node_js in nodes_js[DCGUtils.EnableTextNode]:
			var new_node = DCGraph.enable_node_res.instantiate() as GraphNode
			graph.add_child(new_node)
			SetNodeParamsJS(new_node, node_js)
			nodes_by_name[node_js["Name"]] = new_node.name

	if DCGUtils.HideTextNode in nodes_js:
		for node_js in nodes_js[DCGUtils.HideTextNode]:
			var new_node = DCGraph.hide_node_res.instantiate() as GraphNode
			graph.add_child(new_node)
			SetNodeParamsJS(new_node, node_js)
			nodes_by_name[node_js["Name"]] = new_node.name

	if DCGUtils.NoteNode in nodes_js:
		for node_js in nodes_js[DCGUtils.NoteNode]:
			var new_node = DCGraph.note_node_res.instantiate() as GraphNode
			graph.add_child(new_node)
			SetNodeParamsJS(new_node, node_js)
			nodes_by_name[node_js["Name"]] = new_node.name

	if DCGUtils.RerouteNode in nodes_js:
		for node_js in nodes_js[DCGUtils.RerouteNode]:
			var new_node = DCGraph.reroute_node_res.instantiate() as GraphNode
			graph.add_child(new_node)
			SetNodeParamsJS(new_node, node_js)
			nodes_by_name[node_js["Name"]] = new_node.name

	if DCGUtils.RerouteTextNode in nodes_js:
		for node_js in nodes_js[DCGUtils.RerouteTextNode]:
			var new_node = DCGraph.reroute_text_node_res.instantiate() as GraphNode
			graph.add_child(new_node)
			SetNodeParamsJS(new_node, node_js)
			nodes_by_name[node_js["Name"]] = new_node.name

	if DCGUtils.SetTextNode in nodes_js:
		for node_js in nodes_js[DCGUtils.SetTextNode]:
			var new_node = DCGraph.settext_node_res.instantiate() as GraphNode
			graph.add_child(new_node)
			SetNodeParamsJS(new_node, node_js)
			
			if node_js["TextSlots"]:
				AddTextTextSlotsJS(new_node, node_js["TextSlots"])
			
			nodes_by_name[node_js["Name"]] = new_node.name

	if DCGUtils.StartNode in nodes_js:
		for node_js in nodes_js[DCGUtils.StartNode]:
			var new_node = DCGraph.start_node_res.instantiate() as DCStartNode
			graph.add_child(new_node)
			SetNodeParamsJS(new_node, node_js)
			
			new_node.GetStartName().text = node_js["StartName"]
			new_node.GetStartIDSpinBox().value = node_js["StartID"] as int
			
			nodes_by_name[node_js["Name"]] = new_node.name

	if DCGUtils.TextNode in nodes_js:
		for node_js in nodes_js[DCGUtils.TextNode]:
			var new_node = DCGraph.text_node_res.instantiate() as GraphNode
			graph.add_child(new_node)
			SetNodeParamsJS(new_node, node_js)
			
			if node_js["TextSlots"]:
				AddTextTextSlotsJS(new_node, node_js["TextSlots"])
			
			nodes_by_name[node_js["Name"]] = new_node.name

	if DCGUtils.CharacterNode in nodes_js:
		for node_js in nodes_js[DCGUtils.CharacterNode]:
			var new_node = DCGraph.character_node_res.instantiate() as DCCharacterNode
			graph.add_child(new_node)
			SetNodeParamsJS(new_node, node_js)
			
			var char_id = new_node.GetCharacterIDSpinBox()
			char_id.value = node_js["CharacterID"] as int
			
			new_node.GetCharacterNameLineEdit().text = node_js["CharacterName"]
			
			# Set Character Icon
			var char_icons = new_node.GetItemsIcons()
			if node_js["CharacterTexture"] < char_icons.item_count:
				char_icons.select((node_js["CharacterTexture"] as int % char_icons.item_count as int) as int)
			else:
				char_icons.select(char_icons.item_count - 1)
			
			nodes_by_name[node_js["Name"]] = new_node.name

	# Add Connections
	if "Connections" in data_js:
		for conn_js in data_js["Connections"]:
			graph.connect_node(nodes_by_name[conn_js["from_node"]], conn_js["from_port"], nodes_by_name[conn_js["to_node"]], conn_js["to_port"])

	# Play Settings
	if "PlaySettings" in data_js:
		main_graph.play_start_id_spin.value = data_js["PlaySettings"]["StartID"]
		main_graph.play_lang_edit.text = data_js["PlaySettings"]["LangName"]


static func AddTextTextSlotsJS(base_graph_node: DCBaseGraphNode, texts: Array):
	for text in texts:
		var text_node = base_graph_node.AddTextTextNode() as DCDialogueNodeText
		text_node.GetTextNode().text = text["Text"]
		

static func SetNodeParamsJS(node: GraphNode, node_js):
	node.position_offset = Vector2(node_js["Position"][0], node_js["Position"][1])
	
	if node_js["Size"]:
		node.size = Vector2(node_js["Size"][0], node_js["Size"][1])
