class_name DCStartNode
extends DCBaseGraphNode


func _enter_tree():
	SetUniqueStartID(0)


func GetNodeParamsJS():
	var params = GetNodeBaseParamsJS()
	
	params["StartID"] = GetStartIDSpinBox().value as int
	params["StartName"] = GetStartName().text
	
	return [params, DCUtils.StartNode]


func GetStartIDSpinBox() -> SpinBox:
	return $VBoxContainer/HBoxContainer/StartIDSpinBox


func GetStartName() -> LineEdit:
	return $VBoxContainer/HBoxContainer2/StartNameLineEdit


func GetStartID() -> int:
	return GetStartIDSpinBox().value as int


func SetStartID(new_value: int):
	GetStartIDSpinBox().value = new_value


func GetIDs(nodes):
	var ids = []

	for node in nodes:
		if is_instance_of(node, DCStartNode) and node != self:
			ids.append(node.GetStartID())

	return ids


func SetUniqueStartID(start_value: int):
	var nodes = get_parent().get_children()
	SetStartID(DCUtils.GenerateID(GetIDs(nodes), start_value))


func _on_start_spin_box_value_changed(value):
	SetUniqueStartID(value)
