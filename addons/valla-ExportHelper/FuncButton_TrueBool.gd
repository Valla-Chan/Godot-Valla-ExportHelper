class_name InspectorTBool
extends EditorProperty

var check = CheckBox.new()
var object:Object
var info:Dictionary

func _init(obj:Object, i):
	object = obj
	info = i
	
	check.text = "True"
	check.pressed = object.get(info["name"])
	check.connect("toggled",self,"_value_changed")
	add_child(check)
	add_focusable(check)
	connect("property_changed",self,"run_changed")

func _enter_tree():
	label = info["name"].trim_prefix("t_").capitalize()

func get_tooltip_text():
	return "GAY"

func _value_changed(value):
	emit_changed(get_edited_property(),value)

func run_changed(property,value,field,changing):
	check.pressed = object.get(info["name"])
