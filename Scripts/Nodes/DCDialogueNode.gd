class_name DCDialogueNode
extends DCBaseGraphNode

@onready @export var text_node_text_resource: Resource


func _on_add_text_button_pressed():
	var text_node = text_node_text_resource.instantiate() as DCDialogueNodeText
	
	text_node.DeleteDialogueText.connect(self.ClearPorts)
	text_node.UpDialogueText.connect(self.ReverseTextsUp)
	text_node.DownDialogueText.connect(self.ReverseTextsDown)

	add_child(text_node)
	set_slot( get_children().size() - 1, true, 1, Color.BURLYWOOD, true, 0, Color.WHITE)


func GetNodeParamsJS():
	var params = GetNodeBaseParamsJS()

	# Get Main Text
	var main_text = $MainTextEdit as TextEdit
	params["MainText"] = main_text.text
	
	var char_id = $VBoxContainer/HBoxContainer/CharacterID as SpinBox
	params["CharacterID"] = char_id.value as int
	
	# Get Texts
	params["TextNodes"] = GetTextNodesJS()
	
	#params["Type"] = DCUtils.DialogueNode
	
	return [params, DCUtils.DialogueNode]
