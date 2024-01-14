class_name DCActionNode
extends DCBaseGraphNode


func get_action_text_node() -> TextEdit:
	return $VBoxContainer/ActionNameLineEdit


func GetNodeParamsJS():
	var params = GetNodeBaseParamsJS()
	
	params["ActionText"] = get_action_text_node().text
	
	return [params, DCGUtils.ActionNode]
