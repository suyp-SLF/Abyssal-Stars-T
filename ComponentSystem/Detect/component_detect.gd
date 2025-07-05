# movement_component.gd
extends component_
class_name DetectComponent

@export var action: action_

#范围
@export var scope = 200

func _ready_after() -> void:
	print(name + "侦查组件加载")

func _physics_process(delta: float) -> void:
	action.visual.global_position = entity.visual_pos
	action.actual.global_position = entity.actual_pos
	action._execute(delta)
