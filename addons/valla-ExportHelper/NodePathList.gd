class_name InspectorNodePathListItem
extends HBoxContainer

var data_node : Button
var data_path : LineEdit

var object: Node
var path

signal text_changed(string)

func _init(txtpath,p_varname,obj):
	object = obj
	path = p_varname
	data_node = Button.new()
	data_path = LineEdit.new()
	data_node.size_flags_horizontal = SIZE_EXPAND_FILL
	data_path.size_flags_horizontal = SIZE_EXPAND_FILL
	add_child(data_node)
	add_child(data_path)
	if txtpath is String:
		data_path.text = txtpath
	var node = self.get_node(txtpath)
	if (is_instance_valid(node)):
		data_node.text = node.name
	

func can_drop_data(position : Vector2, data):
	return (data is Dictionary && data.get("nodes",[]).size() > 0)

func drop_data(position : Vector2, data):
	var node : Node = get_node_or_null(data["nodes"][0])
	if is_instance_valid(node):
		data_node.text = node.name
		data_path.text = object.get_path_to(node)
		object.set(path, data_path.text)
		emit_signal("path_changed", data_path.text)
