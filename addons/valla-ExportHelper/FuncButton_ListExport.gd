class_name InspectorListExport
extends EditorProperty

var choices : OptionButton
var object : Object
var path : String
var array_property : String = ""

# TODO: this needs a LOT of fixing.

# path = listvar_property
func _init(obj:Object, p_path):
	object = obj
	path = p_path
	array_property = path.trim_prefix("listvar_")
	
	choices = OptionButton.new()
	choices.size_flags_horizontal = SIZE_EXPAND_FILL

	update_list()
	
	add_child(choices)
	add_focusable(choices)
	choices.connect("item_selected",self,"_value_changed")
	connect("property_changed",self,"run_changed")

func is_property_arraydict() -> bool:
	if object.get(array_property) is Array || object.get(array_property) is Dictionary:
		return true
	return false

func update_list():
	choices.clear()
	if !is_property_arraydict(): return
	choices.add_item("")
	for idx in object.get(array_property).size():
		var item
		if object.get(array_property) is Dictionary:
			item = object.get(array_property).keys()[idx]
		else:
			item = str(object.get(array_property)[idx])
		choices.add_item(item)

func _enter_tree():
	label = array_property.capitalize()

func _value_changed(value):
	if object.get(array_property) is Dictionary:
		object.set(path,choices.get_item_text(choices.get_selected_id()))
		emit_changed(get_edited_property(),choices.get_item_text(choices.get_selected_id()))
	else:
		object.set(path,choices.get_selected_id())
		emit_changed(get_edited_property(),choices.get_selected_id())

func run_changed(property,value,field,changing):
	update_property()

func update_property():
	var currentval = object.get(path)
	
	if object.get(array_property) is Array:
		currentval = int(currentval)
	
	if object.get(array_property) is Array && currentval > 0 && currentval < object.get(array_property).size():
		choices.select(object.get(array_property).find(currentval))
	
	elif object.get(array_property) is Dictionary && currentval in object.get(array_property).values():
		choices.select(object.get(array_property).values().find(currentval))
	
	else:
		choices.add_item(str(currentval))
		choices.select(choices.get_item_count()-1)


# Get array of all vars in an object
func get_varlist(object:Object) -> PoolStringArray:
	var proplist = object.get_property_list()
	var propnames = PoolStringArray()
	for table in proplist:
		var value = table.values()[0]
		if (table.values()[5] != 128) && table.values()[5] != 256:
			propnames.append(value)
	return propnames
