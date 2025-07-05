class_name Enemy
extends character_

## 敌人属性
@export var speed: float = 80.0
@export var health: int = 100
@export var debug_ai: bool = false

## 节点引用
@onready var ai_component: EnemyAIComponent = $EnemyAIComponent
var behavior_tree: BehaviorTree = null

func _ready() -> void:
	# 编辑器模式下不初始化行为树
	if Engine.is_editor_hint():
		return
	
	# 确保所有节点已准备好
	await get_tree().process_frame
	
	# 初始化AI组件
	ai_component.debug = debug_ai
	behavior_tree = ai_component.setup_behavior_tree(self)
	
	# 确保行为树已正确初始化
	if behavior_tree:
		behavior_tree.set_owner_instance(self)
		behavior_tree.process_mode = Node.PROCESS_MODE_PAUSABLE
	
	# 设置处理优先级
	process_priority = 10

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint() or not behavior_tree:
		return
	
	behavior_tree._process(delta)
	var _result: bool = move_and_slide()

## 受到伤害
func take_damage(amount: int) -> void:
	health -= amount
	print("%s 受到 %d 点伤害，剩余生命: %d" % [name, amount, health])
