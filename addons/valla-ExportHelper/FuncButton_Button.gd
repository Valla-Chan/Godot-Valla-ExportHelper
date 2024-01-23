class_name InspectorFunctionButton
extends HBoxContainer

var args = LineEdit.new()
var spacer = Control.new()
var spacer2 = Control.new()
var button = Button.new()
var object:Object
var info:Dictionary
var method:String

func _init(obj:Object, i):
	object = obj
	info = i
	method = info["method"]
	
	alignment = BoxContainer.ALIGN_CENTER
	size_flags_horizontal = SIZE_EXPAND_FILL

	add_child(spacer)
	spacer.size_flags_horizontal = SIZE_EXPAND_FILL
	spacer.size_flags_stretch_ratio = 0.33
	
	add_child(button)
	button.size_flags_horizontal = SIZE_EXPAND_FILL
	button.align = Button.ALIGN_CENTER
	button.modulate = info.get("tint", Color(1.5, 1.3, 0.8))
	button.size_flags_stretch_ratio = 0.5
	# Label and Tooltip
	button.text = method.capitalize().trim_prefix("Btn").trim_prefix(" ")
	button.hint_tooltip = "Click to call "+method
	#
	button.connect("pressed", self, "_on_button_pressed")
	button.disabled = false
	
	if info.get("use_arg", false):
		add_child(args)
		args.size_flags_stretch_ratio = 0.33
		args.size_flags_horizontal = SIZE_EXPAND_FILL
		args.modulate = info.get("tint", Color(1.1,1.1,1.1))
		if object.get(info["name"]) != "":
			args.placeholder_text = "[ "+object.get(info["name"])+" ]"
		else:
			args.placeholder_text = "[ Argument ]"
		args.placeholder_alpha = 0.3
		args.align = 1
	else:
		add_child(spacer2)
		spacer2.size_flags_horizontal = SIZE_EXPAND_FILL
		spacer2.size_flags_stretch_ratio = 0.33
	
func infer_string_datatype(value):
	if value == "true": return true
	elif value == "false": return false
	elif float(value) > 0 || float(value) < 0 || value == "0" || value == "0.0" || value == "0.00":
		value = float(value)
		if float(value) == int(value):
			value = int(value)
	return value

func _on_button_pressed():
	if info.get("use_arg", false):
		object.call(method,infer_string_datatype(args.text))
		args.text = ""
	else:
		object.call(method)
