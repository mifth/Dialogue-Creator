extends Node


var dc_data: DCGDialogueData  # Main dialogue data
var live_nodes_js: Dictionary = {}  # nodes_js which can be modified during a dialogue

var play_start_id: int
var play_lang: String

const text_button: Resource = preload("res://addons/dialoguecreator/Assets/PlayScene/TextSlotButton.tscn")
const action_texture: Resource = preload("res://addons/dialoguecreator/Resources/Action/Action.png")

var current_dialogue: DCGDialogueData.NodeData


func _enter_tree():
	var scene = get_main_graph()
	var data_js = DCParse.get_data_js(get_main_graph())  # Data from nodes
	var data_js_str = JSON.stringify(data_js)  # Converted to string
	
	self.dc_data = DCGDialogueData.new()  # New main data
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
	var next_dialogue_node = self.dc_data.get_next_dialogue_node(self.current_dialogue, port_id, self.live_nodes_js)

	if next_dialogue_node:
		self.current_dialogue = next_dialogue_node

		# Set up Dialogue Node
		if next_dialogue_node.node_class_key == DCGUtils.DialogueNode:
			set_up_dialogue_node(next_dialogue_node)
		elif next_dialogue_node.node_class_key == DCGUtils.ActionNode:
			set_up_action_node(next_dialogue_node)
			
	else:
		queue_free()


func add_text_button(text: String, port_id: int) -> DCTextSlotButton:
	var text_b = self.text_button.instantiate() as DCTextSlotButton
	text_b.out_port_id = port_id
	text_b.next_node_button.connect(run_next_dialogue)
	
	text_b.text = text
	get_text_buttons_container().add_child(text_b)

	return text_b


func set_up_action_node(d_node: DCGDialogueData.NodeData):
	var live_node_js = self.dc_data.get_live_node_js(d_node, self.live_nodes_js)

	var action_text = ""
	var name_js = live_node_js["ActionName"]
	var text_js = self.dc_data.get_text_of_text_slot(live_node_js["ActionText"])
	
	if name_js:
		action_text = name_js
	if text_js:
		action_text += "\n" + text_js
	
	get_main_text_edit().text = action_text
	get_char_texture_edit().texture = self.action_texture
	
	if "ActionPorts" in live_node_js:
		var ports_texts = live_node_js["ActionPorts"]["Texts"]
		for i in range(ports_texts.size()):
			add_text_button(ports_texts[i], i)

	# add_text_button("True", 0)
	# add_text_button("False", 1)


func set_up_dialogue_node(d_node: DCGDialogueData.NodeData):
	var live_node_js = self.dc_data.get_live_node_js(d_node, self.live_nodes_js)

	# Get Text In Text JS
	var main_text_js = live_node_js["MainText"]
	var main_text_str = self.dc_data.get_text_of_text_slot(main_text_js)
	
	# Set Up Main Text
	var main_text = self.dc_data.get_text_by_lang(main_text_str, self.play_lang)
	if main_text:
		get_main_text_edit().text = main_text

	# Set Up Text Slots
	if not live_node_js["TextSlots"]:
		add_text_button("> > > > >", 0)
	else :
		for i in range(live_node_js["TextSlots"].size()):
			var text_slot_js = live_node_js["TextSlots"][i]

			# If Text Hidden
			if "HideLiveText" in text_slot_js and text_slot_js["HideLiveText"]:
				continue

			var live_text = self.dc_data.get_text_of_text_slot(text_slot_js)
			var final_text = self.dc_data.get_text_by_lang(live_text, self.play_lang)

			var text_button: DCTextSlotButton
			if final_text:
				text_button = add_text_button(final_text, i + 1)
			else:
				text_button = add_text_button("No Text!", i + 1)

			# If Text Disabled
			if "EnableLiveText" in text_slot_js:
				if not text_slot_js["EnableLiveText"]:
					text_button.next_node_button.disconnect(run_next_dialogue)

					text_button.text = ""
					text_button.push_color(Color.DIM_GRAY)
					text_button.add_text(final_text)
					text_button.pop()

	# Set Up Character
	if "Character" in live_node_js:
		var char_id = live_node_js["Character"]["Id"]
		
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
	
	var texts = get_text_buttons_container()
	DCGUtils.remove_children(texts)


func get_char_name_edit() -> TextEdit:
	return $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer2/CharacterNameTextEdit


func get_char_texture_edit() -> TextureRect:
	return $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer2/CharacterTextureRect


func get_main_text_edit() -> TextEdit:
	return $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/Panel/VBoxContainer2/HBoxContainer2/MainTextEdit


func get_start_name_edit() -> TextEdit:
	return $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/Panel/VBoxContainer2/HBoxContainer/StartNameTextEdit


func get_text_buttons_container() -> VBoxContainer:
	return $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/TextsVBoxContainer


func _on_close_button_pressed():
	queue_free()


func _exit_tree():
	queue_free()
