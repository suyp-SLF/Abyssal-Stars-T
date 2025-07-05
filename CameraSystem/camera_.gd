extends Camera2D
class_name  Camera_

@export var target: Node2D
@export var smooth_speed = 1.0

func init(target: Node2D) -> void:
	self.target = target

func _physics_process(delta: float) -> void:
	if target:
		global_transform.origin = target.global_transform.origin.lerp(
			target.global_transform.origin, 
			smooth_speed * delta
		)
