class_name DCDialogueNode
extends DCBaseGraphNode


func _on_add_text_button_pressed():
	AddTextTextNode()


func AddTextTextNode() -> DCDialogueNodeText:
	return AddTextNode(true, 1, Color.BURLYWOOD, true, 0, Color.WHITE)


func GetMainText() -> TextEdit:
	return $MainTextEdit as TextEdit


func GetCharacterIDSpinBox() -> SpinBox:
	return $VBoxContainer/HBoxContainer/CharacterID


func GetNodeParamsJS():
	var params = GetNodeBaseParamsJS()

	# Get Main Text
	var main_text = GetMainText()
	var main_text_dict = {}
	main_text_dict["Text"] = main_text.text
	params["MainText"] = main_text_dict
	
	params["CharacterID"] = GetCharacterIDSpinBox().value as int
	
	# Get Texts
	params["TextSlots"] = GetTextNodesJS()
	
	return [params, DCUtils.DialogueNode]
