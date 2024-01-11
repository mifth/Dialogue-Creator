class_name DCNodesMenu
extends MenuButton

var popup: PopupMenu

signal AddNode


func _ready():
	popup = get_popup()
	popup.id_pressed.connect(self._on_item_pressed)


func _on_item_pressed(ID):
	var button_name = popup.get_item_text(ID)
	
	emit_signal("AddNode", button_name)
	
