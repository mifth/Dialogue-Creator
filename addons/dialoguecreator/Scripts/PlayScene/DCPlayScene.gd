extends Node


var dc_data: DCGDialogueData


func _enter_tree():
	var graph = get_tree().current_scene.graph
	var data_js = DCParse.GetDataJS(graph)
	var data_js_str = JSON.stringify(data_js)
	
	self.dc_data = DCGDialogueData.new()
	self.dc_data.parse_js(data_js_str)
	
	clear_play_scene()


func clear_play_scene():
	var start_name = get_start_name_edit()
	start_name.text = ""
	
	clear_dialogue()


func clear_dialogue():
	var char_name = get_char_name_edit()
	char_name.text = ""

	var char_texture = get_char_texture_edit()
	char_texture.texture = null
	
	var main_text = get_main_text_edit()
	main_text.text = ""
	
	var texts = get_texts_container()
	DCGUtils.remove_children(texts)


func get_char_name_edit() -> TextEdit:
	return $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer2/CharacterNameTextEdit


func get_char_texture_edit() -> TextureRect:
	return $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer2/CharacterTextureRect


func get_main_text_edit() -> TextEdit:
	return $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/Panel/VBoxContainer2/MainTextEdit


func get_start_name_edit() -> TextEdit:
	return $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/Panel/VBoxContainer2/HBoxContainer/StartNameTextEdit


func get_texts_container() -> VBoxContainer:
	return $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/TextsVBoxContainer


func _on_close_button_pressed():
	queue_free()


func _exit_tree():
	queue_free()
