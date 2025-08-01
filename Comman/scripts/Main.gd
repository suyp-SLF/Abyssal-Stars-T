extends Node

const globalcfg: String = "res://Comman/config/cfg_global.cfg"

func _init() -> void:
	pass

func _ready() -> void:
	controllers_config()
	G_Environment.CONTROLLER_MAP = %MapController
	G_Environment.CONTROLLER_CAMERA = %CameraController
	G_Environment.CONTROLLER_PLAYER = %PlayerController
	G_Environment.CONTROLLER_ENEMY = %EnemyController
	G_Environment.CONTROLLER_INPUT = %InputController
	
func start() -> void:
	MessageSystem.send(MessageSystem.MessageType.UI_EVENT, {
		"code": "game_status",
		"data": 1
	})
	
	print("user:// 的实际路径是: ", ProjectSettings.globalize_path("user://"))
	
	var layer0: TileMapLayer = G_Environment.CONTROLLER_MAP.add_layer_by_num(0)
	var layer1: TileMapLayer = G_Environment.CONTROLLER_MAP.add_layer_by_num(1)
	var layer2: TileMapLayer = G_Environment.CONTROLLER_MAP.add_layer_by_num(2)
	G_Environment.set_layer(layer2)
	
	layer0.update_internals()
	var player1 = G_Environment.CONTROLLER_PLAYER.createPlayer("robot1" ,"normal", 0, Vector2i(0, 0))
	var player2 = G_Environment.CONTROLLER_PLAYER.createPlayer("robot2", "normal", 0, Vector2i(10, 10))
	
	var enemy1 = G_Environment.CONTROLLER_ENEMY.createEnemy("normal", 0, Vector2i(5, 10))
	
	var detect_c2 = utils_component.init_detect_component()
	var health_c2 = utils_component.init_healthy_component()
	utils_component.add_component(enemy1, detect_c2)
	utils_component.add_component(enemy1, health_c2)
	
	var detect_c1 = utils_component.init_detect_component()
	var health_c1 = utils_component.init_healthy_component()
	utils_component.add_component(player2, detect_c1)
	utils_component.add_component(player2, health_c1)
	
	var move_c = utils_component.init_movement_component()
	var shoot_c = utils_component.init_shoot_component()
	var detect_c = utils_component.init_detect_component()
	var health_c = utils_component.init_healthy_component()
	utils_component.add_component(player1, move_c)
	utils_component.add_component(player1, shoot_c)
	utils_component.add_component(player1, detect_c)
	utils_component.add_component(player1, health_c)
	################安装摄像头
	var camera = utils_camera.init_normal_camera()
	camera.init(player1)
	utils_camera.add_camera(camera)
	################主要控制角色
	G_Environment.set_character(player1)
	G_Environment.update_charactor()
	pass
	
func controllers_config():
	pass
