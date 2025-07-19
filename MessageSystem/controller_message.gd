# message_system.gd
extends Node
class_name MessageSystem  # 确保class_name唯一

# ========================
# 消息类型枚举
# ========================
enum MessageType {
	UI_EVENT,          	# {text: String, color: Color}
	PLAYER_UPDATE,     	# {health: float, position: Vector2}
	PLAYER_COMMAND,		# {velocity: Vector2, command: String}
	MOUSE_EVENT,			# {type: String, position: Vector2}}
	GAME_EVENT        	# {"id, position, node"}
}

enum GAME_EVENT {
	PLAYER_CREATE,
	PLAYER_DESTROY
}
enum PLAYER_COMMAND{
	NONE,
	MOVE,
	IDLE,
	JUMP,
	UP,
	DOWN
}
const GAME_EVENT_NAME = {
	GAME_EVENT.PLAYER_CREATE: "GAME_EVENT.PLAYER_CREATE -- 游戏事件.玩家创建",
	GAME_EVENT.PLAYER_DESTROY: "GAME_EVENT.PLAYER_DESTROY -- 游戏事件.玩家销毁",
}
const PLAYER_COMMAND_NAME = {
	PLAYER_COMMAND.MOVE: "PLAYER_COMMAND.MOVE -- 角色命令.移动",
	PLAYER_COMMAND.IDLE: "PLAYER_COMMAND.IDLE -- 角色命令.静止",
	PLAYER_COMMAND.UP: "PLAYER_COMMAND.UP -- 角色命令.向上",
	PLAYER_COMMAND.DOWN: "PLAYER_COMMAND.DOWN -- 角色命令.向下",
	PLAYER_COMMAND.JUMP: "PLAYER_COMMAND.JUMP -- 角色命令.跳跃",
}
static func print_game_event_name(value: int) -> String:
	return GAME_EVENT_NAME.get(value, "UNKNOWN")
static func print_player_command_name(value: int) -> String:
	return PLAYER_COMMAND_NAME.get(value, "UNKNOWN")
# ========================
# 单例管理
# ========================
static var _instance: MessageSystem = null

func _enter_tree():
	if _instance != null:
		push_error("MessageSystem created already -- 重复初始化！")
		queue_free()
		return
	_instance = self
	print("MessageSystem init -- 消息系统初始化完成")

static func get_instance() -> MessageSystem:
	if _instance == null:
		push_error("MessageSystem 未初始化！请检查：")
		push_error("1. 是否添加到 AutoLoad？")
		push_error("2. AutoLoad 名称是否为 'MessageSystem'？")
	return _instance

# ========================
# 消息核心功能
# ========================
signal message_received(type: int, data: Dictionary)

# 安全发送方法
static func send(type: MessageType, data: Dictionary):
	var instance = get_instance()
	if instance == null: return
	
	if not _validate_data(type, data):
		push_error("消息验证失败 | 类型: %s | 数据: %s" % [MessageType.keys()[type], data])
		return
	
	instance._emit_message(type, data)

# 内部消息发射
func _emit_message(type: int, data: Dictionary):
	emit_signal("message_received", type, data)

# ========================
# 数据验证
# ========================
static func _validate_data(type: MessageType, data: Dictionary) -> bool:
	var valid = false
	
	match type:
		#显示信息事件
		MessageType.UI_EVENT:
			valid = data.has("code")
		#角色状态更新事件
		MessageType.PLAYER_UPDATE:
			valid = data.has("health") \
			and data.has("position")
		#给角色发送命令事件
		MessageType.PLAYER_COMMAND:
			valid = data.has("command")
		#鼠标事件
		MessageType.MOUSE_EVENT:
			valid = data.has("type") \
			and data.has("position")
		#游戏事件
		MessageType.GAME_EVENT:
			valid = data.has("id") \
			and data.has("position") \
			and data.has("node")
	
	if not valid:
		push_warning("无效消息格式 | 类型: %s | 需要字段: %s" % [
			MessageType.keys()[type], 
			_get_required_fields(type)
		])
	return valid

static func _get_required_fields(type: MessageType) -> String:
	match type:
		MessageType.UI_EVENT:
			return "text, color"
		MessageType.PLAYER_UPDATE:
			return "health, position"
		MessageType.PLAYER_COMMAND:
			return "health, position"
		MessageType.GAME_EVENT:
			return "id, position, node"
		MessageType.MOUSE_EVENT:
			return "type, position"
		_:
			return "未知类型"
