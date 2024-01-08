class_name DCEnableTextNode
extends DCBaseGraphNode


func GetNodeParamsJS():
	var params = GetNodeBaseParamsJS()
	
	#params["Type"] = DCUtils.EnableTextNode
	
	return [params, DCUtils.EnableTextNode]
