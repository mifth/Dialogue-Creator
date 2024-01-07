class_name DCRerouteNode
extends DCBaseGraphNode


func GetNodeParamsJS():
	var params = GetNodeBaseParamsJS()
	
	params["Type"] = "DCRerouteNode"
	
	return params
