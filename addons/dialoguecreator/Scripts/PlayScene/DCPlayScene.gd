extends Node


func get_texts_container():
	return $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/TextsVBoxContainer as VBoxContainer


func _on_close_button_pressed():
	queue_free()
