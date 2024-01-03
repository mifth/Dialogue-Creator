class_name DCParse
extends Object


static func SaveJS(graph: GraphEdit):
	var main_js = {}
	var nodes_js = {}
	var conns_js = []
	
	var action_nodes = []
	var dialogue_nodes = []
	var enable_text_nodes = []
	var hide_text_nodes = []
	var note_nodes = []
	var reroute_nodes = []
	var reroute_text_nodes = []
	var set_text_nodes = []
	var start_nodes = []
	var text_nodes = []
	
	main_js["Nodes"] = nodes_js
	main_js["Connections"] = conns_js
	
	nodes_js["Action"] = action_nodes
	nodes_js["Dialogue"] = dialogue_nodes
	nodes_js["EnableText"] = enable_text_nodes
	nodes_js["HideText"] = hide_text_nodes
	nodes_js["Note"] = note_nodes
	nodes_js["Reroute"] = reroute_nodes
	nodes_js["RerouteText"] = reroute_text_nodes
	nodes_js["SetText"] = set_text_nodes
	nodes_js["Start"] = start_nodes
	nodes_js["Text"] = text_nodes
	
	for node in graph.get_children():
		#var graph_nd = node as GraphNode
		
		if node.get_class() == "DCActionNode":
			pass
