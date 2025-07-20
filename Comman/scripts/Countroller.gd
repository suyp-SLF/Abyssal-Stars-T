class_name Controller
extends Node

@onready var controller_code = "default"
@onready var controller_name = "default"
@onready var main: Node2D = %Main
#alert
@onready var code: String = ""
@onready var json: Array = []
#update
@onready var upd_health: float = 0.0
@onready var upd_position: Vector2i = Vector2i(0, 0)
#command
@onready var cmd_command: MessageSystem.PLAYER_COMMAND = MessageSystem.PLAYER_COMMAND.IDLE
@onready var cmd_velocity: Vector2 = Vector2(0.0, 0.0)
#mouse
@onready var mos_type: String = ""
@onready var mos_position: Vector2 = Vector2(0.0, 0.0)
#event
@onready var evt_id: int = 0
@onready var evt_position: Vector2i = Vector2i(0, 0)
@onready var evt_node: Node

@export var path_sences: String = ""
@export var path_config: String = ""

func _ready() -> void:
	MessageSystem.get_instance().message_received.connect(_dispatcher)
	_ready_after()
	
#接收信息
func _dispatcher(type: int, data: Dictionary) -> void:
	match type:
		MessageSystem.MessageType.UI_EVENT:
			code = data.get("code", "")
			json = data.get("json", {})
			_UI_EVENT(code, json)
		MessageSystem.MessageType.PLAYER_UPDATE:
			upd_health = data["health"]
			upd_position = data["position"]
			_PLAYER_UPDATE(upd_health, upd_position)
		#接收玩家命令
		MessageSystem.MessageType.PLAYER_COMMAND:
			cmd_command = data["command"]
			cmd_velocity = data.get("velocity", Vector2i(0, 0))
			_PLAYER_COMMAND(cmd_command, cmd_velocity)
		MessageSystem.MessageType.MOUSE_EVENT:
			mos_type = data["type"]
			mos_position = data["position"]
			_MOUSE_EVENT(mos_type, mos_position)
		MessageSystem.MessageType.GAME_EVENT:
			evt_id = data["id"]
			evt_position = data["position"]
			evt_node = data["node"]
			_GAME_EVENT(evt_id, evt_position, evt_node)

func _ready_after() -> void:
	pass
func _UI_EVENT(text: String, json: Array) -> void:
	pass
func _PLAYER_UPDATE(health: float, position: Vector2i) -> void:
	pass
func _PLAYER_COMMAND(command: MessageSystem.PLAYER_COMMAND, velocity: Vector2) -> void:
	pass
func _MOUSE_EVENT(type: String, position: Vector2) -> void:
	pass
func _GAME_EVENT(id: int, position: Vector2i, node: Node) -> void:
	pass
func set_path_config(path_config: String):
	self.path_config = path_config
	pass
func set_path_sences(path_sences: String):
	self.path_sences = path_sences
	pass
