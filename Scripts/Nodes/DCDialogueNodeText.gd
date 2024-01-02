class_name DCDialogueNodeText
extends Control


signal DeleteDialogueText
signal UpDialogueText
signal DownDialogueText


func _exit_tree():
	queue_free()


func _on_delete_text_button_pressed():
	emit_signal("DeleteDialogueText", self)

	queue_free()


func _on_up_text_button_pressed():
	emit_signal("UpDialogueText", self)


func _on_down_text_button_pressed():
	emit_signal("DownDialogueText", self)
