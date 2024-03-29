class_name DCDialogueNode
extends DCBaseGraphNode


func _on_add_text_button_pressed():
	add_text_text_node()


func add_text_text_node() -> DCDialogueNodeText:
	return add_text_node(true, 1, Color.BURLYWOOD, true, 0, Color.WHITE)


func get_main_text() -> TextEdit:
	return $MainTextEdit as TextEdit


func get_characterID_spinBox() -> SpinBox:
	return $VBoxContainer/HBoxContainer/CharacterID


func get_node_params_js():
	var params = get_node_base_params_js()

	# Get Main Text
	var main_text = get_main_text()
	var main_text_dict = {}
	main_text_dict["Text"] = main_text.text
	params["MainText"] = main_text_dict
	
	var id_box = get_characterID_spinBox()
	if id_box.value >= 0:
		params["Character"] = {"Id": id_box.value as int}
	
	# Get Texts
	params["TextSlots"] = get_text_nodes_js()
	
	return [params, DCGUtils.DialogueNode]
