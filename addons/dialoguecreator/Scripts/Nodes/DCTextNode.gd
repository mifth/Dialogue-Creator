class_name DCTextNode
extends DCBaseGraphNode



func _on_add_text_button_pressed():
	AddTextTextNode()

func AddTextTextNode() -> DCDialogueNodeText:
	return AddTextNode(false, 1, Color.BURLYWOOD, true, 1, Color.BURLYWOOD)


func GetNodeParamsJS():
	var params = GetNodeBaseParamsJS()
	
	params["TextSlots"] = GetTextNodesJS()
	
	return [params, DCGUtils.TextNode]
