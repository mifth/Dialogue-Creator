extends GraphNode

@export var text_node_text_resource: Resource


func _exit_tree():
	queue_free()


func _on_add_text_button_pressed():
	add_child(text_node_text_resource.instantiate())
	set_slot( get_children().size() - 1, true, 0, Color.WHITE, true, 0, Color.WHITE)
