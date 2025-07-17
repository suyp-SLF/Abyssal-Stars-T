class_name layer_
extends TileMapLayer

func _ready() -> void:
	var tile_set1 = tile_set
	if tile_set1:
		tile_set1.set_tile_size(Vector2(128, 128) * G_Environment.VISUAL_SCALE)
	pass
	
func set_visual_scale(value: float) -> void:
	tile_set.set_tile_size(Vector2(128, 128 * G_Environment.VISUAL_SCALE))
	pass
