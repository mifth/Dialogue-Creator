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


func get_next_interactive_node(the_node: NodeData, port_id: int) -> NodeData:
	var next_node = the_node
	#var interactive_node

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
					next_node = nodes_by_name[conn["to_node"]] as DCGDialogueData.NodeData
					
					# Next Interactive Node Is Found!
					if next_node.node_class_key in DCGUtils.InteractiveNodes:
						return next_node
				else:
					break
			else:
				break
		else:
			break

	return null


func get_text_by_lang(text: String, lang: String):
	var lang_text = JSON.parse_string(text)
	
	if lang_text and typeof(lang_text) == TYPE_DICTIONARY and lang in lang_text.keys():
		return lang_text[lang]


func get_characters():
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

