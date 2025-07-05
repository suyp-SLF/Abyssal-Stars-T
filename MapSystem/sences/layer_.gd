extends TileMapLayer

func _ready() -> void:
	var tile_set1 = tile_set
	tile_set1.set_tile_size(Vector2(128, 128) * G_Environment.VISUAL_SCALE)
	pass
	
func _set_scale(value: float) -> void:
	G_Environment.VISUAL_SCALE = value
	tile_set.set_tile_size(Vector2(128, 128 * G_Environment.VISUAL_SCALE))
	pass
