class_name DCDialogueNodeText
extends Control

signal DeleteDialogueText

func _exit_tree():
	queue_free()


func _on_delete_text_button_pressed():
	emit_signal("DeleteDialogueText", self)

	queue_free()
