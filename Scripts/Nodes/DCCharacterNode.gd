class_name DCCharacterNode
extends DCBaseGraphNode 


func GetItemsIcons() -> ItemList:
	return $VBoxContainer/CharactersItemList


func GetCharacterIDSpinBox() -> SpinBox:
	return $VBoxContainer/HBoxContainer2/CharacterID


func GetCharacterNameLineEdit() -> LineEdit:
	return $VBoxContainer/HBoxContainer/CharacterNameLineEdit


func GetNodeParamsJS():
	var params = GetNodeBaseParamsJS()
	
	params["CharacterName"] = GetCharacterNameLineEdit().text
	
	params["CharacterID"] = GetCharacterIDSpinBox().value as int
	
	return [params, DCUtils.CharacterNode]
