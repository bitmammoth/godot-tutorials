extends Node

export(int) var map_width = 80
export(int) var map_height = 50
export(String) var world_seed = "Hello Godot!"
export(bool) var redraw setget redraw
export(int) var noise_octaves = 3
export(int) var noise_period = 3
export(float) var noise_persistence = 0.7
export(float) var noise_lacunarity = 0.4
export(float) var noise_threshold = 0.1

var tile_map : TileMap
var simplex_noise : OpenSimplexNoise = OpenSimplexNoise.new()

func _ready() -> void:
	self.tile_map = get_parent() as TileMap
	redraw()
	
func redraw(value = null):
	if tile_map == null:
		return
	clear()
	generate()
	
func clear():
	tile_map.clear()
	
func generate():
	simplex_noise.seed = self.world_seed.hash()
	simplex_noise.octaves = self.noise_octaves
	simplex_noise.period = self.noise_period
	simplex_noise.persistence = self.noise_persistence
	simplex_noise.lacunarity = self.noise_lacunarity
	for x in range(-self.map_width / 2, self.map_width / 2):
		for y in range(-self.map_height / 2, self.map_height / 2):
			if self.noise_threshold >= simplex_noise.get_noise_2d(x, y):
				_set_autotile(x, y)
	
func _set_autotile(x : int, y : int) -> void:
	self.tile_map.set_cell(x, y, _get_tile_id(), false, false, false, _get_autotile_coord(x, y))
	self.tile_map.update_bitmask_area(Vector2(x, y))
	self.tile_map.update_dirty_quadrants()
	
func _get_tile_id() -> int:
	var tile_set = self.tile_map.get_tileset()
	var tile_id = tile_set.get_tiles_ids()[0]
	var tile_name = tile_set.tile_get_name(tile_id)
	return tile_set.find_tile_by_name(tile_name)
	
func _get_autotile_coord(x : int, y : int) -> Vector2:
	return self.tile_map.get_cell_autotile_coord(x, y)
