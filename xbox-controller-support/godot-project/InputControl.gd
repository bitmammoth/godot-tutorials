extends Control

export(String) var action_name setget set_action_name

onready var icon = $Sprite
onready var name_label = $ActionName

var device_id = -1

func _ready():
	Input.connect("joy_connection_changed", self, "_joy_connection_changed")
	icon.frame = InputHelper.get_current_icon_index(device_id, action_name)
	name_label.text = action_name
	
func _joy_connection_changed(device_id:int, _connected:bool):
	self.device_id = device_id
	icon.frame = InputHelper.get_current_icon_index(device_id, action_name)
	
func set_action_name(a):
	action_name = a
	if icon != null:
		icon.frame = InputHelper.get_current_icon_index(device_id, action_name)
		name_label.text = action_name
