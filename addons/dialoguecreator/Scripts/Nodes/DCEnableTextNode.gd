class_name DCEnableTextNode
extends DCBaseGraphNode


func get_node_params_js():
	var params = get_node_base_params_js()
	
	return [params, DCGUtils.EnableTextNode]
