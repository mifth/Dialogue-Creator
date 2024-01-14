class_name DCActionNode
extends DCBaseGraphNode


func get_action_name_node() -> LineEdit:
	return $VBoxContainer/HBoxContainer/TypeLineEdit


func get_action_text_node() -> TextEdit:
	return $VBoxContainer/ActionTextLineEdit


func GetNodeParamsJS():
	var params = GetNodeBaseParamsJS()
	
	params["ActionName"] = get_action_name_node().text
	params["ActionText"] = get_action_text_node().text
	
	return [params, DCGUtils.ActionNode]
