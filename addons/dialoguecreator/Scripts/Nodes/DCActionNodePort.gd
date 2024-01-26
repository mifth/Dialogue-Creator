class_name DCActionNodePort
extends Control


signal DeleteDialogueText
signal UpDialogueText
signal DownDialogueText


func _exit_tree():
	queue_free()


func _on_delete_text_button_pressed():
	DeleteDialogueText.emit(self)
	# queue_free()


func _on_up_text_button_pressed():
	UpDialogueText.emit(self)


func _on_down_text_button_pressed():
	DownDialogueText.emit(self)


func get_text_node() -> LineEdit:
	return $PortNameLineEdit

