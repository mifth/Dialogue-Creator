extends DCBaseNode

@onready @export var text_node_text_resource: Resource


func _on_add_text_button_pressed():
	add_child(text_node_text_resource.instantiate())
	set_slot( get_children().size() - 1, true, 1, Color.BURLYWOOD, true, 0, Color.WHITE)
