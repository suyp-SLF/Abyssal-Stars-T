class_name utils_tile
extends Node

enum DIRECTIONAL_OBSTACLE {
	NONE = 0,
	FROM_LEFT = 1,
	FROM_RIGHT = 2,
	FROM_TOP = 3,
	FROM_BOTTOM = 4
}

var _tile := []
var _obstacles := []
var _directional_obstacles := {}
var _terrain_costs := {}

var dirs: Array = []

# 初始化网格
func add_tile(coord: Vector2i):
	if not coord in _tile:
		_tile.append(coord)

# 添加障碍物
func add_obstacle(coord: Vector2i):
	if not coord in _obstacles:
		_obstacles.append(coord)

# 设置单向障碍物
func set_directional_obstacle(coord: Vector2i, direction_type: int):
	_directional_obstacles[coord] = direction_type

# 设置地形消耗
func set_terrain_cost(coord: Vector2i, cost: int):
	_terrain_costs[coord] = cost

# 检查位置是否有效
func is_valid_position(coord: Vector2i) -> bool:
	return coord in _tile

func load_part_of_map(layer: TileMapLayer, move_points: int) -> Array:
	dirs = []
	for x in range(0, move_points, 1):
		var leftpoint = move_points - absi(x)
		for y in range(0, leftpoint, 1):
			add_dir(Vector2i(x, y))
		for y in range(0, -leftpoint, -1):
			add_dir(Vector2i(x, y))

	for x in range(0, -move_points, -1):
		var leftpoint = move_points - absi(x)
		for y in range(0, leftpoint, 1):
			add_dir(Vector2i(x, y))
		for y in range(0, -leftpoint, -1):
			add_dir(Vector2i(x, y))
	dirs.erase(Vector2i(0, 0))
	return dirs
func add_dir(dir: Vector2i):
	if not dir in dirs:
		dirs.append(dir)
	pass

# 主移动范围计算函数
func get_movable_positions(unit_coord: Vector2i, move_points: int) -> Array:
	return calculate_movable_tiles(unit_coord, move_points)

# 可视化可移动区域
func draw_movable_area(positions: Array, tilemap: TileMap, tile_index: int):
	tilemap.clear()
	for pos in positions:
		tilemap.set_cellv(pos, tile_index)

func calculate_movable_tiles(start_coord: Vector2i, move_points: int) -> Array:
	var reachable = []
	var cost_map = {}  # 记录到达每个位置的最低消耗
	var queue = []
	
	# 使用优先队列结构
	queue.push_back({"pos": start_coord, "cost": 0, "from": Vector2i.ZERO})
	cost_map[start_coord] = 0
	
	while not queue.is_empty():
		queue.sort_custom(Callable(self, "sort_by_cost"))  # 按消耗排序
		var current = queue.pop_front()
		
		reachable.append(current.pos)
		
		# 检查所有相邻方向
		for dir in [Vector2i.RIGHT, Vector2i.LEFT, Vector2i.DOWN, Vector2i.UP]:
			var next_pos = current.pos + dir
			
			# 跳过无效位置
			if not is_valid_position(next_pos):
				continue
				
			# 检查是否可通行（考虑移动方向）
			if not is_tile_passable(next_pos, current.pos):
				continue
				
			# 计算移动消耗
			var terrain_cost = _terrain_costs.get(next_pos, 1.0)
			var total_cost = current.cost + terrain_cost
			
			# 如果消耗超过移动力则跳过
			if total_cost > move_points:
				continue
				
			# 如果是更优路径则更新
			if not cost_map.has(next_pos) or total_cost < cost_map[next_pos]:
				cost_map[next_pos] = total_cost
				queue.push_back({
					"pos": next_pos, 
					"cost": total_cost,
					"from": current.pos
				})
	
	return reachable

# 优先队列排序函数
func sort_by_cost(a, b):
	return a["cost"] < b["cost"]

# 在你的网格管理类中添加这个方法
func is_tile_passable(cell_coord: Vector2i, moving_from: Vector2i = Vector2i.ZERO) -> bool:
	# 1. 检查是否是障碍物
	if cell_coord in _obstacles:
		return false
		
	# 2. 检查是否是单向障碍物
	if _directional_obstacles.has(cell_coord):
		var obstacle_type = _directional_obstacles[cell_coord]
		var move_direction = cell_coord - moving_from
		
		match obstacle_type:
			DIRECTIONAL_OBSTACLE.FROM_LEFT:
				if move_direction != Vector2i.RIGHT:
					return false
			DIRECTIONAL_OBSTACLE.FROM_RIGHT:
				if move_direction != Vector2i.LEFT:
					return false
			DIRECTIONAL_OBSTACLE.FROM_TOP:
				if move_direction != Vector2i.DOWN:
					return false
			DIRECTIONAL_OBSTACLE.FROM_BOTTOM:
				if move_direction != Vector2i.UP:
					return false
	
	# 3. 检查其他通行条件（如需要钥匙的门等）
	#if has_special_condition(cell_position):
		#return check_special_condition(cell_position)
		
	return true
