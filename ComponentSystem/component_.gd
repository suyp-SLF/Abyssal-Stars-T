# component.gd
class_name component_
extends Node

# 持有对父实体(角色)的引用
var entity: Node2D
@onready var visual: Node2D = $Visual
@onready var actual: Node2D = $Actual

func _ready() -> void:
	print(name + "通用组件加载--组件连接父节点")
	# 获取父实体(角色节点)
	#entity = get_parent()
	# 验证父节点是否是期望的类型
	assert(entity is CharacterBody2D or entity is Area2D, 
		   "Component must be child of a character node")
	_ready_after()

func _ready_after() -> void: pass

# 可以被重写的生命周期方法
func _physics_process(delta: float) -> void: 
	visual.global_position = entity.visual_pos
	actual.global_position = entity.actual_pos
	pass
func _process(delta: float) -> void: pass
func _input(event: InputEvent) -> void: pass
