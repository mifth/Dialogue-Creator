extends Node

var dc_data: DCGDialogueData  # Main dialogue data
var live_nodes_js: Dictionary = {}  # nodes_js which can be modified during a dialogue

var current_dialogue: DCGDialogueData.NodeData

@export var json_file = "res://Test/DialogueTest.json"


func _ready():
	var text_js = FileAccess.get_file_as_string(json_file)

	self.dc_data = DCGDialogueData.new()  # New main data
	self.dc_data.parse_js(text_js)

	# Start
	var start_node = self.dc_data.get_startnode_by_id(0) as DCGDialogueData.NodeData

	if start_node:
		self.current_dialogue = start_node
		var start_node_js = self.dc_data.get_node_js(start_node)
		
		print("Start Node: ", start_node_js["Name"])
		print_start_node(start_node_js)

		var port_to_get = 0
		# Do 10 iterations to get a dialogue node and print its values
		for i in range(10):
			# Next Dialogue Node
			var next_dialogue_node = self.dc_data.get_next_dialogue_node(self.current_dialogue, port_to_get, self.live_nodes_js)
			port_to_get = 0

			if next_dialogue_node:
				self.current_dialogue = next_dialogue_node

				print(" ")
				print("NEXT NODE: ", next_dialogue_node.node_class_key)
				
				# Live nodes are DCActionNode and DCDialogueNode. See DCGUtils.live_nodes
				var live_node_js
				
				# Print Dialogue Node
				if next_dialogue_node.node_class_key == DCGUtils.DialogueNode:
					live_node_js = self.dc_data.get_live_node_js(next_dialogue_node, self.live_nodes_js)
					print_dialogue_node(live_node_js)
					
					# Port 0 can be unused if we have some answers
					if "Outputs" in live_node_js and live_node_js["Outputs"].size() > 1:
						port_to_get = 1
					else:
						port_to_get = 0
				
				# Print Action Node
				elif next_dialogue_node.node_class_key == DCGUtils.ActionNode:
					live_node_js = self.dc_data.get_live_node_js(next_dialogue_node, self.live_nodes_js)
					print_action_node(live_node_js)
					
	else:
		print("No StartNode with port index 0!")


func print_start_node(node_js):
	print("Start Name: ", node_js["StartName"])
	print_ports(node_js)


func print_action_node(node_js):
	if "ActionName" in node_js:
		print("ActionName: ",node_js["ActionName"])
	
	if "ActionText" in node_js:
		var action_text_str = self.dc_data.get_text_of_text_slot(node_js["ActionText"])
		print("ActionText: ")
		print(action_text_str)
	
	if "ActionPorts" in node_js:
		print("Ports Names: ")
		for text in node_js["ActionPorts"]["Texts"]:
			print(text)


func print_dialogue_node(node_js):
	if "Character" in node_js:
		print("CharacterID: ", node_js["Character"]["Id"])
	
	# Get Main Text
	var main_text_js = node_js["MainText"]
	var main_text_str = self.dc_data.get_text_of_text_slot(main_text_js)
	var main_text = self.dc_data.get_text_by_lang(main_text_str, "Eng")
	if main_text:
		print("Main Text: ")
		print(main_text)
	else:
		print(main_text_str)
	
	if "TextSlots" in node_js:
		print("Text SLots: ")
		for text_slot_js in node_js["TextSlots"]:
			var text_str = self.dc_data.get_text_of_text_slot(text_slot_js)
			var text_slot_text = self.dc_data.get_text_by_lang(text_str, "Eng")
			
			if text_slot_text:
				print(text_slot_text)
			else:
				print(text_slot_text)

	print_ports(node_js)


# node_js or live_node_js!!!
func print_ports(node_js):
	if "Inputs" in node_js:
		print("Inputs: ", node_js["Inputs"])
	
	if "Outputs" in node_js:
		print("Outputs: ", node_js["Outputs"])
