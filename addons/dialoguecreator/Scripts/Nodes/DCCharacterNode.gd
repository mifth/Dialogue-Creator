class_name DCCharacterNode
extends DCBaseGraphNode 


func _ready():
	var lst = GetItemsIcons()
	#ResourceLoader.exists("res://sprite.tscn")
	var girl_str = "res://addons/dialoguecreator/Resources/Characters/girl"
	var man_str = "res://addons/dialoguecreator/Resources/Characters/man"
	

	for res_item_str in [girl_str, man_str]:
		var i_val = 0
		# Man
		while true:
			var res_str = res_item_str + str(i_val + 1) + ".png"
			if ResourceLoader.exists(res_str):
				var man = load(res_str)
				lst.add_item("", man)
				
				i_val += 1
			else:
				break



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
	
	var lst = GetItemsIcons()
	params["CharacterTexture"] = lst.get_selected_items()[0]
	
	return [params, DCUtils.CharacterNode]
