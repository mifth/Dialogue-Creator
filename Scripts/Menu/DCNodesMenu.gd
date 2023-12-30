class_name DCNodesMenu
extends MenuButton

var popup: PopupMenu

signal add_node

func _ready():
	popup = get_popup()
	#popup.add_item("item a")
	#popup.add_item("item b")
	#popup.add_item("item c")
	popup.id_pressed.connect(self._on_item_pressed)
	#self.pressed.connect(self._on_item_pressed)



func _on_item_pressed(ID):
	var button_name = popup.get_item_text(ID)
	
	emit_signal("add_node", button_name)
	
