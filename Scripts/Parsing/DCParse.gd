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
	
	

