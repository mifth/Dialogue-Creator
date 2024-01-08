class_name DCTextNode
extends DCBaseGraphNode

@export var text_node_text_resource: Resource


func _on_add_text_button_pressed():
	var text_node = text_node_text_resource.instantiate() as DCDialogueNodeText
	
	text_node.DeleteDialogueText.connect(self.ClearPorts)
	text_node.UpDialogueText.connect(self.ReverseTextsUp)
	text_node.DownDialogueText.connect(self.ReverseTextsDown)

	add_child(text_node)
	set_slot( get_children().size() - 1, false, 1, Color.BURLYWOOD, true, 1, Color.BURLYWOOD)


func GetNodeParamsJS():
	var params = GetNodeBaseParamsJS()
	
	params["TextNodes"] = GetTextNodesJS()
	
	#params["Type"] = DCUtils.TextNode
	
	return [params, DCUtils.TextNode]
