class_name  DCTextSlotButton
extends Button

signal next_node_signal(port_id: int)


var port_id: int


func _on_pressed():
	next_node_signal.emit(self.port_id)


func _exit_tree():
	queue_free()
