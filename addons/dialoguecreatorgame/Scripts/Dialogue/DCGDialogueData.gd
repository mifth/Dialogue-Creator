class_name DCGDialogueData
extends Object


var data_js: Dictionary
var nodes_by_name: Dictionary = {}


class NodeData:
	var node_class_key: String  # Node Class Nmae
	var array_index: int  # Index in data_js["Nodes"][node_class_key] Array

	var from_node_conns := {}
	var to_node_conns := {}
	
	func fill_data(node_key: String, array_index: int):
		self.node_class_key = node_key
		self.array_index = array_index


func get_node_js(node_data: NodeData):
	return get_nodes_js()[node_data.node_class_key][node_data.array_index]


func parse_js(date_js_str: String):
	self.data_js = JSON.parse_string(date_js_str)
	
	if self.data_js:
		var nodes_js: Dictionary = get_nodes_js()
		
		# Get Nodes By Name
		for nodes_key in nodes_js.keys():
			var the_nodes_js : Array = nodes_js[nodes_key]
			
			# Get Nodes By Name
			for i in range(the_nodes_js.size()):
				var node_js = the_nodes_js[i]
				
				var dc_node_data = self.NodeData.new()
				dc_node_data.fill_data(nodes_key, i)
				
				self.nodes_by_name[node_js["Name"]] = dc_node_data

		# Get Connections per Node
		var conns_js = get_connections_js()
		for i in range(conns_js.size()):
			var conn = conns_js[i]
			
			var from_node_c = self.nodes_by_name[conn["from_node"]].from_node_conns
			var from_port = conn["from_port"] as int
			var to_port = conn["to_port"] as int
			
			if from_port not in from_node_c.keys():
				from_node_c[from_port] = []
			from_node_c[from_port].append(i)
			
			var to_node_c = self.nodes_by_name[conn["to_node"]].to_node_conns
			if to_port not in to_node_c.keys():
				to_node_c[to_port] = []
			to_node_c[to_port].append(i)


# live_nodes_js are json nodes which can be modified during a dialogue
func get_next_dialogue_node(the_node: NodeData, port_id: int, live_nodes_js: Dictionary) -> NodeData:
	var next_node = the_node

	for i in range(200):  # 200 iterations are just not to get infinite recursion
		var node_js = get_nodes_js()[next_node.node_class_key][next_node.array_index]
		var node_outputs = node_js["Outputs"]
		
		var output_id
		
		if i == 0:
			output_id = port_id
		elif node_outputs and node_outputs[0]["Type"] == 0:
			output_id = 0

		if output_id != null:
			if output_id in next_node.from_node_conns.keys():
				var node_data_port_id = next_node.from_node_conns[output_id]

				if node_data_port_id:
					var conn = get_connections_js()[node_data_port_id[0]]
					var parse_node = nodes_by_name[conn["to_node"]] as DCGDialogueData.NodeData

					# Next Interactive Node Is Found!
					if parse_node.node_class_key in DCGUtils.dialogue_nodes_types:
						return parse_node
					else:
						if parse_node.node_class_key == DCGUtils.SetTextNode:
							change_live_texts(parse_node, live_nodes_js)
						elif parse_node.node_class_key == DCGUtils.EnableTextNode:
							change_live_texts(parse_node, live_nodes_js)
						elif parse_node.node_class_key == DCGUtils.HideTextNode:
							change_live_texts(parse_node, live_nodes_js)
						
						next_node = parse_node
						
				else:
					return null
			else:
				return null
		else:
			return null

	print("Infinite Recursion of " + get_nodes_js()[the_node.node_class_key][the_node.array_index]["Name"])

	return null


func get_live_node_js(the_node: NodeData, live_nodes_js: Dictionary):
	if the_node.node_class_key in DCGUtils.live_nodes_types:
		var node_js = get_nodes_js()[the_node.node_class_key][the_node.array_index]
		var live_node_js
		
		if nodes_by_name.find_key(the_node) not in live_nodes_js:
		
			live_node_js = node_js.duplicate(true)
			live_nodes_js[node_js["Name"]] = live_node_js
		else:
			live_node_js = live_nodes_js[node_js["Name"]]
			
		return live_node_js


# Only for the TextNode, EnableTextNode, HideTextNode
func change_live_texts(from_node: NodeData, live_nodes_js: Dictionary):
	var from_live_node_js = get_live_node_js(from_node, live_nodes_js)
	
	for from_port in from_node.from_node_conns.keys():
		if from_port == 0:
			continue
		
		var conns_ids = from_node.from_node_conns[from_port]

		for conn_id in conns_ids:
			var conn = get_connections_js()[conn_id]
			var to_node = nodes_by_name[conn["to_node"]] as NodeData
			var to_port = conn["to_port"]
			# var from_port = conn["from_port"]
			var to_live_node_js = get_live_node_js(to_node, live_nodes_js)

			if to_node.node_class_key in DCGUtils.live_nodes_types:
					change_live_text(from_port, to_port, from_live_node_js,
									to_live_node_js, from_node, to_node)


func change_live_text(from_port: int, to_port: int, from_live_node_js, to_live_node_js, from_node: NodeData, to_node: NodeData):

	# Get From_Node Text
	var from_text

	if from_node.node_class_key == DCGUtils.SetTextNode:
		if from_live_node_js["TextSlots"]:
			if from_port == 1:  # Random
				var rand_id = randi_range(0, from_live_node_js["TextSlots"].size() - 1)
				from_text = get_text_of_text_slot(from_live_node_js["TextSlots"][rand_id])
			else:
				from_text = get_text_of_text_slot(from_live_node_js["TextSlots"][from_port - 2])
		else:
			from_text = "NO TEXT"
	
	if to_node.node_class_key == DCGUtils.DialogueNode: 
		# Main Text
		if to_port == 1:
			# Set New Live Text
			if from_node.node_class_key == DCGUtils.SetTextNode:
				to_live_node_js["MainText"]["LiveText"] = from_text

		# Text Slot
		elif to_port > 1:
			# Set New Live Text
			if from_node.node_class_key == DCGUtils.SetTextNode:
				to_live_node_js["TextSlots"][to_port - 2]["LiveText"] = from_text

			elif from_node.node_class_key == DCGUtils.EnableTextNode:
				var enable_text = true

				if from_port == 2:
					enable_text = false

				to_live_node_js["TextSlots"][to_port - 2]["EnableLiveText"] = enable_text

			elif from_node.node_class_key == DCGUtils.HideTextNode:
				var hide_text = true

				if from_port == 2:
					hide_text = false

				to_live_node_js["TextSlots"][to_port - 2]["HideLiveText"] = hide_text


func get_text_of_text_slot(main_text_js):
	var main_text_str = main_text_js["Text"]
	if "LiveText" in main_text_js:
		main_text_str = main_text_js["LiveText"]
	else:
		main_text_str = main_text_js["Text"]
	
	return main_text_str


func get_text_by_lang(text: String, lang: String):
	var lang_text = JSON.parse_string(text)
	
	if lang_text and typeof(lang_text) == TYPE_DICTIONARY and lang in lang_text.keys():
		return lang_text[lang]
	else:
		return text


func get_characters():
	var nodes_js = get_nodes_js()
	if nodes_js and DCGUtils.CharacterNode in nodes_js:
		return get_nodes_js()[DCGUtils.CharacterNode]


func get_character_node_js_by_id(id: int):
	var chars = get_characters()
	if chars:
		for char_node in chars:
			if char_node["CharacterID"] == id:
				return char_node

	return null


func get_nodes_js():
	return self.data_js["Nodes"]


func get_connections_js() -> Array:
	return self.data_js["Connections"]


func get_input_port_type(node_js, to_port_id: int) -> int:
	return node_js["Inputs"][to_port_id]["Type"]


func get_output_port_type(node_js, from_port_id: int):
	return node_js["Outputs"][from_port_id]["Type"]


func get_startnode_by_id(start_node_id: int) -> NodeData:
	if DCGUtils.StartNode in self.data_js["Nodes"]:
		for node_js in self.data_js["Nodes"][DCGUtils.StartNode]:
			if node_js["StartID"] == start_node_id:
				return nodes_by_name[node_js["Name"]]
	
	return null

