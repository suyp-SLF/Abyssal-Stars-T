# movement_component.gd
extends component_
class_name DetectComponent
#范围
@export var scope = 200

var _execute_timer: float = 0.0

func _ready_after() -> void:
	component_name = "component_detect"
	print(name + "侦查组件加载")

func _physics_process(delta: float) -> void:
	action.visual.global_position = entity.visual_pos
	action.actual.global_position = entity.actual_pos
	_execute_timer += delta
	
	if _execute_timer >= 0.1:
		action._execute(delta)
		_execute_timer = 0.0

func display_map() -> void:
	pass
