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
	var button_name = popup.get_item_text(ID)
	
	if button_name == "New":
		emit_signal("NewFile")
	elif button_name == "Save":
		emit_signal("SaveFile")
	elif  button_name == "Open":
		emit_signal("LoadFile")
