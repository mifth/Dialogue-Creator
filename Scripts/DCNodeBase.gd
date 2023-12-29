extends Node


func _exit_tree():
	queue_free()


func _on_delete_text_button_pressed():
	queue_free()
