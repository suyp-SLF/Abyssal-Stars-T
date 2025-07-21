extends component_
class_name HealthyComponent

# 健康组件
@export var max_healthy: float
@export var current_healthy: float
@onready var area_2d: Area2D = $Actual/Area2D

	
func take_damage(amount: float) -> void:
	current_healthy -= amount
	display_health()
	
func display_health() -> void:
	var cal: float = current_healthy/max_healthy
	$Actual/health.material.set_shader_parameter("health", cal)
	
func heal(amount: int) -> void:
	current_healthy = min(current_healthy + amount, max_healthy)

func _ready():
	area_2d
	max_healthy = 100
	current_healthy = 100
