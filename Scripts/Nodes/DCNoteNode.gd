class_name DCNoteNode
extends DCBaseGraphNode


func GetNodeParamsJS():
	var params = GetNodeBaseParamsJS()
	
	params["NoteName"] = $VBoxContainer/HBoxContainer/NoteNameLineEdit.text
	params["NoteText"] = $VBoxContainer/NoteTextEdit.text
	
	#params["Type"] = DCUtils.NoteNode
	
	return [params, DCUtils.NoteNode]
