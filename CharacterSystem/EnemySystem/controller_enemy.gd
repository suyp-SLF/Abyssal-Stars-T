extends Controller

#角色缓存移动
@onready var path := []

func _ready_after() -> void:
	pass
	
#接收信息
func _PLAYER_COMMAND(command: MessageSystem.PLAYER_COMMAND, velocity: Vector2) -> void:
	pass

func _GAME_EVENT(event_id: int, position: Vector2i, node: Node) -> void:
	pass
	
func _MOUSE_EVENT(type: String, position: Vector2) -> void:
	#var path = main.map_controller.find_path_by_player(curr_player, position)
	pass
		
#创建角色	
func createEnemy(type: String, layernum: int, coord: Vector2i) -> CharacterBody2D:
	var position: Vector2 = CONTROLLER_MAP.map_to_local(coord)
	var curr_layer = CONTROLLER_MAP.get_layer_by_num(layernum);
	var config = getEnemyConfig(type)
	# 加载场景资源
	var player_ = utils_sence.get_instance().getSence(controller_code, path_sences, "player_base")
	# 实例化场景
	var instance_player = player_.instantiate()
	instance_player.P_tag = "enemy"
	instance_player.set_position(position)
	if not config == {}:
		instance_player.setup(config)
	# 添加到当前场景
	add_child(instance_player)
	MessageSystem.send(MessageSystem.MessageType.GAME_EVENT, {
		"event_id": MessageSystem.GAME_EVENT.PLAYER_CREATE, 
		"position": position,
		"node": instance_player
	})
	return instance_player

func getEnemyConfig(type: String) -> Dictionary:
	print(path_config)
	var game_data = utils_file.load_dictionary(path_config, type)
	if game_data == {}:
		print("未找到人员配置数据，或人员数据未配置")
		return {}
	else:
		# 访问数据
		return game_data
