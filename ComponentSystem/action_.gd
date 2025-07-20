extends Node
class_name action_

@onready var _component = get_parent()
@onready var visual: Node2D = $Visual
@onready var actual: Node2D = $Actual

var code = "action_"

func _execute(delta: float) -> void:
	print("未设置动作代码：" + name)

func _enter_tree() -> void:
	print("添加动作：" + name)
	
func _exit_tree() -> void:
	print("删除动作：" + name)
