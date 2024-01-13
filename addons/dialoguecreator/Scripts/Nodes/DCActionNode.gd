class_name DCActionNode
extends DCBaseGraphNode

@onready var _action_name_node: LineEdit

func _ready():
	_action_name_node = $VBoxContainer/HBoxContainer/ActionNameLineEdit as LineEdit


func GetNodeParamsJS():
	var params = GetNodeBaseParamsJS()
	
	params["ActionName"] = _action_name_node.text
	
	return [params, DCGUtils.ActionNode]
