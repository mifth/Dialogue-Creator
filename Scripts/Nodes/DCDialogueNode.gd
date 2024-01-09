class_name DCDialogueNode
extends DCBaseGraphNode


func _on_add_text_button_pressed():
	AddTextTextNode()


func AddTextTextNode() -> DCDialogueNodeText:
	return AddTextNode(true, 1, Color.BURLYWOOD, true, 0, Color.WHITE)


func GetNodeParamsJS():
	var params = GetNodeBaseParamsJS()

	# Get Main Text
	var main_text = $MainTextEdit as TextEdit
	params["MainText"] = main_text.text
	
	var char_id = $VBoxContainer/HBoxContainer/CharacterID as SpinBox
	params["CharacterID"] = char_id.value as int
	
	# Get Texts
	params["TextSlots"] = GetTextNodesJS()
	
	#params["Type"] = DCUtils.DialogueNode
	
	return [params, DCUtils.DialogueNode]
