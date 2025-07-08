@tool
extends Node

#@onready var ui_controller: Node2D = $UIController
#@onready var input_controller: Node2D = $InputController
#@onready var player_controller: Node2D = $PlayerController
#@onready var map_controller: Node2D = $MapController
#@onready var bullet_controller: Node2D = $BulletController
#@onready var enemy_controller: Node2D = $EnemyController
#@onready var camera_controller: Node2D = $CameraController

@export var ui_controller: Node2D
@export var input_controller: Node2D
@export var player_controller: Node2D
@export var map_controller: Node2D
@export var bullet_controller: Node2D
@export var enemy_controller: Node2D
@export var camera_controller: Node2D

const globalcfg: String = "res://Comman/config/cfg_global.cfg"

@onready var controller_name = {
	"ui": ui_controller,
	"input": input_controller,
	"map": map_controller,
	"bullet": bullet_controller,
	"player": player_controller,
	"enemy": enemy_controller,
	"camera": camera_controller
}

func _ready() -> void:
	print("user:// 的实际路径是: ", ProjectSettings.globalize_path("user://"))
	controllers_config()
	var layer0: TileMapLayer = CONTROLLER_MAP.add_layer_by_num(0)
	var layer1: TileMapLayer = CONTROLLER_MAP.add_layer_by_num(1)
	var layer2: TileMapLayer = CONTROLLER_MAP.add_layer_by_num(2)
	G_Environment.set_layer(layer0)
	
	layer0.update_internals()
	var player1 = CONTROLLER_PLAYER.createPlayer("normal", 0, Vector2i(0, 0))
	var player2 = CONTROLLER_PLAYER.createPlayer("normal", 0, Vector2i(10, 10))
	
	var enemy1 = CONTROLLER_ENEMY.createEnemy("normal", 0, Vector2i(5, 10))
	
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
	G_Environment.player = player1
	
	var camera = utils_camera.init_normal_camera()
	camera.init(player1)
	utils_camera.add_camera(camera)
	
func controllers_config():
	input_controller.controller_code = "input"
	input_controller.set_path_config("")
	
	CONTROLLER_MAP.controller_code = "map"
	CONTROLLER_MAP.set_path_config("")
	
	CONTROLLER_PLAYER.controller_code = "player"
	CONTROLLER_PLAYER.set_path_config("res://CharacterSystem/PlayerSystem/config.cfg")
	CONTROLLER_PLAYER.set_path_sences("res://CharacterSystem/PlayerSystem/sences.cfg")
	
	CONTROLLER_ENEMY.controller_code = "enemy"
	CONTROLLER_ENEMY.set_path_config("res://CharacterSystem/PlayerSystem/config.cfg")
	CONTROLLER_ENEMY.set_path_sences("res://CharacterSystem/PlayerSystem/sences.cfg")
	
	camera_controller.controller_code = "camera"
	camera_controller.set_path_config("")
	
