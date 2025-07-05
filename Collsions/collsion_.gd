extends Area2D

# 持有对父实体(角色)的引用
var entity: Node2D
@onready var component: component_ = $"../.."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	entity = component.entity
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
