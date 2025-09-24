class_name InspectorStringChoices
extends EditorProperty

var hbox : HBoxContainer
var choices : OptionButton
var object : Object
var path : String

var string_choices : PoolStringArray
var user_field_index := -1
var user_field : InspectorNPNButton

func _init(obj:Object, p_name, p_hint_text):
	object = obj
	path = p_name
	string_choices = p_hint_text.split(",")
	
	hbox = HBoxContainer.new()
	hbox.add_constant_override("separation",0)
	choices = OptionButton.new()
	choices.flat = true
	choices.clip_text = true
	choices.size_flags_horizontal = SIZE_EXPAND_FILL
	choices.connect("item_selected",self,"_selection_changed")
	

	user_field = InspectorNPNButton.new("", path, object)
	user_field.visible = false
	user_field.size_flags_horizontal = SIZE_EXPAND_FILL
	user_field.connect("text_changed",self,"_text_changed")
	user_field.size_flags_stretch_ratio = 10

	update_option_list()
	
	add_child(hbox)
	hbox.add_child(user_field)
	hbox.add_child(choices)
	add_focusable(user_field)
	add_focusable(choices)
	connect("property_changed",self,"run_changed")

# TODO: make this update from the string export hint
func update_option_list():
	choices.clear()
	for stringchoice in string_choices:
		if (stringchoice.empty() || stringchoice.nocasecmp_to("None") == 0):
			choices.add_item("None")
			choices.set_item_metadata(choices.get_item_count()-1, "")
			if string_choices.size() > 1:
				choices.add_separator()
			break;
	for stringchoice in string_choices:
		if (stringchoice == "---"):
			choices.add_separator()
		elif (stringchoice.empty() || stringchoice.nocasecmp_to("None") == 0):
			continue
		else:
			choices.add_item(stringchoice.capitalize().replace("/"," /"))
			choices.set_item_metadata(choices.get_item_count()-1, stringchoice)
	# Add User Entry
	choices.add_separator()
	choices.add_item("_____")
	user_field_index = choices.get_item_count()-1
	

func _selection_changed(idx):
	user_field.visible = idx == user_field_index
	if idx == user_field_index:
		choices.set_item_text(user_field_index, "")
	else: choices.set_item_text(user_field_index, "_____")
	emit_changed(get_edited_property(), choices.get_item_metadata(idx))
	object.set(path, choices.get_item_metadata(idx))

func _text_changed(p_text:String):
	if choices.get_selected_id() == user_field_index:
		choices.set_item_metadata(user_field_index, p_text)
		object.set(path, p_text)

func run_changed(property,value,field,changing):
	update_property()

func update_property():
	var currentchoice = object.get(path)
	if !currentchoice is String && currentchoice == null:
		#choices.select(0)
		return
	if currentchoice != choices.get_selected_metadata():
		for idx in choices.get_item_count():
			if choices.get_item_metadata(idx) == currentchoice:
				choices.select(idx)
				return
		# TODO: here we need to disable the choice thing and switch to the string entry and change string to this.
			
