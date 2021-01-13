class_name InfoPopup
extends VBoxContainer

onready var connected_label = $LabelConnected
onready var disconnected_label = $LabelDisconnected
onready var animation = $CenterContainer/Control/AnimatedSprite
onready var connected_timer = $ConnectedTimer
onready var disconnected_timer = $DisconnectedTimer
onready var tween = $Tween
onready var connected_sound = $ConnectStreamPlayer
onready var disconnected_sound = $DisconnectStreamPlayer

var connected = false

func _ready():
	self.modulate.a = 0

func show_connected_popup():
	connected = true
	self.modulate.a = 1
	animation.frame = 0
	animation.animation = "xbox_connected"
	animation.play("xbox_connected")
	disconnected_label.visible = false
	connected_label.visible = true
	connected_sound.play()
	
func show_disconnected_popup():
	connected = false
	self.modulate.a = 1
	animation.frame = 0
	animation.animation = "xbox_disconnected"
	disconnected_label.visible = true
	connected_label.visible = false
	disconnected_timer.start(2.0)
	disconnected_sound.play()

func _on_AnimatedSprite_animation_finished():
	if !connected:
		tween.stop_all()
		tween.interpolate_property(self, "modulate:a", self.modulate.a, 0, 1)
		tween.start()
	else:
		connected_timer.start()

func _on_ConnectedTimer_timeout():
	tween.stop_all()
	tween.interpolate_property(self, "modulate:a", self.modulate.a, 0, 1)
	tween.start()


func _on_DisconnectedTimer_timeout():
	animation.play("xbox_disconnected")
