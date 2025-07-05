extends Node2D

@export var VISUAL_SCALE = 1.0  # 标准2:1等距的y轴压缩
@export var VISUAL_ROTATION = 45            # 标准等距旋转角度

@export var layer: TileMapLayer = null
@export var player: CharacterBody2D = null
@export var camera: Camera2D = null

func set_layer(layer: TileMapLayer) -> void:
	CONTROLLER_MAP.set_curr_layer(layer)
	self.layer = layer
	
func get_layer() -> TileMapLayer:
	return layer

func set_player(player: CharacterBody2D) -> void:
	self.player = player
	
func get_player() -> CharacterBody2D:
	return player

func set_camera(camera: Camera2D) -> void:
	CONTROLLER_CAMERA.set_camera()
	self.camera = camera
	
func get_camera() -> Camera2D:
	return camera
	
func get_mouse_position_visual() -> Vector2:
	return get_global_mouse_position()
	
func get_mouse_position_actual() -> Vector2:
	var mos = get_global_mouse_position()
	return  Vector2(mos.x, mos.y / VISUAL_SCALE)
