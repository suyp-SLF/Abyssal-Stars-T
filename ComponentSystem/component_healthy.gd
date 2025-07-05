extends component_
class_name HealthyComponent

# 健康组件
@export var max_healthy: int
@export var current_healthy: int

	
func take_damage(amount: int) -> void:
	current_healthy -= amount
	
func heal(amount: int) -> void:
	current_healthy = min(current_healthy + amount, max_healthy)

func _ready():
	max_healthy = 100
	current_healthy = 100
