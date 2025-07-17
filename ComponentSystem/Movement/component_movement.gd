# movement_component.gd
extends component_
class_name MovementComponent

#移动速度
@export var speed := 300
#加速度
@export var acceleration := 1500
#摩擦
@export var friction := 1200

func _ready_after() -> void:
	component_name = "component_movement"
	print(name + "移动组件加载")

func _physics_process(delta: float) -> void:
	action._execute(delta)
