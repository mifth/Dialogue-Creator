class_name  DCTextSlotButton
extends RichTextLabel


signal next_node_button(out_port_id: int)

var out_port_id: int


func _exit_tree():
	queue_free()


func _on_control_pressed():
	next_node_button.emit(self.out_port_id)
