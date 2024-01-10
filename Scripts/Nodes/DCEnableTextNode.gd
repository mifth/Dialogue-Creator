class_name DCEnableTextNode
extends DCBaseGraphNode


func GetNodeParamsJS():
	var params = GetNodeBaseParamsJS()
	
	return [params, DCUtils.EnableTextNode]
