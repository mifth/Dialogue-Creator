class_name DCSetTextNode
extends DCBaseGraphNode


func _on_add_text_button_pressed():
	AddTextTextNode()


func AddTextTextNode() -> DCDialogueNodeText:
	return AddTextNode(true, 1, Color.BURLYWOOD, true, 1, Color.BURLYWOOD)


func GetNodeParamsJS():
	var params = GetNodeBaseParamsJS()
	
	params["TextSlots"] = GetTextNodesJS()
	
	#params["Type"] = DCUtils.SetTextNode
	
	return [params, DCUtils.SetTextNode]
