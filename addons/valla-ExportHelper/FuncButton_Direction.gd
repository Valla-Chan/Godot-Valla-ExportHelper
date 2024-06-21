class_name InspectorDirection
extends EditorProperty

var hbox = HBoxContainer.new()
var category_theme = preload("./CategoryTheme.tres")
var dircontrol = preload("./Vector_Direction_Control.tscn").instance()

var object : Object
var info : Dictionary

var degrees := EditorSpinSlider.new()
var check := CheckBox.new()

var angle_value : float = -0.1

func _init(obj:Object,i):
	object = obj
	info = i
	
	dircontrol.angle_vec = object.get(info["name"])
	dircontrol.connect("angle_changed",self,"update_dircontrol")
	dircontrol.increment = info.get("increment",1)
	
	degrees.value = rad2deg(dircontrol.angle_vec.angle())
	degrees.theme = category_theme
	degrees.step = 1
	degrees.size_flags_horizontal = SIZE_EXPAND_FILL
	degrees.min_value = -360
	degrees.max_value = 360
	if degrees.is_connected("value_changed",self,"update_dircontrol"):
		degrees.disconnect("value_changed",self,"update_dircontrol")
	degrees.connect("value_changed",self,"update_dircontrol")
	
	check.focus_mode = 0
	check.pressed = object.get(info["name"]) != Vector2.ZERO
	check.connect("toggled",self,"toggle_active")
	toggle_active(check.pressed)
	
	add_child(hbox)
	hbox.add_child(check)
	hbox.add_child(dircontrol)
	hbox.add_child(degrees)
	add_focusable(dircontrol)
	add_focusable(degrees)
	connect("property_changed",self,"run_changed")

func _enter_tree():
	var varlabel = get_edited_property().trim_prefix("dir_")
	var prefix = str(info.get("increment",""))+"_"
	varlabel = varlabel.trim_prefix(prefix)
	label = varlabel.capitalize()
	if check.pressed:
		dircontrol.update_angle()

func toggle_active(state):
	dircontrol.set_hidden(!state)
	degrees.read_only = !state
	if state:
		dircontrol.modulate = Color.white
		degrees.modulate = Color.white
		update_dircontrol(angle_value)
	else:
		dircontrol.modulate = Color(0.8,0.8,0.8,0.6)
		degrees.modulate = Color(0.8,0.8,0.8,0.6)
		emit_changed(get_edited_property(),Vector2.ZERO)
		
			

# update from degrees.
func update_dircontrol(angle):
	angle = dircontrol.circular_remap(angle,0,360)
	var vector := Vector2.RIGHT.rotated(deg2rad(angle))
	_value_changed(vector)

func _value_changed(_value):
	if _value is float:
		_value = Vector2.LEFT.rotated(_value)
	emit_changed(get_edited_property(),_value)


func update_property():
	run_changed("",object.get(info["name"]),"",false)

func run_changed(property,value,field,changing):
	if check.pressed: #value != Vector2.ZERO:
		if value == Vector2.ZERO:
			check.pressed = false
			toggle_active(false)
		dircontrol.set_angle_vec(value)
		angle_value = rad2deg(dircontrol.angle_vec.angle())
		# Anti-crash hack for value of 180
		if round(abs(angle_value)) != 180:
			degrees.value = angle_value
		else:
			if degrees.is_connected("value_changed",self,"update_dircontrol"):
				degrees.disconnect("value_changed",self,"update_dircontrol")
			degrees.value = 180
			degrees.call_deferred("connect","value_changed",self,"update_dircontrol")
