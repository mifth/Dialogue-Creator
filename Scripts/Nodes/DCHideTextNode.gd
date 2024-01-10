class_name DCHideTextNode
extends DCBaseGraphNode


func GetNodeParamsJS():
	var params = GetNodeBaseParamsJS()
	
	return [params, DCUtils.HideTextNode]
