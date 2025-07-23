extends CharacterBody2D
class_name character_

const SPEED = 30.0
const JUMP_VELOCITY = -400.0

@export var visual_pos = Vector2(0,0)
@export var actual_pos = Vector2(0,0)

#组件遍历树
@onready var component_dict: Dictionary

@onready var components: Node2D = $Components
@onready var actual: Node2D = $Actual
@onready var visual: Node2D = $Visual
#其他信息
@export var move_target: Vector2 = Vector2(0, 0)
@export var attack_taeget: Vector2 = Vector2(0, 0)

func _ready():
	# 配置视觉元素
	#setup_visual()
	_ready_after()

func _ready_after(): pass

func _physics_process(delta: float) -> void:
	visual_pos = position
	actual_pos = utils_map.vis_to_act(position)
	pass

func setup_visual():
	"""设置等距视觉表现"""
	scale = G_Environment.VISUAL_SCALE
	rotation_degrees = 0  # 标准等距角度
	
func add_component(component: component_):
	#增加组件子节点
	component.entity = self
	components.add_child(component)
	#组件树，用于快速查找以及使用
	component_dict.set(component.component_name, component)
	pass

func get_component(component_name: String) -> component_:
	var component = component_dict.get(component_name)
	return component
	
func dead():
	queue_free()
