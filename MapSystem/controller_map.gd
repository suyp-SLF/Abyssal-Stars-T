extends Controller

var last_cell_pos;
var times = 2;
var curr_time = 0;

var grid_system

const ISOMETRIC = preload("res://MapSystem/res/Isometric.tres")

#背景层
@onready var backLayer: TileMapLayer = $Background
#指示层
@onready var showLayer: TileMapLayer = $Showground
#当前选定的层级
@onready var curr_layer: TileMapLayer

var astar := AStar2D.new()
var selected_cell: Vector2i
	
func _ready_after():
	curr_layer = backLayer
	#setup_astar()
	
func _GAME_EVENT(event_id: int, position: Vector2i, node: Node) -> void:
	pass
	
func _MOUSE_EVENT(type:String, position: Vector2):
	var cell_pos = curr_layer.local_to_map(position)
	#backLayer.erase_cell(cell_pos)
	#backLayer.erase_cell(cell_pos)
	pass
func get_down_layer(curr_layer: TileMapLayer) -> TileMapLayer:
	var layer_last = null
	var layers = self.get_children(false)
	for layer in layers:
		var instance_id = layer.get_instance_id()
		var curr_instance_id = curr_layer.get_instance_id()
		if instance_id == curr_instance_id:
			break
		layer_last = layer
	return layer_last
func get_up_layer(curr_layer: TileMapLayer) -> TileMapLayer:
	var layer_next = null
	var layers = self.get_children(false)
	for i in layers.size():
		var instance_id = layers[i].get_instance_id()
		var curr_instance_id = curr_layer.get_instance_id()
		if instance_id == curr_instance_id and layers.size() > i + 1:
			layer_next =  layers[i + 1]
			break
	return layer_next
#获得当前指定的层
func get_curr_layer() -> TileMapLayer:
	return curr_layer
#获得当前指定的层
func set_curr_layer(curr_layer: TileMapLayer) -> void:
	self.curr_layer = curr_layer
#获得指定层
func get_layer_by_name(layer_num: int) -> TileMapLayer:
	var children = self.get_children(false)
	for child in children:
		if child.name.casecmp_to("Layer" + str(layer_num)):
			return child
	return null
	
func get_layer_by_num(layer_num: int) -> TileMapLayer:
	var layers = self.get_children(false)
	return layers[layer_num]
	
#创建新层,名字为Layer0
func add_layer_by_num(layer_num: int) -> layer_:
	var layer = layer_.new()
	layer.position = Vector2(0, - layer_num * 500)
	layer.set_z_index(layer_num * 10)
	self.add_child(layer)
	layer.tile_set = ISOMETRIC
	for x in range(10):
		for y in range(10):
			layer.set_cell(Vector2i(x, y), 1, Vector2i(3, 0))
	layer.name = "Layer" + str(layer_num)
	return layer
	
#删除层,名字为Layer0
func del_layer_by_num(layer_num: int) -> bool:
	return false
	
func show_path(coords: Array) -> void:
	for coord in coords:
		showLayer.set_cell(coord, 1, Vector2i(4, 0))
	pass
func clear_show_layer() -> void:
	showLayer.clear()
	pass

func map_to_local(coord: Vector2i) -> Vector2:
	var position: Vector2 = curr_layer.map_to_local(coord) + Vector2(0, 8)
	return position;
	
func _destroy_tile(event_id: String, hit_pos: Vector2) -> void:
	if backLayer == null:
		return
			
	var cell_pos = backLayer.local_to_map(hit_pos)
	if "BB" == event_id and last_cell_pos == cell_pos:
		curr_time += 1
		if curr_time >= times:  # 修正判断条件
			curr_layer.erase_cell(cell_pos)  # 需要指定图层
			curr_time = 0
	if "FB" == event_id:
		curr_layer.erase_cell(cell_pos)
	else:
		curr_time = 1  # 新方块开始计数
	last_cell_pos = cell_pos  # 更新最后位置
	pass

func setup_tile():
	# 创建网格系统
	grid_system = utils_tile.new()
	var curr_player = main.player_controller.curr_player
	var speed = curr_player.P_speed
	var coord = curr_player.P_coord_current
	var dirs = grid_system.load_part_of_map(curr_layer, 2)
	for dir in dirs:
		var cell = coord + dir
		var tile_data = curr_layer.get_cell_tile_data(cell)
		if tile_data:
			grid_system.add_tile(cell)
			# 设置障碍物
			#grid_system.add_obstacle(Vector2(3, 3))
			#grid_system.add_obstacle(Vector2(4, 4))

			# 设置单向障碍物（只能从左侧进入）
			#grid_system.set_directional_obstacle(Vector2(5, 5), utils_tile.DIRECTIONAL_OBSTACLE.FROM_LEFT)

			# 设置不同地形消耗
			#grid_system.set_terrain_cost(Vector2(2, 2), 2.0)  # 沼泽
			#grid_system.set_terrain_cost(Vector2(6, 6), 0.5)  # 道路
	# 可视化
	#grid_system.draw_movable_area(movable_positions, $TileMap, 1)
	pass

func setup_astar():
	var rect = backLayer.get_used_rect()
	print("rect" + str(rect))
	# 1. 添加所有可通行的点
	var walkable_cells = []
	for y in range(rect.size.y):
		for x in range(rect.size.x):
			var cell = Vector2(x, y)
			var tile_data = backLayer.get_cell_tile_data(cell)
			if tile_data:
				print("瓦片类型:", tile_data.get_custom_data("type"))  # 如果有自定义数据
				var id = point_to_id(cell)
				astar.add_point(id, cell)
				#showLayer.set_cell(cell, 1, Vector2i(4, 0)) 
				walkable_cells.append(cell)
	
	# 2. 连接相邻的点
	for cell in walkable_cells:
		var id = point_to_id(cell)
		for dir in [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN]:
			var neighbor = cell + dir
			var neighbor_id = point_to_id(neighbor)
			if astar.has_point(neighbor_id):
				astar.connect_points(id, neighbor_id)

func find_able_tile(coord: Vector2i, speed: int) -> Array:
	# 计算移动范围
	var movable_positions = grid_system.get_movable_positions(coord, speed)
	return movable_positions

func point_to_id(point: Vector2i) -> int:
	# 将Vector2坐标转换为唯一ID
	return int(point.x + point.y * backLayer.get_used_rect().size.x)

func find_path_by_player(player: CharacterBody2D, position: Vector2) -> Array:
	var coord_start = player.P_coord_current
	var coord_end = curr_layer.local_to_map(position)
	return find_path_by_start(coord_start, coord_end)
	pass

func find_path_by_start(coord_start: Vector2i, coord_end: Vector2i) -> Array:
	var start_id = point_to_id(coord_start)
	var end_id = point_to_id(coord_end)
	
	#astar.connect_points(start_id, end_id, true)
	
	if astar.has_point(start_id) and astar.has_point(end_id):
		var path: Array = astar.get_point_path(start_id, end_id)
			
		show_path(path)
		return path
	return Array()

func get_ground_hight_by_position(world_pos: Vector3):
	var coord = curr_layer.local_to_map(Vector2(world_pos.x, world_pos.z))
	pass

# 获取世界坐标对应的单元格坐标 + 单元格内的局部位置（0~1范围）
func get_precise_tile_position(world_pos: Vector3) -> Dictionary:
	var cell: Vector2i = curr_layer.local_to_map(Vector2(world_pos.x, world_pos.z))
	var cell_world_pos: Vector2 = curr_layer.map_to_local(cell)  # 单元格左下角的世界坐标
	var cell_size: Vector2 = curr_layer.tile_set.tile_size       # 单元格尺寸（如 Vector2(16, 16)）
	
	# 计算坐标在单元格内的偏移比例（0~1）
	var offset_in_cell: Vector2 = (Vector2(world_pos.x, world_pos.z) - cell_world_pos) / cell_size
	
	return {
		"cell": cell,                         # 单元格坐标（Vector2i）
		"cell_world_pos": cell_world_pos,     # 单元格左下角的世界坐标（Vector2）
		"offset": offset_in_cell,             # 单元格内的标准化偏移（Vector2，0~1）
		"pixel_offset": (Vector2(world_pos.x, world_pos.z) - cell_world_pos)  # 像素级偏移（Vector2）
	}
