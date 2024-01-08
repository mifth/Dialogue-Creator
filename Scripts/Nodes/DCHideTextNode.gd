class_name DCHideTextNode
extends DCBaseGraphNode


func GetNodeParamsJS():
	var params = GetNodeBaseParamsJS()
	
	#params["Type"] = DCUtils.HideTextNode
	
	return [params, DCUtils.HideTextNode]
