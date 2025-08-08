extends Controller
class_name UI

@export var alert_panel: RichTextLabel

var text: String

@onready var skill_list: HBoxContainer = $UI/Control/SkillList
@onready var option_button: OptionButton = $UI_game/Control/OptionButton

var config_path: String
var UI_PLAYER = load(config_path)

# UI脚本中
func _ready_after():
	controller_code = "UI"
	path_sences = "res://UISystem/sences.cfg"
	#连接摄像机信号
	G_Environment.connect("Camera", Callable(self, "_update_cameras"))
	pass

func _UI_EVENT(code: String, data: Variant)-> void:
	if ("update_controller" == code):
		movment_action_update(data)
	elif ("update_minimap" == code):
		update_minimap(data)
	elif ("update_wether" == code):
		update_wether(data)
	elif ("game_status" == code):
		game_status(data)
	elif ("developer" == code):
		developer(data)
		
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
func _ENV_EVENT(text: String, data: Variant) -> void:
	if ("update_wether" == code):
		update_wether(data)
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

func movment_action_update(array) -> void:
	if array:
		for index in array.size():
			option_button.add_item(array[index].code, index)

func update_minimap(positions) -> void:
	if positions:
		$UI_game/Control/mini_map.update_texture(positions)

func update_wether(index: int) -> void:
	$UI_game.update_wethers(index)

func game_status(status: int) -> void:
	if 0:
		#start page show
		$UI_start.show()
		$UI_game.hide()
		$UI_developer.hide()
	elif 1:
		#game page show
		$UI_start.hide()
		$UI_game.show()
		$UI_developer.hide()

func developer(display: bool) -> void:
	if display:
		$UI_developer.show()
	else:
		$UI_developer.hide()

func update_cameras(data: Array) -> void:
	pass
