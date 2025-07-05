extends Node2D

@export var bullet_scene: PackedScene
@export var fire_rate = 0.15  # 射击间隔(秒)
@export var bullet_speed = 800
@export var bullet_damage = 15
@export var bullet_lifetime = 0.8

var can_shoot = true

func _ready():
	$ShootTimer.wait_time = fire_rate
	$ShootTimer.timeout.connect(_on_shoot_timer_timeout)

func _process(_delta):
	# 让枪指向鼠标
	var mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)
	
	# 确保枪不会上下翻转
	if mouse_pos.x < global_position.x:
		scale.y = -1
	else:
		scale.y = 1

func shoot():
	var bullet = bullet_scene.instantiate()
	BulletPoolBus.add_child(bullet)
	
	# 设置子弹属性
	bullet.position = $Muzzle.global_position
	bullet.direction = (get_global_mouse_position() * Vector2(1, G_Environment.VISUAL_SCALE) - global_position).normalized()
	bullet.rotation = bullet.direction.angle()
	bullet.speed = bullet_speed
	bullet.damage = bullet_damage
	bullet.lifetime = bullet_lifetime

func _on_shoot_timer_timeout():
	can_shoot = true
