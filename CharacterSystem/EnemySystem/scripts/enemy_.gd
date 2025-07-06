class_name enemy_
extends character_

@export var bullet_container: Node2D

#基本属性
@export var P_name: String = "Player"
@export var P_health: float = 100
@export var P_speed: int = 1


#角色状态
enum eu_state {ERROR, IDLE, MOVE}
#飞行状态
enum eu_jet {NONE, ON, OFF}
var keep_move: bool = false
var keep_move_velocity: Vector2i = Vector2i(0, 0)

var curr_layer

@export var state = eu_state.IDLE
@export var jet = eu_jet.OFF
var facing_right = true

func _ready_after():
	# 自动初始化所有组件
	for child in components.get_children():
		if child is component_:
			child.entity = self
	pass

func setup(config):
	P_health = config["health"]
	P_speed = config["speed"]
	MessageSystem.send(MessageSystem.MessageType.GAME_EVENT, {
		"id": MessageSystem.GAME_EVENT.PLAYER_CREATE,
		"position": Vector2i(0, 0),
		"node": self
	})

func _exit_tree() -> void:
	print("节点已从场景树移除，执行清理操作")
	MessageSystem.send(MessageSystem.MessageType.GAME_EVENT, {
		"id": MessageSystem.GAME_EVENT.PLAYER_DESTROY,
		"position": Vector2i(0, 0),
		"node": self
	})
