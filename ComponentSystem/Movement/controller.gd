#被控制模块
extends action_

var _velocity := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _execute(delta: float) -> void:
	var speed = _component.speed
	var acceleration = _component.acceleration
	var friction = _component.friction
	var entity = _component.entity
	
	var input_vector := Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		#加速度计算
		_velocity = _velocity.move_toward(input_vector * speed, acceleration * delta)
	else:
		#不移动计算摩擦移动
		_velocity = _velocity.move_toward(Vector2.ZERO, friction * delta)
	
	if entity is CharacterBody2D:
		entity.velocity = _velocity
		entity.move_and_slide()
