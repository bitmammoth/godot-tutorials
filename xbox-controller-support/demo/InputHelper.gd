extends Node

const xbox_input_icon_mapping = {
	JOY_XBOX_A: 0,
	JOY_XBOX_B: 1,
	JOY_XBOX_X: 2,
	JOY_XBOX_Y: 3,
	JOY_START: 6,
	JOY_SELECT: 7
}

onready var info_popup = preload("res://ControllerConnectionPopup.tscn")

var scene_name = null

var device_id = -1
var popup = null

var show_controller_popup = false

func _ready():
	Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")
	for device_id in Input.get_connected_joypads():
		_set_joystick_mode()
		self.device_id = device_id
		break
		
func is_joycon_connected():
	return device_id > -1

func get_current_icon_index(action_name:String):
	for action in InputMap.get_action_list(action_name):
		if action is InputEventJoypadButton and device_id != -1:
			if "XInput" in Input.get_joy_name(device_id):
				return xbox_input_icon_mapping[action.button_index]
	return -1
		
func _process(delta):
	if get_tree().current_scene.name != scene_name:
		scene_name = get_tree().current_scene.name
		var canvas_layer = find_node_by_name(get_tree().current_scene, "CanvasLayer")
		if canvas_layer == null:
			canvas_layer = CanvasLayer.new()
			get_tree().current_scene.add_child(canvas_layer)
		popup = find_node_by_name(canvas_layer, "InfoPopup")
		if popup == null:
			popup = info_popup.instance()
			canvas_layer.add_child(popup)
	if show_controller_popup:
		show_controller_popup = false
		_show_controller_popup()

func _on_joy_connection_changed(device_id, connected):
	if connected:
		self.device_id = device_id
		_set_joystick_mode()
	else:
		self.device_id = -1
		_set_keyboard_mode(true)
		
func _set_joystick_mode():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	_show_controller_popup()
	emit_signal("on_input_device_change")
	
func _set_keyboard_mode(show_popup:bool):
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if show_popup:
		_show_keyboard_popup()
	emit_signal("on_input_device_change")
		
func _show_controller_popup():
	if popup != null:
		popup.show_connected_popup()
	else:
		show_controller_popup = true
	
func _show_keyboard_popup():
	if popup != null:
		popup.show_disconnected_popup()
	
func find_node_by_name(root, name):
	for child in root.get_children():
		if child.get_name() == name:
			return child

		var found = find_node_by_name(child, name)

		if found:
			return found

	return null
