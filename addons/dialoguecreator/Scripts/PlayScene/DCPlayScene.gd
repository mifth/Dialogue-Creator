extends Node


var dc_data: DCGDialogueData
var play_start_id: int
var play_lang: String


func _enter_tree():
	var scene = get_tree().current_scene as DCGraph
	var data_js = DCParse.GetDataJS(scene.graph)
	var data_js_str = JSON.stringify(data_js)
	
	self.dc_data = DCGDialogueData.new()
	self.dc_data.parse_js(data_js_str)
	
	clear_play_scene()
	
	self.play_start_id = scene.play_start_id_spin.value as int
	self.play_lang = scene.play_lang_edit.text

	# Start
	var start_node = self.dc_data.get_startnode_by_id(self.play_start_id)
	if start_node:
		# Set up StartName
		get_start_name_edit().text = dc_data.get_node_js(start_node)["StartName"]

		# Get Next Interactive Node
		var next_interactive_node = dc_data.get_next_interactive(start_node)
		if next_interactive_node:
			# Set up Dialogue Node
			if next_interactive_node.node_class_key == DCGUtils.DialogueNode:
				set_dialogue_node(next_interactive_node)


func set_dialogue_node(d_node: DCGDialogueData.NodeData):
	var main_text_str = self.dc_data.get_node_js(d_node)["MainText"]["Text"]
	var main_text = self.dc_data.get_text_by_lang(main_text_str, self.play_lang)
	if main_text:
		get_main_text_edit().text = main_text


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
