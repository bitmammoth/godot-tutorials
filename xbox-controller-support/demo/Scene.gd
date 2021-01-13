extends Node2D

onready var popup = $CanvasLayer/InfoPopup

func _ready():
	Input.connect("joy_connection_changed", self, "_joy_connection_changed")
	if Input.get_connected_joypads().size() > 0:
		popup.show_connected_popup()
		
func _joy_connection_changed(device_id:int, connected:bool):
	if connected:
		popup.show_connected_popup()
	else:
		popup.show_disconnected_popup()
