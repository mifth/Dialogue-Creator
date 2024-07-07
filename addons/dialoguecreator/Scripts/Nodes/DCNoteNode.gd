class_name DCNoteNode
extends DCBaseGraphNode


func get_node_params_js():
	var params = get_node_base_params_js(false, false)
	
	params["NoteName"] = $VBoxContainer/HBoxContainer/NoteNameLineEdit.text
	params["NoteText"] = $VBoxContainer/NoteTextEdit.text
	
	return [params, DCGUtils.NoteNode]
