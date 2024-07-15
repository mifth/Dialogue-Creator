class_name DCUtils
extends Object

const version = [0, 3]


static func generate_id(ids, start_value: int) -> int:
	var new_id: int = start_value

	while true:
		if new_id not in ids:
			return new_id
		else:
			new_id += 1
		
	return -1


static func remove_children(parent: Node):
	for child in parent.get_children():
		parent.remove_child(child)
		child.queue_free()
