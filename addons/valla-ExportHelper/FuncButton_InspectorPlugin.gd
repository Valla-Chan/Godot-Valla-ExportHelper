extends EditorInspectorPlugin

var plugin

func can_handle(object):
	return true

# Dev note: reference editor_properties.cpp for exports.

func parse_property(object: Object, type: int, path: String, hint: int, hint_text: String, usage: int) -> bool:
	if "_btn_" in path:
		# Hide argument field if exporting as bool or int.
		# Show field if exporting as String or other.
		# String is type 4, bool is type 1, int is type 2
		var usearg = false if type == 1 || type == 2 else true
		add_custom_control(InspectorFunctionButton.new(object, {
						name=path,
						method=path.trim_prefix("_"),
						use_arg=usearg,
						type=type,
						update_filesystem=true
					}))
		return true
	elif "_c_" in path:
		add_property_editor(path,EditorPropertyPlaceholder.new())
		add_custom_control(InspectorCategory.new(object,{
						name=path,
						type=type,
					}))
		return true
	elif "_sep_" in path:
		add_custom_control(InspectorSpacer.new({
						name=path.trim_prefix("_c_"),
					}))
		return true
	# Vector Ranges
	elif path.ends_with("_range") && type == 5:
		add_property_editor(path,InspectorVecRange.new(object, {
						name=path,
						trimsuffix="",
					}))
		return true
	elif path.ends_with("_inout") && type == 5:
		add_property_editor(path,InspectorVecRange.new(object, {
						name=path,
						trimsuffix="_inout",
					}))
		return true
	elif path.ends_with("_openclose") && type == 5:
		add_property_editor(path,InspectorVecRange.new(object, {
						name=path,
						trimsuffix="_openclose",
					}))
		return true
	elif path.ends_with("_upperlower") && type == 5:
		add_property_editor(path,InspectorVecRange.new(object, {
						name=path,
						trimsuffix="_upperlower",
					}))
		return true
	elif path.ends_with("_minmax") && type == 5:
		add_property_editor(path,InspectorVecRange.new(object, {
						name=path,
						trimsuffix="_minmax",
					}))
		return true
	elif path.ends_with("_topbottom") && type == 5:
		add_property_editor(path,InspectorVecRange.new(object, {
						name=path,
						trimsuffix="_topbottom",
					}))
		return true
	elif path.ends_with("_leftright") && type == 5:
		add_property_editor(path,InspectorVecRange.new(object, {
						name=path,
						trimsuffix="_leftright",
					}))
		return true
	# Bools that display "True" instead of "On"
	elif "t_" in path && type == 1:
		add_property_editor(path,InspectorTBool.new(object, {
						name=path,
					}))
		return true
	return false
