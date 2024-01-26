class_name DCSetTextNode
extends DCBaseGraphNode


func _on_add_text_button_pressed():
	add_text_text_node()


func add_text_text_node() -> DCDialogueNodeText:
	return add_text_node(true, 1, Color.BURLYWOOD, true, 1, Color.BURLYWOOD)


func get_node_params_js():
	var params = get_node_base_params_js()
	
	params["TextSlots"] = get_text_nodes_js()
	
	return [params, DCGUtils.SetTextNode]
