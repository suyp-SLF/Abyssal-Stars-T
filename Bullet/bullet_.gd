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
	pass

func _on_lifetime_timeout():
	queue_free()
