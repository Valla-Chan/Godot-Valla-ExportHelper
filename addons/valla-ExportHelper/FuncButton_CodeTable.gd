class_name InspectorCodeTable
extends VBoxContainer

# Requires var to be first exported as Inspector Placeholder

var icon_add = preload("./icon_add.svg")
var icon_close = preload("./icon_close.svg")
var icon_run = preload("./icon_play.svg")
var icon_delete = preload("./icon_remove.svg")
var undo_redo : UndoRedo

var table : Dictionary
# store the entry strings and what hbox index they correspond to.
var entryindexes : Dictionary = {}
var update = true

var object : Object
var info : Dictionary
var method : String

func _process(_delta):
	if table != object.get(info["path"]) && update && Engine.is_editor_hint():
		_update_list()

func _init(obj:Object,i:Dictionary,undoredo:UndoRedo):
	undo_redo = undoredo
	object = obj
	info = i
	method = info["method"]
	size_flags_horizontal = SIZE_EXPAND_FILL
	
	_update_list()

func _update_list():
	# store the dictionary values
	table = object.get(info["path"])

	for child in get_children():
		remove_child(child)
		child.queue_free()
	
	var labelbutton = Button.new()
	labelbutton.size_flags_horizontal = SIZE_EXPAND_FILL
	labelbutton.align = Button.ALIGN_CENTER
	labelbutton.text = info["name"].capitalize()
	labelbutton.disabled = true
	labelbutton.focus_mode = 0
	labelbutton.modulate = info.get("tint", Color(0.8, 0.8, 0.8))
	labelbutton.add_color_override("font_color_disabled", Color(0.9, 0.9, 0.9,0.8))
	add_child(labelbutton)

	
	# sort the keys alphabetically, placing "default" on top.
	var keys_ordered = table.keys()
	keys_ordered.sort()
	if "default" in keys_ordered:
		keys_ordered.erase("default")
		keys_ordered.push_front("default")

	# create hboxes for each entry
	entryindexes.clear()
	for index in keys_ordered.size():
		
		var hbox = HBoxContainer.new()
		hbox.size_flags_horizontal = SIZE_EXPAND_FILL
		add_child(hbox)
		
		var name = LineEdit.new()
		name.text = keys_ordered[index]
		name.size_flags_horizontal = SIZE_EXPAND_FILL
		name.align = 1
		name.modulate = Color.lightgray
		hbox.add_child(name)
		
		# save the current key and [index,lineedit] to a dict
		entryindexes[keys_ordered[index]] = [index,name]
		
		# add connections
		name.connect("text_entered",self,"_update_data_name",[ keys_ordered[index], name])
		name.connect("focus_exited",self,"_update_data_name",[ name.get_text(), keys_ordered[index], name] )
	
		# add "run" button
		var button = Button.new()
		button.size_flags_horizontal = SIZE_EXPAND_FILL
		button.align = Button.ALIGN_CENTER
		button.icon_align = Button.ALIGN_CENTER
		button.icon = icon_run
		button.disabled = false
		button.modulate = Color(1.3,1.3,1.3)
		button.text = " "
		button.connect("pressed", self, "_on_button_pressed", [keys_ordered[index]])
		hbox.add_child(button)
		
		# add "add" button only if there is a method for it.
		var button_add = Button.new()
		button_add.size_flags_horizontal = SIZE_EXPAND_FILL
		button_add.align = Button.ALIGN_CENTER
		button_add.icon_align = Button.ALIGN_CENTER
		button_add.icon = icon_add
		button_add.disabled = false
		button_add.modulate = Color(1.3,1.3,1.3)
		button_add.text = " "
		button_add.connect("pressed", self, "_on_button_pressed_add", [keys_ordered[index]])
		button_add.size_flags_stretch_ratio = 0.001
		button_add.rect_min_size = Vector2(0,0)
		if (object.has_method(method+"_add") || object.has_method(method+"_addremove")) && keys_ordered[index] != "default":
			hbox.add_child(button_add)

		# add "delete" button
		var deletebutton = Button.new()
		deletebutton.size_flags_horizontal = SIZE_SHRINK_CENTER 
		deletebutton.align = Button.ALIGN_CENTER
		deletebutton.icon_align = Button.ALIGN_CENTER
		deletebutton.icon = icon_delete
		deletebutton.disabled = false
		deletebutton.modulate = Color(1,1,1)
		deletebutton.text = " "
		deletebutton.connect("pressed", self, "_remove_entry", [name])
		deletebutton.size_flags_stretch_ratio = 0.001
		deletebutton.rect_min_size = Vector2(30,0)
		deletebutton.hint_tooltip = "Delete"
		hbox.add_child(deletebutton)

		if "desc" in table[keys_ordered[index]]:
			button.hint_tooltip = str(table[keys_ordered[index]]["desc"])
		
		if keys_ordered[index] == "default":
			add_child(HSeparator.new())

func _on_button_pressed(key):
	object.call(method,key)

func _on_button_pressed_add(key):
	if object.has_method(method+"_add"):
		object.call(method+"_add",key)
	elif object.has_method(method+"_addremove"):
		object.call(method+"_addremove",key)

func _update_data_name(new_text,old_text, name):
	new_text = name.get_text()
	if new_text == old_text: return
	update = false
	var vartable_old = object.get(info["path"])
	var vartable_new = object.get(info["path"]).duplicate()
	if old_text in vartable_new:
		vartable_new[new_text] = vartable_new[old_text]
		vartable_new.erase(old_text)
		_create_undoredo_action("Modify CodeTable Entry",vartable_old,vartable_new)
	update = true

func _remove_entry(entry):
	update = false
	entry = entry.get_text()
	var vartable_old = object.get(info["path"])
	var vartable_new = object.get(info["path"]).duplicate()
	if entry in vartable_new:
		vartable_new.erase(entry)
		_create_undoredo_action("Delete CodeTable Entry",vartable_old,vartable_new)
	update = true

func _create_undoredo_action(action,vartable_old,vartable_new):
	undo_redo.create_action(action)
	undo_redo.add_do_method(object, "set", info["path"], vartable_new)
	undo_redo.add_do_method(object, "property_list_changed_notify")
	undo_redo.add_undo_method(object, "set", info["path"], vartable_old)
	undo_redo.add_undo_method(object, "property_list_changed_notify")
	undo_redo.commit_action()

