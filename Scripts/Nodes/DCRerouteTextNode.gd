class_name DCRerouteTextNode
extends DCBaseGraphNode


func GetNodeParamsJS():
	var params = GetNodeBaseParamsJS()
	
	return [params, DCUtils.RerouteTextNode]

