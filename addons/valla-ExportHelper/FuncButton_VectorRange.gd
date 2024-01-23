class_name InspectorVecRange
extends EditorProperty

var category_theme = preload("./CategoryTheme.tres")

var txt := Label.new()
var values_hbox := HBoxContainer.new()
var minfield := EditorSpinSlider.new()
var maxfield := EditorSpinSlider.new()
var object:Object
var info:Dictionary


func _init(obj:Object,i):
	object = obj
	info = i
	
	values_hbox.size_flags_horizontal = SIZE_EXPAND_FILL
	values_hbox.size_flags_stretch_ratio = 0.5
	add_child(values_hbox)
	
	minfield.size_flags_stretch_ratio = 0.5
	maxfield.size_flags_stretch_ratio = 0.5
	minfield.set_flat(true)
	maxfield.set_flat(true)
	minfield.set_hide_slider(true)
	maxfield.set_hide_slider(true)
	match info["trimsuffix"]:
		"_inout":
			minfield.set_label("In")
			maxfield.set_label("Out")
		"_openclose":
			minfield.set_label("Open")
			maxfield.set_label("Close")
		"_upperlower":
			minfield.set_label("Lower")
			maxfield.set_label("Upper")
		"_topbottom":
			minfield.set_label("Bottom")
			maxfield.set_label("Top")
		"_leftright":
			minfield.set_label("Left")
			maxfield.set_label("Right")
		_:
			minfield.set_label("Min")
			maxfield.set_label("Max")
	minfield.allow_greater = true
	minfield.allow_lesser = true
	minfield.allow_greater = true
	maxfield.allow_lesser = true
	var blankimg := ImageTexture.new()
	minfield.add_icon_override("updown",blankimg)
	maxfield.add_icon_override("updown",blankimg)
	minfield.size_flags_horizontal = SIZE_EXPAND_FILL
	maxfield.size_flags_horizontal = SIZE_EXPAND_FILL
	minfield.theme = category_theme
	maxfield.theme = category_theme
	
	minfield.value = object.get(info["name"]).x
	maxfield.value = object.get(info["name"]).y
	minfield.connect("value_changed",self,"_value_changed")
	maxfield.connect("value_changed",self,"_value_changed")
	
	values_hbox.add_child(minfield)
	values_hbox.add_child(maxfield)
	add_focusable(minfield)
	add_focusable(maxfield)
	connect("property_changed",self,"run_changed")

func _enter_tree():
	label = get_edited_property().trim_suffix(info["trimsuffix"]).capitalize()

func _value_changed(_value):
	emit_changed(get_edited_property(),Vector2(minfield.value,maxfield.value))
	
func run_changed(property,value,field,changing):
	minfield.value = value.x
	maxfield.value = value.y
