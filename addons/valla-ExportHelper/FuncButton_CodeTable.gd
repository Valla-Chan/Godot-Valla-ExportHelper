class_name InspectorCodeTable
extends VBoxContainer

# Requires var to be first exported as Inspector Placeholder

var icon = preload("./icon_play.svg")

var table : Dictionary
# list of hbox nodes
var hboxes : Array = []
# store the entry strings and what hbox index they correspond to.
var entryindexes : Dictionary = {}


var object : Object
var info : Dictionary

func _init(obj:Object,i:Dictionary):
	object = obj
	info = i
	size_flags_horizontal = SIZE_EXPAND_FILL
	
	# store the dictionary values
	table = object.get(info["name"])
	#print(table)
	
	# sort the keys alphabetically, placing "default" on top.
	var keys_ordered = table.keys()
	keys_ordered.sort()
	if "default" in keys_ordered:
		keys_ordered.erase("default")
		keys_ordered.push_front("default")
	
	# create hboxes for each entry
	for index in keys_ordered.size():
		entryindexes[keys_ordered[index]] = index
		var hbox = HBoxContainer.new()
		hbox.size_flags_horizontal = SIZE_EXPAND_FILL
		add_child(hbox)
		hboxes.push_back(hbox)
		
		var name = LineEdit.new()
		name.text = keys_ordered[index]
		name.size_flags_horizontal = SIZE_EXPAND_FILL
		name.align = 1
		name.modulate = Color.lightgray
		hbox.add_child(name)
		
		var button = Button.new()
		button.size_flags_horizontal = SIZE_EXPAND_FILL
		button.align = Button.ALIGN_CENTER
		button.icon_align = Button.ALIGN_CENTER
		button.icon = icon
		button.disabled = false
		button.modulate = Color(1.3,1.3,1.3)
		button.text = " "

		if "desc" in table[keys_ordered[index]]:
			button.hint_tooltip = str(table[keys_ordered[index]]["desc"])
		hbox.add_child(button)
		
		if keys_ordered[index] == "default":
			add_child(HSeparator.new())
	
	
	
