extends Node
class_name Bullet_

@export var speed = 800
@export var damage = 10
@export var lifetime = 1.0

var dir_vis = Vector2.RIGHT
var dir_act = Vector2.RIGHT

@onready var visual: Node2D = $Visual
@onready var actual: Area2D = $Actual

var has_hit = false

func _ready():
	# 设置子弹生命周期
	$Lifetime.wait_time = lifetime
	$Lifetime.start()
	$Lifetime.timeout.connect(_on_lifetime_timeout)

func init(from: Vector2, to: Vector2) -> void:
	dir_vis = (to - from).normalized()
	dir_act = (utils_map.vis_to_act(to, 0) - utils_map.vis_to_act(from, 0)).normalized()
	visual.global_position = from
	visual.look_at(to)
	actual.global_position = utils_map.vis_to_act(from)
	actual.look_at(utils_map.vis_to_act(to, 0))

func _physics_process(delta):
	$Actual/RayCast2D.force_raycast_update()
	
	if not has_hit:
		var vec = dir_vis * speed
		visual.global_position += vec * delta
		actual.global_position += utils_map.vis_to_act(vec) * delta
	# 检查碰撞
	if $Actual/RayCast2D.is_colliding():
		var hit_pos = $Actual/RayCast2D.get_collision_point()
		_handle_collision(hit_pos)

func _handle_collision(hit_pos):
	if has_hit:
		return
	has_hit = true
	# 对目标造成伤害（如果目标有相应方法）
	MessageSystem.send(MessageSystem.MessageType.GAME_EVENT, {
		"event_id": "FB", 
		"hit_pos": hit_pos})
	# 碰撞后立即消失或可以添加命中效果
	queue_free()

func _on_lifetime_timeout():
	queue_free()
