class_name utils_map

static func world_to_cell(tileMap: TileMapLayer, world_pos: Vector3) -> Vector2i:
	var cell: Vector2i = tileMap.local_to_map(Vector2(world_pos.x, world_pos.z))
	return cell

static func cell_to_world(tileMap: TileMapLayer, cell: Vector2i) -> Vector2:
	var cell_world_pos: Vector2 = tileMap.map_to_local(cell) 
	return cell_world_pos

static func world_to_map(tileMap: TileMapLayer, world_pos: Vector3) -> Vector2:
	var cell_size = tileMap.tile_set.tile_size
	var map_pos: Vector2 = Vector2(world_pos.x, world_pos.z + world_pos.y) / Vector2(cell_size.y, cell_size.x)
	
	return map_pos

# 将平面坐标转换为斜面视角坐标
static func act_to_vis(act_pos: Vector2, height: float = 0) -> Vector2:
	return Vector2(
		act_pos.x,
		act_pos.y * G_Environment.VISUAL_SCALE + height
	)

# 将斜面视角坐标转回平面坐标
static func vis_to_act(vis_pos: Vector2, height: float = 0) -> Vector2:
	return Vector2(
		vis_pos.x,
		(vis_pos.y - height) / G_Environment.VISUAL_SCALE
	)
