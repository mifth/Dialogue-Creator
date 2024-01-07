class_name DCNoteNode
extends DCBaseGraphNode


func GetNodeParamsJS():
	var params = GetNodeBaseParamsJS()
	
	params["NoteName"] = $VBoxContainer/HBoxContainer/NoteNameLineEdit.text
	params["NoteText"] = $VBoxContainer/NoteTextEdit.text
	
	params["Type"] = "DCNoteNode"
	
	return params
