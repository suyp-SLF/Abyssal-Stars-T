extends Bullet_

@onready var _ray: RayCast2D = $Actual/RayCast2D

func _physics_process(delta: float) -> void:
	_ray.force_raycast_update()
	
	if not has_hit:
		var vec = dir_vis * speed
		visual.global_position += vec * delta
		actual.global_position += utils_map.vis_to_act(vec) * delta
	# 检查碰撞
	if _ray.is_colliding():
		var hit_pos = _ray.get_collision_point()
		var target = _ray.get_collider()
		_handle_collision(hit_pos, target)

func _handle_collision(hit_pos: Vector2, target: Object):
	if has_hit:
		return
	has_hit = true
	# 对目标造成伤害（如果目标有相应方法）
	MessageSystem.send(MessageSystem.MessageType.GAME_EVENT, {
		"event_id": "FB", 
		"hit_pos": hit_pos})
	# 碰撞后立即消失或可以添加命中效果
	print(str(target.entity.P_tag) + "被攻击")
	queue_free()
