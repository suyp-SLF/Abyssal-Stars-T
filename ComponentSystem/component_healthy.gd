extends component_
class_name HealthyComponent

# 健康组件
@export var max_healthy: float
@export var current_healthy: float = 0.0
@onready var area_2d: Area2D = $Actual/Area2D

@onready var health_num = $Visual/healthnum
@onready var health_bar = $Visual/healthbar

	
func take_damage(amount: float) -> void:
	current_healthy -= amount
	if current_healthy <= 0:
		entity.dead()
	display_health()
	
func display_health() -> void:
	var cal: float = current_healthy/max_healthy
	health_num.text = str(current_healthy)
	
	var unique_mat = create_unique_material(health_bar.material)
	unique_mat.set_shader_parameter("health", cal)
	health_bar.material = unique_mat
	
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
