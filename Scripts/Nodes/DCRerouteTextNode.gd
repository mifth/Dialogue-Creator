class_name DCRerouteTextNode
extends DCBaseGraphNode


func GetNodeParamsJS():
	var params = GetNodeBaseParamsJS()
	
	#params["Type"] = DCUtils.RerouteTextNode
	
	return [params, DCUtils.RerouteTextNode]


