class_name InspectorCategory
extends Button

var category_theme = preload("./CategoryTheme.tres")

func _init(object,info:Dictionary):
	align = 0
	size_flags_horizontal = SIZE_EXPAND_FILL
	text = get_label(info.get("name", "Category").trim_prefix("_c_"))
	hint_tooltip = ""
	focus_mode = 0
	disabled = true
	# Set colors
	modulate = info.get("tint", Color(1.5, 1.5, 1.5, 0.5))
	add_color_override("font_color_disabled", Color(1.7, 1.7, 1.7))
	# Type 14 is "color", therefore use custom color.
	if info["type"] == 14:
		text = " "+get_label(info.get("name", "Category").trim_prefix("_c_"))
		modulate = Color(1, 1, 1, 0.6)
		theme = category_theme
		self_modulate = object.get(info["name"]).lightened(0.3)
		add_color_override("font_color_disabled", Color(2.3, 2.3, 2.3))

func get_label(name):
	return " ■  "+name.capitalize()+"  "
