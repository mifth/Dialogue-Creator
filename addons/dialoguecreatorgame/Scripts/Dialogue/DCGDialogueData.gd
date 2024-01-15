class_name DCGDialogueData
extends Object


var data_js: Dictionary
var nodes_by_name: Dictionary = {}


class NodeData:
	var node_class_key: String  # Node Class Nmae
	var array_index: int  # Index in data_js["Nodes"][node_class_key] Array
	
	var from_node_conns: Array[int] = []
	var to_node_conns: Array[int] = []
	
	func fill_data(node_key: String, array_index: int):
		self.node_class_key = node_key
		self.array_index = array_index

	func get_node_js():
		self.data_js[self.node_class_key][self.array_index]


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
			
			self.nodes_by_name[conn["from_node"]].from_node_conns.append(i)
			self.nodes_by_name[conn["to_node"]].to_node_conns.append(i)


func get_nodes_js():
	return self.data_js["Nodes"]


func get_connections_js() -> Array:
	return self.data_js["Connections"]


# Returns Next Node and Input Port
func get_next_node_by_port(from_node_name: String, from_port_id: int):
	var node_data = self.nodes_by_name[from_node_name] as NodeData
	var port_type = get_output_port_type(node_data.get_node_js(), from_port_id)

	if port_type == 0:
		for conn in get_connections_js():
			if conn["from_node"] == from_node_name and conn["from_port"] == from_port_id:
				return [conn["to_node"], conn["to_port"]]
	else:
		print("Port Type is not 0 in " +  from_node_name)


func get_input_port_type(node_js, to_port_id: int):
	return node_js["Inputs"][to_port_id]["Type"]


func get_output_port_type(node_js, from_port_id: int):
	return node_js["Outputs"][from_port_id]["Type"]


func get_startnode_by_id(start_node_id: int):
	for node_js in self.data_js["Nodes"][DCGUtils.StartNode]:
		if node_js["StartID"] == start_node_id:
			return node_js

