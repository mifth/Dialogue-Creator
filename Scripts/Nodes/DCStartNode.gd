class_name DCStartNode
extends DCBaseGraphNode


func GetNodeParamsJS():
	var params = GetNodeBaseParamsJS()
	
	var id_node = $HBoxContainer/StartSpinBox as SpinBox
	params["StartID"] = id_node.value as int
	
	params["Type"] = "DCStartNode"
	
	return params
