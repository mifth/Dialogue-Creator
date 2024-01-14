class_name DCGDialogueData
extends Object


var data_js: Dictionary
var nodes_by_name: Dictionary = {}


class NodeData extends Object:
	var node_type: String
	var array_index: int
	
	func fill_data(node_type: String, array_index: int):
		self.node_type = node_type
		self.array_index = array_index
	

func parse_js(date_js_str: String):
	self.data_js = JSON.parse_string(date_js_str)
	
	if self.data_js:
		var nodes_js: Dictionary = self.data_js["Nodes"]
		
		for nodes_key in nodes_js.keys():
			var certain_nodes_js : Array = nodes_js[nodes_key]
			
			for i in range(certain_nodes_js.size()):
				var node_js = certain_nodes_js[i]
				
				var new_node_data = self.NodeData.new()
				new_node_data.fill_data(nodes_key, i)
				
				self.data_js[node_js["Name"]] = new_node_data




