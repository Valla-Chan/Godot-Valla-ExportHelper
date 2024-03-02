tool
extends Control

var increment = 1
var hidden = false setget set_hidden
var angle_vec = Vector2.ZERO setget set_angle_vec

signal angle_changed

func _ready():
	set_angle_vec(angle_vec)

func set_hidden(p_hidden):
	hidden = p_hidden
	var raypointer = find_node("Center").get_child(0)
	raypointer.visible = !hidden

func get_center_pos() -> Vector2:
	return find_node("Center").rect_global_position

func get_radius_length() -> float:
	return find_node("Center").rect_position.x

func set_angle_vec(vec):
	#var emit = false
	#if angle_vec != vec:
	#	emit = true
	angle_vec = vec
	# set raypointer rotation
	var raypointer = find_node("Center").get_child(0)
	raypointer.rotation_degrees = rad2deg(angle_vec.angle())
	raypointer.cast_to = Vector2(get_radius_length(),0)
	raypointer.modulate = Color(2,2,2,4)
	#if emit && emit_signal: emit_signal("value_changed",angle_vec)

func nearest_increment(x,step):
	return round(float(x)/step)*step

#remap out of bounds 
func circular_remap(n,lower,upper):
	if n == lower || n == upper:
		return n
	var valuerange = upper - lower
	var modulus = fmod(n - lower, valuerange)
	# If the modulus is negative, adjust it to be positive
	if modulus < 0.0:
		modulus += valuerange
	# Return the modulus added to the lower bound
	return modulus + lower

func _gui_input(event):
	if hidden: return
	# left click
	if (event is InputEventMouse && event.button_mask == 1):
		var angle = get_center_pos().angle_to_point(rect_global_position+event.position)
		if increment > 0:
			angle = nearest_increment(angle,deg2rad(increment))
		if Input.is_key_pressed(KEY_CONTROL):
			angle = nearest_increment(angle,deg2rad(15))
		if Input.is_key_pressed(KEY_SHIFT):
			angle = nearest_increment(angle,deg2rad(45))
		# convert angle to vector and set
		#set_angle_vec(Vector2.LEFT.rotated(angle))
		var corrected_angle = round(180+rad2deg(angle))
		emit_signal("angle_changed",circular_remap(corrected_angle,-360,360))

func update_angle():
	emit_signal("angle_changed",rad2deg(angle_vec.angle()))
