extends CanvasModulate

const NIGHT_COLOR = Color("#091d3a")
const DAY_COLOR = Color("#ffffff")
const TIME_SCALE = 0.1

var time = 0

func _process(delta):
	time += delta
	self.color = NIGHT_COLOR.linear_interpolate(DAY_COLOR, sin(time))
