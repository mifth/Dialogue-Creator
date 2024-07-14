class_name DCGDialogueData
extends Object


# MAIN VARIABLES
var data_js: Dictionary
var live_nodes_js: Dictionary = {}  # Key is Node Name. Value is nodes_js which can be modified during a dialogue
var nodes_by_name: Dictionary = {}  # Key is Node Name. Value is NodeData.


# NodeData Object
class NodeData:
	var node_class_key: String  # Node Class Nmae
	var array_index: int  # Index in data_js["Nodes"][node_class_key] Array

	var from_node_conns := {}  # Key - int. Value - Array of int.
	var to_node_conns := {}  # Key - int. Value - Array of int.
	
	func fill_data(node_key: String, array_index: int):
		self.node_class_key = node_key
		self.array_index = array_index


func parse_js(data_js_str: String):
	self.data_js = JSON.parse_string(data_js_str)

	# Reset Main Variables
	self.live_nodes_js = {}
	self.nodes_by_name = {}
	
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
			
			var from_port = conn["from_port"] as int
			var to_port = conn["to_port"] as int
			
			# Add connections from_node
			var from_node_c = self.nodes_by_name[conn["from_node"]].from_node_conns
			if from_port not in from_node_c:
				from_node_c[from_port] = []
			from_node_c[from_port].append(i)
			
			# Add connections to_node
			var to_node_c = self.nodes_by_name[conn["to_node"]].to_node_conns
			if to_port not in to_node_c:
				to_node_c[to_port] = []
			to_node_c[to_port].append(i)


func get_node_js(node_data: NodeData):
	return get_nodes_js()[node_data.node_class_key][node_data.array_index]


func get_next_dialogue_node(the_node: NodeData, port_id: int) -> NodeData:

	return _get_dialogue_node_recursively(the_node, port_id, [])


func _get_dialogue_node_recursively(the_node: NodeData, port_id: int, 
									parsed_nodes: Array) -> NodeData:

	var dialogue_node: NodeData
	
	if port_id in the_node.from_node_conns:
		var node_data_port_id: Array = the_node.from_node_conns[port_id]

		if node_data_port_id:
			var conn = get_connections_js()[node_data_port_id[0]]  # Main Connection has only 1 output.
			var parse_node = self.nodes_by_name[conn["to_node"]] as DCGDialogueData.NodeData
			
			if parse_node not in parsed_nodes:
				parsed_nodes.append(parse_node)

				if parse_node.node_class_key in DCGUtils.dialogue_nodes_types:
					# Next Interactive Node Is Found!
					dialogue_node = parse_node

				else:
					# Change Texts it it's a Node which can do it.
					if (parse_node.node_class_key == DCGUtils.SetTextNode
						or parse_node.node_class_key == DCGUtils.EnableTextNode
						or parse_node.node_class_key == DCGUtils.HideTextNode):

						_change_live_texts(parse_node, [])

					
					# Try Getting Next Node
					var parse_node_js = get_nodes_js()[parse_node.node_class_key][parse_node.array_index]
					var parse_node_outputs = parse_node_js["Outputs"]

					if parse_node_outputs and parse_node_outputs[0]["Type"] == 0:
						dialogue_node = _get_dialogue_node_recursively(parse_node, 0, parsed_nodes)
	
	return dialogue_node


func get_live_node_js(the_node: NodeData):

	if the_node.node_class_key in DCGUtils.live_nodes_types:
		var live_node_js : Dictionary
		var node_js = get_nodes_js()[the_node.node_class_key][the_node.array_index]
		
		if node_js["Name"] not in self.live_nodes_js.keys():
		
			live_node_js = node_js.duplicate(true)
			self.live_nodes_js[node_js["Name"]] = live_node_js

			_check_default_live_text(the_node, live_node_js)

		else:
			live_node_js = self.live_nodes_js[node_js["Name"]]

		return live_node_js

	return null


func _check_default_live_text(node_to_check: NodeData, live_node_js):
	if node_to_check.node_class_key in DCGUtils.live_nodes_types and node_to_check.to_node_conns:
		for port_id in node_to_check.to_node_conns.keys():
			var port_type = get_input_port_type(live_node_js, port_id)
		
			if port_type == 1:
				var port_conns = node_to_check.to_node_conns[port_id]

				for conn_ids in port_conns:
					var conn = get_connections_js()[conn_ids]
					var from_node = self.nodes_by_name[conn["from_node"]] as NodeData
					var from_port = conn["from_port"]

					# In a case if it's RerouteTextNode Node we get a node Reversely 
					if from_node.node_class_key == DCGUtils.RerouteTextNode:
						var prev_conn = get_conn_from_reroute_text_reversed_recursively(from_node, [])
						if prev_conn:
							from_node = nodes_by_name[prev_conn["from_node"]] as NodeData
							from_port = prev_conn["from_port"]

					# Change Default Text
					if from_node.node_class_key == DCGUtils.TextNode:
						var from_node_js = get_node_js(from_node)
						var from_text_slot = get_text_slot_by_port(from_node, from_node_js, from_port, false)

						var to_text_slot = get_text_slot_by_port(node_to_check, live_node_js, port_id, true)

						if from_text_slot and to_text_slot:
							to_text_slot["LiveText"] = from_text_slot["Text"]

						break


# Get Connection From RerouteText Node Reversed
func get_conn_from_reroute_text_reversed_recursively(rerote_text_node: NodeData, parsed_nodes: Array):
	var reversed_conn

	if rerote_text_node.to_node_conns:
		var prev_con_id = rerote_text_node.to_node_conns[0][0]
		var prev_con = get_connections_js()[prev_con_id]

		var prev_node = nodes_by_name[prev_con["from_node"]] as NodeData

		if prev_node not in parsed_nodes:
			parsed_nodes.append(prev_node)

			if prev_node.node_class_key == DCGUtils.RerouteTextNode:
				reversed_conn = get_conn_from_reroute_text_reversed_recursively(prev_node, parsed_nodes)
			else:
				reversed_conn = prev_con
	
	return reversed_conn


# Only for the SetTextNode, EnableTextNode, HideTextNode.
# parent_from_node and parent_from_port are parent node. It's used in case if we have got a RerouteTextNode node.
func _change_live_texts(from_node: NodeData, parsed_nodes: Array, parent_from_node: NodeData = null, parent_from_port: int = 1000):
	for from_port in from_node.from_node_conns.keys():
		# if from_port == 0:
		# 	continue
		
		var from_node_js = get_live_node_js(from_node)
		if not from_node_js:
			from_node_js = get_node_js(from_node)
		
		# pass if Port Type = 0. It's a main port
		if from_node_js["Outputs"][from_port]["Type"] == 0:
			continue

		var conns_ids = from_node.from_node_conns[from_port]
		
		for conn_id in conns_ids:
			var conn = get_connections_js()[conn_id]
			var to_node = self.nodes_by_name[conn["to_node"]] as NodeData
			var to_port = conn["to_port"]

			if to_node not in parsed_nodes:
				parsed_nodes.append(to_node)

				if to_node.node_class_key in DCGUtils.live_nodes_types:
					var to_live_node_js = get_live_node_js(to_node)
					
					if parent_from_node:
						_change_live_text(parent_from_node, parent_from_port, to_node, to_port)
					else:
						_change_live_text(from_node, from_port, to_node, to_port)

				elif to_node.node_class_key == DCGUtils.RerouteTextNode:
					if parent_from_node:
						_change_live_texts(to_node, parsed_nodes, parent_from_node, parent_from_port)
					else :
						_change_live_texts(to_node, parsed_nodes, from_node, from_port)


# from_node_js can be node_js or live_node_js!!!!
func _change_live_text(from_node: NodeData, from_port: int, to_node: NodeData, to_port: int):

	# Get From_Node Text
	var from_text

	# Get from_live_node or from_node
	var from_xnode_js = get_live_node_js(from_node)
	if !from_xnode_js:
		from_xnode_js = get_node_js(from_node) as Dictionary

	# Get to_live_node_js
	var to_live_node_js := get_live_node_js(to_node) as Dictionary

	if !to_live_node_js:
		print("to_live_node_js is null: " + str(to_node.node_class_key) + ", " + str(to_node.array_index))
		return

	if from_node.node_class_key == DCGUtils.SetTextNode:
		if from_xnode_js["TextSlots"]:
			var from_text_slot = get_text_slot_by_port(from_node, from_xnode_js, from_port, false)
			from_text = get_text_of_text_slot(from_text_slot)
		else:
			from_text = "NO TEXT"

	var to_text_slot = get_text_slot_by_port(to_node, to_live_node_js, to_port, true)

	if to_node.node_class_key == DCGUtils.DialogueNode: 
		# Main Text
		if to_port == 1:
			# Set New Live Text
			if from_node.node_class_key == DCGUtils.SetTextNode:
				to_text_slot["LiveText"] = from_text

		# Text Slot
		elif to_port > 1:
			# Set New Live Text
			if from_node.node_class_key == DCGUtils.SetTextNode:
				to_text_slot["LiveText"] = from_text

			elif from_node.node_class_key == DCGUtils.EnableTextNode:
				var enable_text = true

				if from_port == 2:
					enable_text = false

				to_text_slot["EnableLiveText"] = enable_text

			elif from_node.node_class_key == DCGUtils.HideTextNode:
				var hide_text = true

				if from_port == 2:
					hide_text = false

				to_text_slot["HideLiveText"] = hide_text

	elif to_node.node_class_key == DCGUtils.ActionNode:
		# Main Text
		if to_port == 1:
			# Set New Live Text
			if from_node.node_class_key == DCGUtils.SetTextNode:
				to_text_slot["LiveText"] = from_text

	elif to_node.node_class_key == DCGUtils.SetTextNode:
		# Main Text
		if to_port > 0:
			# Set New Live Text
			if from_node.node_class_key == DCGUtils.SetTextNode:
				to_text_slot["LiveText"] = from_text


func get_text_slot_by_port(the_node: NodeData, node_js, port_id: int, is_input: bool):
	if the_node.node_class_key == DCGUtils.ActionNode:
		if is_input and port_id == 1:
			return node_js["ActionText"]
		
	elif the_node.node_class_key == DCGUtils.TextNode:
		if not is_input:

			if port_id == 0 and node_js["TextSlots"]:
				var slots_size = node_js["TextSlots"].size()

				return node_js["TextSlots"][randi_range(0, slots_size - 1)]

			elif port_id > 0:
				return node_js["TextSlots"][port_id - 1]
	
	elif the_node.node_class_key == DCGUtils.DialogueNode:
		if is_input:

			if port_id == 1:
				return node_js["MainText"]
			elif port_id > 1:
				return node_js["TextSlots"][port_id - 2]
		
		else:
			if port_id == 0:
				return node_js["MainText"]
			
			elif port_id > 0:
				return node_js["TextSlots"][port_id - 1]
	
	elif the_node.node_class_key == DCGUtils.SetTextNode:
		if is_input:
			if port_id > 0:
				return node_js["TextSlots"][port_id - 1]
		
		else:
			if port_id == 1 and node_js["TextSlots"]:
				var slots_size = node_js["TextSlots"].size()

				return node_js["TextSlots"][randi_range(0, slots_size - 1)]

			elif port_id > 1:
				return node_js["TextSlots"][port_id - 2]


func get_text_of_text_slot(main_text_js: Dictionary):
	var main_text_str: String

	if "LiveText" in main_text_js:
		main_text_str = main_text_js["LiveText"]
	else:
		main_text_str = main_text_js["Text"]

	return main_text_str


func get_text_by_lang(text: String, lang: String):
	var lang_text = JSON.parse_string(text)
	
	if lang_text and typeof(lang_text) == TYPE_DICTIONARY and lang in lang_text:
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
				return self.nodes_by_name[node_js["Name"]]
	
	return null

