extends CanvasLayer

@export var alert_panel: RichTextLabel

var text: String

@onready var player_list: VBoxContainer = $UI/Control/PlayerList
@onready var skill_list: HBoxContainer = $UI/Control/SkillList

@export var path_sences: String = "res://UISystem/sences.cfg"

var config_path: String
var UI_PLAYER = load(config_path)

# UI脚本中
func _ready_after():
	pass

func _UI_ALERT(text: String)-> void:
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
	player_list.add_child(ins)
	ins.setup(label_name, health, speed)
	ins.name = label_name
	pass

func _on_h_slider_value_changed(value: float) -> void:
	G_Environment.VISUAL_SCALE = value
	pass # Replace with function body.

func _on_option_button_item_selected(index: int) -> void:
	G_Environment.movement_action = index
	pass # Replace with function body.
