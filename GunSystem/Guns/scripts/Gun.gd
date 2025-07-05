extends Node2D

@onready var ray = $RayCast2D
@onready var laser_line = $Line2D

var can_shoot = true
var shooting_interval = 0.5  # 冷却时间1秒
var shooting_current = 0
var is_shooting = false

func _ready():
	ray.target_position = Vector2(100, 0)  # 射线长度
	ray.enabled = false  # 默认不激活
	
	# 射线样式设置
	laser_line.width = 5.0  # 线宽
	laser_line.default_color = Color(1, 0.2, 0.2, 0.8)  # 红橙色
	laser_line.show()  # 默认隐藏

func _process(delta):
	# 让枪跟随鼠标旋转
	var mouse_pos = get_global_mouse_position();
	self.look_at(mouse_pos)
	
	# 根据朝向翻转枪的Sprite
	if mouse_pos.x < self.global_position.x:
		$GunSprite.flip_v = true  # 向左时翻转
	else:
		$GunSprite.flip_v = false
		
	if is_shooting:
		shooting_current += delta
		if(shooting_current > shooting_interval):
			shooting_current = 0
			#更新激光线
			#update_laser_line()
			#更新射线
			update_ray_line()
		

func _input(event):
	# 按下时开始持续射击
	if event.is_action_pressed("shoot"):
		start_shooting()
	# 释放时停止
	elif event.is_action_released("shoot"):
		stop_shooting()

func start_shooting():
	is_shooting = true
	# 立即显示激光（不要等待_process触发）
	laser_line.show()
	$MuzzleFlash.show()

func stop_shooting():
	is_shooting = false
	laser_line.hide()
	$MuzzleFlash.hide()

func update_laser_line():
		# 全部使用全局坐标计算
	var start = $MuzzleFlash.global_position
	var end = ray.get_collision_point() if ray.is_colliding() else \
			  ray.global_position + ray.target_position.rotated(ray.global_rotation)
	
	# 转换为Line2D的本地坐标空间
	laser_line.clear_points()
	laser_line.add_point(laser_line.to_local(start))
	laser_line.add_point(laser_line.to_local(end))
	
func update_ray_line():
	# 激活射线检测
	ray.force_raycast_update()  # 立即更新射线
	# 如果击中瓦片地图
	if ray.is_colliding():
		var collider = ray.get_collider()
		if collider is TileMapLayer:
			collision(collider)

func collision(tilemap : TileMapLayer):
	var hit_pos = ray.get_collision_point()
	# 在任何脚本中可调用
	MessageSystem.send(MessageSystem.MessageType.GAME_EVENT, {
		"event_id": "BB", 
		"hit_pos": hit_pos}
)
