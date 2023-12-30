@tool
extends EditorPlugin


func _enter_tree():
	# Initialization of the plugin goes here.
	pass


func _exit_tree():
	queue_free()
