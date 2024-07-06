class_name DCCharacterNode
extends DCBaseGraphNode 


func _enter_tree():
	SetUniqueID(0)


func _ready():
	var lst = GetItemsIcons()
	#ResourceLoader.exists("res://sprite.tscn")
	var char_str = "res://addons/dialoguecreator/Resources/Characters/char"
	var other_str = "res://addons/dialoguecreator/Resources/Characters/other"
	

	for res_item_str in [char_str, other_str]:
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


func get_node_params_js():
	var params = get_node_base_params_js(false)
	
	params["CharacterName"] = GetCharacterNameLineEdit().text
	
	params["CharacterID"] = GetCharacterIDSpinBox().value as int
	
	var lst = GetItemsIcons()
	
	var texture_items = lst.get_selected_items()
	if texture_items:
		params["CharacterTexture"] = lst.get_selected_items()[0] as int
	else:
		params["CharacterTexture"] = 0
	
	return [params, DCGUtils.CharacterNode]


func GetIDs(nodes):
	var ids = []

	for node in nodes:
		if is_instance_of(node, DCCharacterNode) and node != self:
			ids.append(node.GetCharacterIDSpinBox().value as int)

	return ids


func SetUniqueID(start_value: int):
	var nodes = get_parent().get_children()
	GetCharacterIDSpinBox().value = DCGUtils.generate_id(GetIDs(nodes), start_value)


func _on_character_id_value_changed(value):
	SetUniqueID(value)
