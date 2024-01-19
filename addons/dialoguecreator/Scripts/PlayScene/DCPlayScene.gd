extends Node


var dc_data: DCGDialogueData
var play_start_id: int
var play_lang: String

var text_button := preload("res://addons/dialoguecreator/Assets/PlayScene/TextSlotButton.tscn")

var current_dialogue: DCGDialogueData.NodeData


func _enter_tree():
	var scene = get_main_graph()
	var data_js = DCParse.GetDataJS(get_main_graph())
	var data_js_str = JSON.stringify(data_js)
	
	self.dc_data = DCGDialogueData.new()
	self.dc_data.parse_js(data_js_str)
	
	clear_play_scene()
	
	self.play_start_id = scene.play_start_id_spin.value as int
	self.play_lang = scene.play_lang_edit.text

	# Start
	var start_node = self.dc_data.get_startnode_by_id(self.play_start_id)
	if start_node:
		self.current_dialogue = start_node
		
		# Set up StartName
		get_start_name_edit().text = self.dc_data.get_node_js(start_node)["StartName"]
		
		run_next_dialogue(0)


func get_main_graph() -> DCGraph:
	return get_tree().current_scene


func run_next_dialogue(port_id: int):
	clear_dialogue()

	# Get Next Interactive Node
	var next_interactive_node = self.dc_data.get_next_interactive_node(self.current_dialogue, port_id)

	if next_interactive_node:
		self.current_dialogue = next_interactive_node
		var next_node_js = self.dc_data.get_node_js(next_interactive_node)

		# Set up Dialogue Node
		if next_interactive_node.node_class_key == DCGUtils.DialogueNode:
			set_up_dialogue_node(next_interactive_node)

	else:
		queue_free()


func add_text_button(text: String, port_id: int):
	var text_b = self.text_button.instantiate() as DCTextSlotButton
	text_b.out_port_id = port_id
	text_b.next_node_button.connect(run_next_dialogue)
	
	text_b.text = text
	get_texts_container().add_child(text_b)


func set_up_dialogue_node(d_node: DCGDialogueData.NodeData):
	var node_js = self.dc_data.get_node_js(d_node)

	var main_text_str = node_js["MainText"]["Text"]
	var main_text = self.dc_data.get_text_by_lang(main_text_str, self.play_lang)

	if main_text:
		get_main_text_edit().text = main_text

	if not node_js["TextSlots"]:
		add_text_button("> > > > >", 0)
	else :
		for i in range(node_js["TextSlots"].size()):
			var text_slot_text = self.dc_data.get_text_by_lang(node_js["TextSlots"][i]["Text"], self.play_lang)
			if text_slot_text:
				add_text_button(text_slot_text, i + 1)
			else:
				add_text_button("", i + 1)

	if "Character" in node_js.keys():
		var char_id = node_js["Character"]["Id"]
		
		var char_node = self.dc_data.get_character_node_js_by_id(char_id)
		if char_node:
			get_char_name_edit().text = char_node["CharacterName"]
			#get_char_texture_edit().texture = null
			#print(char_node["CharacterTexture"])
			var icons = get_main_graph().graph.get_node(char_node["Name"]) as DCCharacterNode
			get_char_texture_edit().texture = icons.GetItemsIcons().get_item_icon(char_node["CharacterTexture"])


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
