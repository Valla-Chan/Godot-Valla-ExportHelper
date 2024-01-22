extends EditorInspectorPlugin

var plugin

func can_handle(object):
	return true

func parse_property(object: Object, type: int, path: String, hint: int, hint_text: String, usage: int) -> bool:
	if "_btn_" in path:
		# Hide argument field if exporting as bool or int.
		# Show field if exporting as String or other.
		# String is type 4, bool is type 1, int is type 2
		var usearg = false if type == 1 || type == 2 else true
		add_custom_control(InspectorFunctionButton.new(object, {
						method=path.trim_prefix("_"),
						use_arg=usearg,
						type=type,
						update_filesystem=true
					}))
		return true
	elif "_c_" in path:
		add_custom_control(InspectorCategory.new({
						name=path.trim_prefix("_c_"),
					}))
		return true
	elif "_sep_" in path:
		add_custom_control(InspectorSpacer.new({
						name=path.trim_prefix("_c_"),
					}))
		return true
	return false
