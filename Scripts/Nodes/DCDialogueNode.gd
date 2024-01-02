extends DCBaseGraphNode

@onready @export var text_node_text_resource: Resource


func _on_add_text_button_pressed():
	var text_node = text_node_text_resource.instantiate() as DCDialogueNodeText
	
	text_node.DeleteDialogueText.connect(self.ClearPorts)
	text_node.UpDialogueText.connect(self.UpPort)
	text_node.DownDialogueText.connect(self.DownPort)

	add_child(text_node)
	set_slot( get_children().size() - 1, true, 1, Color.BURLYWOOD, true, 0, Color.WHITE)
