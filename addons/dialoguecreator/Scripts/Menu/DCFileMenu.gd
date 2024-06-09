class_name DCFileMenu
extends MenuButton

var popup: PopupMenu

signal NewFile
signal SaveFile
signal LoadFile


func _ready():
	popup = get_popup()
	popup.id_pressed.connect(self._on_item_pressed)


func _on_item_pressed(ID):
	if ID == 0:
		emit_signal("NewFile")
	elif  ID == 1:
		emit_signal("LoadFile")
	elif ID == 2:
		emit_signal("SaveFile")
