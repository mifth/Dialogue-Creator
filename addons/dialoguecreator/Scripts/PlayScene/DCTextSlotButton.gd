class_name  DCTextSlotButton
extends Button


signal next_node_button(out_port_id: int)

var out_port_id: int


func _on_pressed():
	next_node_button.emit(self.out_port_id)


func _exit_tree():
	queue_free()
