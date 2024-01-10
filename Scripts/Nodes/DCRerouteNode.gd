class_name DCRerouteNode
extends DCBaseGraphNode


func GetNodeParamsJS():
	var params = GetNodeBaseParamsJS()
	
	return [params, DCUtils.RerouteNode]
