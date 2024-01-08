class_name DCRerouteNode
extends DCBaseGraphNode


func GetNodeParamsJS():
	var params = GetNodeBaseParamsJS()
	
	#params["Type"] = DCUtils.RerouteNode
	
	return [params, DCUtils.RerouteNode]
