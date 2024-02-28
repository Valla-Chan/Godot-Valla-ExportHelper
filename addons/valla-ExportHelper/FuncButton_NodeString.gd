class_name InspectorNodeString
extends EditorProperty

var nodename : InspectorNPNButton
var object:Object
var info:Dictionary

func _init(obj:Object, i):
	object = obj
	info = i
	
	nodename = InspectorNPNButton.new(object.get(info["name"]))
	add_child(nodename)
	add_focusable(nodename)
	nodename.connect("text_changed",self,"_value_changed")
	connect("property_changed",self,"run_changed")

func _enter_tree():
	label = info["name"].capitalize()

func _value_changed(value):
	emit_changed(get_edited_property(),value)

func run_changed(property,value,field,changing):
	var newtext = object.get(info["name"])
	if newtext != nodename.text:
		nodename.text = object.get(info["name"])
