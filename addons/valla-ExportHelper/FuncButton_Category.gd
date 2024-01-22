class_name InspectorCategory
extends Button

func _init(info:Dictionary):
	align = 0
	size_flags_horizontal = SIZE_EXPAND_FILL
	text = get_label(info.get("name", "Category"))
	hint_tooltip = ""
	focus_mode = 0
	disabled = true
	modulate = info.get("tint", Color(1.5, 1.5, 1.5, 0.5))
	add_color_override("font_color_disabled", Color(1.7, 1.7, 1.7))

func get_label(name):
	return " ■  "+name.capitalize()+"  "
