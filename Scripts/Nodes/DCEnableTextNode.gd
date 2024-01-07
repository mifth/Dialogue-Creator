class_name DCEnableTextNode
extends DCBaseGraphNode


func GetNodeParamsJS():
	var params = GetNodeBaseParamsJS()
	
	params["Type"] = "DCEnableTextNode"
	
	return params
