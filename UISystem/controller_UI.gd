extends Controller

@export var alert_panel: RichTextLabel

var text: String

@onready var skill_list: HBoxContainer = $UI/Control/SkillList
@onready var option_button: OptionButton = $Control/OptionButton

var config_path: String
var UI_PLAYER = load(config_path)

# UI脚本中
func _ready_after():
	controller_code = "UI"
	path_sences = "res://UISystem/sences.cfg"
	pass

func _UI_EVENT(text: String)-> void:
	movment_action_update()
	pass
func _PLAYER_UPDATE(health: float, position: Vector2i) -> void:
	pass
func _PLAYER_COMMAND(command: MessageSystem.PLAYER_COMMAND, velocity: Vector2) -> void:
	var event_text := "[b]命令[/b]: %s\n[b]速度[/b]: (%d, %d)" % [
		command,
		int(velocity.x),
		int(velocity.y)]
	pass
func _MOUSE_EVENT(type: String, position: Vector2) -> void:
	var event_text := "[b]类型[/b]: %s\n[b]位置[/b]: (%d, %d)" % [
		type,
		int(position.x),
		int(position.y)]
	pass
func _GAME_EVENT(id: int, position: Vector2i, node: Node) -> void:
	print(MessageSystem.print_game_event_name(id) + "->" + node.P_name)
	
	var event_text := "[b]事件[/b]: %s\n[b]位置[/b]: (%d, %d)" % [
		id,
		int(position.x),
		int(position.y)]
	match id:
		MessageSystem.GAME_EVENT.PLAYER_CREATE:
			addLabel(node)
			pass
	pass

func addLabel(player: player_):
	var player_id = player.get_instance_id()
	var UI_PLAYER = utils_sence.get_instance().getSence("UI", path_sences, "UI_player_button")
	var label_name: String = "Player#" + str(player_id)
	var health = player.P_health
	var speed = player.P_speed
	var ins = UI_PLAYER.instantiate();	
	#if ins:
		#ins.setup(label_name, health, speed)
		#ins.name = label_name
	pass
##########################
####################所有的按钮方法
##########################
func _visual_sacle(value: float) -> void:
	G_Environment.set_visual_sacle(value)
	pass

func _movment_action_selected(index: int) -> void:
	G_Environment.set_movment_action(index)
	pass

func movment_action_update() -> void:

	option_button.add_item("123", 1)
	option_button.add_item("321", 0)
	pass 
