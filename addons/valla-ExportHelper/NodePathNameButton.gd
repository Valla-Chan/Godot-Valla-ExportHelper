class_name InspectorNPNButton
extends LineEdit

var object
var path

func _init(txt,p_varname,obj):
	object = obj
	path = p_varname
	if txt is String:
		text = txt

func can_drop_data(position : Vector2, data):
	return (data is Dictionary && data.get("nodes",[]).size() > 0)

func drop_data(position : Vector2, data):
	var node = get_node_or_null(data["nodes"][0])
	if is_instance_valid(node):
		text = node.name
		object.set(path, node.name)
		emit_signal("text_changed",node.name)
