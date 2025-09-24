class_name InspectorNodeString
extends EditorProperty

var nodename : InspectorNPNButton
var object:Object
var info:Dictionary

func _init(obj:Object, i):
	object = obj
	info = i
	
	nodename = InspectorNPNButton.new(object.get(info["name"]),info["name"],object)
	add_child(nodename)
	add_focusable(nodename)
	nodename.connect("text_changed",self,"_value_changed")
	connect("property_changed",self,"run_changed")

func _enter_tree():
	label = info["name"].capitalize()

func _value_changed(value):
	emit_changed(get_edited_property(),value)
	object.set(info["name"],value)

func run_changed(property,value,field,changing):
	update_property()

func update_property():
	var newtext = object.get(info["name"])
	if !newtext is String && newtext == null: return
	if newtext != nodename.text:
		nodename.text = newtext
