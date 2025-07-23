extends component_
class_name HealthyComponent

# 健康组件
@export var max_healthy: float
@export var current_healthy: float
@onready var area_2d: Area2D = $Actual/Area2D

	
func take_damage(amount: float) -> void:
	current_healthy -= amount
	if current_healthy <= 0:
		entity.dead()
	display_health()
	
func display_health() -> void:
	var cal: float = current_healthy/max_healthy
	$Actual/healthnum.text = str(current_healthy)
	
	var unique_mat = create_unique_material($Actual/health.material)
	unique_mat.set_shader_parameter("health", cal)
	$Actual/health.material = unique_mat
	
func heal(amount: int) -> void:
	current_healthy = min(current_healthy + amount, max_healthy)

func _ready():
	area_2d
	max_healthy = 100
	current_healthy = 100
	display_health()

func create_unique_material(base_material):
	var new_mat = base_material.duplicate()
	new_mat.shader = base_material.shader.duplicate()
	return new_mat
