class_name DCHideTextNode
extends DCBaseGraphNode


func GetNodeParamsJS():
	var params = GetNodeBaseParamsJS()
	
	params["Type"] = "DCHideTextNode"
	
	return params
