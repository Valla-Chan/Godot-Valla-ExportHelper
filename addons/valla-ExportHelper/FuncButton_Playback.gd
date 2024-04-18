class_name InspectorPlayback
extends EditorProperty

var object : Object
var path : String

var icon_play = preload("./icon_play.svg")
var icon_pause = preload("./icon_pause.svg")
var playbutton := ToolButton.new()

func _init(obj:Object,p):
	object = obj
	path = p
	
	playbutton.focus_mode = 0
	playbutton.toggle_mode = true
	playbutton.pressed = object.get(path)
	playbutton.connect("toggled",self,"_value_changed")
	playbutton.size_flags_horizontal = SIZE_EXPAND_FILL
	playbutton.align = 0
	toggle_active(playbutton.pressed)
	
	add_child(playbutton)
	add_focusable(playbutton)
	connect("property_changed",self,"run_changed")

func _enter_tree():
	label = path.capitalize()
	toggle_active(object.get(path))

func toggle_active(state):
	if state:
		playbutton.set_button_icon(icon_pause)
		playbutton.text = "Pause"
	else:
		playbutton.set_button_icon(icon_play)
		playbutton.text = "Play"
	playbutton.pressed = state

func update_property():
	toggle_active(object.get(path))

func _value_changed(value):
	emit_changed(path,value)

func run_changed(property,value,field,changing):
	toggle_active(value)
