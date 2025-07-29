extends Node2D

@onready var CONTROLLER_MAP
@onready var CONTROLLER_CAMERA
@onready var CONTROLLER_PLAYER
@onready var CONTROLLER_ENEMY
@onready	 var CONTROLLER_INPUT

@export var VISUAL_SCALE = 1.0  				# 标准2:1等距的y轴压缩
@export var VISUAL_ROTATION = 45            # 标准等距旋转角度

@export var layer: layer_ = null
@export var _character: character_ = null
@export var camera: Camera2D = null
#移动信息
@export var movement_action: int = 0
#扫描的实体
@export var entity_postions: PackedVector4Array = []
#天气
@export var _wethers_array: Array[int] = []

func controller_init() ->void:
	pass
func _ready() -> void:
	pass

func _init() -> void:
	pass

func set_visual_sacle(value: float):
	layer.set_visual_scale(value)
	VISUAL_SCALE = value

func set_layer(layer: layer_) -> void:
	CONTROLLER_MAP.set_curr_layer(layer)
	self.layer = layer
	
func get_layer() -> TileMapLayer:
	return layer

func set_player(player: CharacterBody2D) -> void:
	self.player = player

func set_character(charactor: character_) -> void:
	self._character = charactor
	
func get_character() -> character_:
	return _character
	
func set_wether(wethers_array: Array[int]) -> void:
	_wethers_array = wethers_array
	MessageSystem.send(MessageSystem.MessageType.WETHER_EVENT, {
		"code": "update_wether",
		"data": wethers_array
	})
	
func set_entity(entity_postions: PackedVector4Array) -> void:
	self.entity_postions = entity_postions
	MessageSystem.send(MessageSystem.MessageType.UI_EVENT, {
		"code": "update_minimap",
		"json": entity_postions
	})
	
func get_entity() -> PackedVector4Array:
	return entity_postions

func update_charactor():
	#获得当前控制角色的组件树
	var component = _character.get_component("component_movement")
	var actions = component.get_children(false)
	MessageSystem.send(MessageSystem.MessageType.UI_EVENT, {
		"code": "update_controller",
		"json": actions
	})
	pass

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

func set_movment_action(action_index: int) -> void:
	movement_action = action_index
	var component = _character.get_component("component_movement")
	component.set_action(action_index)
	pass
