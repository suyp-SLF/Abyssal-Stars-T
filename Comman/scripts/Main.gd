@tool
extends Node

const globalcfg: String = "res://Comman/config/cfg_global.cfg"

func _ready() -> void:
	pass
	
func start() -> void:
	print("user:// 的实际路径是: ", ProjectSettings.globalize_path("user://"))
	controllers_config()
	var layer0: TileMapLayer = G_Environment.CONTROLLER_MAP.add_layer_by_num(0)
	var layer1: TileMapLayer = G_Environment.CONTROLLER_MAP.add_layer_by_num(1)
	var layer2: TileMapLayer = G_Environment.CONTROLLER_MAP.add_layer_by_num(2)
	G_Environment.set_layer(layer0)
	
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
	G_Environment.CONTROLLER_INPUT.controller_code = "input"
	G_Environment.CONTROLLER_INPUT.set_path_config("")
	
	G_Environment.CONTROLLER_MAP.controller_code = "map"
	G_Environment.CONTROLLER_MAP.set_path_config("")
	
	G_Environment.CONTROLLER_PLAYER.controller_code = "player"
	G_Environment.CONTROLLER_PLAYER.set_path_config("res://CharacterSystem/PlayerSystem/config.cfg")
	G_Environment.CONTROLLER_PLAYER.set_path_sences("res://CharacterSystem/PlayerSystem/sences.cfg")
	
	G_Environment.CONTROLLER_ENEMY.controller_code = "enemy"
	G_Environment.CONTROLLER_ENEMY.set_path_config("res://CharacterSystem/PlayerSystem/config.cfg")
	G_Environment.CONTROLLER_ENEMY.set_path_sences("res://CharacterSystem/PlayerSystem/sences.cfg")
	
	G_Environment.CONTROLLER_CAMERA.controller_code = "camera"
	G_Environment.CONTROLLER_CAMERA.set_path_config("")
