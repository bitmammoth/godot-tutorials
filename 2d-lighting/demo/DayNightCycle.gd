extends CanvasModulate

const NIGHT_COLOR = Color("#091d3a")
const DAY_COLOR = Color("#ffffff")
const TIME_SCALE = 10.1

var time = 0

func _process(delta):
	time += delta * TIME_SCALE
	self.color = NIGHT_COLOR.linear_interpolate(DAY_COLOR, abs(sin(time)))
