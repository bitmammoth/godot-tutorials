extends ParallaxLayer

export(float) var CLOUD_SPEED = 50.0

func _process(delta):
	$Sprite.position.x += CLOUD_SPEED * delta
