class_name InspectorNPNButton
extends LineEdit

func _init(txt=""):
	text = txt

func can_drop_data(position : Vector2, data):
	return (data is Dictionary && data.get("nodes",[]).size() > 0)

func drop_data(position : Vector2, data):
	var node = get_node_or_null(data["nodes"][0])
	if is_instance_valid(node):
		text = node.name