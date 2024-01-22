class_name InspectorSpacer
extends HSeparator

func _init(info:Dictionary):
	size_flags_horizontal = SIZE_EXPAND_FILL
	focus_mode = 0
	modulate = info.get("tint", Color(1.5, 1.5, 1.5, 1.0))
