@tool
class_name EnemyAIComponent
extends Node

## 导出变量（可在编辑器配置）
@export var patrol_points: Array[Vector2] = [
	Vector2(100, 100),
	Vector2(400, 100),
	Vector2(400, 400),
	Vector2(100, 400)
]

@export_range(50.0, 1000.0) var sight_range: float = 200.0
@export_range(10.0, 200.0) var attack_range: float = 50.0
@export var debug: bool = true

var patrol_index: int = 0

## 初始化行为树
func setup_behavior_tree(enemy: CharacterBody2D) -> BehaviorTree:
	var bt := BehaviorTree.new()
	bt.name = "BehaviorTree"
	
	# 必须先添加到场景树再设置owner
	enemy.add_child(bt)
	bt.set_owner_instance(enemy)
	
	# 设置黑板初始数据
	if not Engine.is_editor_hint():
		var players := get_tree().get_nodes_in_group("Player")
		if players.size() > 0:
			bt.blackboard["player"] = players[0]
	
	# 构建行为树
	bt.root = (
		BehaviorTree.BTSelector.new()
		.add_child(create_death_branch())
		.add_child(create_attack_branch())
		.add_child(create_chase_branch())
		.add_child(create_patrol_branch())
	)
	
	return bt

## 创建死亡分支
func create_death_branch() -> BehaviorTree.BTSequence:
	return (
		BehaviorTree.BTSequence.new()
		.add_child(BehaviorTree.BTCondition.new(_condition_is_dead))
		.add_child(BehaviorTree.BTAction.new(_action_die))
	)

## 创建攻击分支
func create_attack_branch() -> BehaviorTree.BTSequence:
	return (
		BehaviorTree.BTSequence.new()
		.add_child(BehaviorTree.BTCondition.new(_condition_can_attack))
		.add_child(BehaviorTree.BTAction.new(_action_attack))
	)

## 创建追击分支
func create_chase_branch() -> BehaviorTree.BTSequence:
	return (
		BehaviorTree.BTSequence.new()
		.add_child(BehaviorTree.BTCondition.new(_condition_can_see_player))
	)

## 创建巡逻分支
func create_patrol_branch() -> BehaviorTree.BTAction:
	return BehaviorTree.BTAction.new(_action_patrol)

# ===== 条件方法 =====
func _condition_is_dead(bt: BehaviorTree) -> bool:
	var owner = bt.get_owner_instance()
	if not owner:
		return false
	var is_dead: bool = owner.health <= 0
	if debug: print("检查死亡: ", is_dead)
	return is_dead

func _condition_can_attack(bt: BehaviorTree) -> bool:
	var owner = bt.get_owner_instance()
	if not owner:
		return false
		
	var player: Node2D = bt.blackboard.get("player", null)
	var can_attack: bool = (
		player != null and
		owner.global_position.distance_to(player.global_position) < attack_range
	)
	if debug: print("检查攻击条件: ", can_attack)
	return can_attack

func _condition_can_see_player(bt: BehaviorTree) -> bool:
	var owner = bt.get_owner_instance()
	if not owner:
		return false
		
	var player: Node2D = bt.blackboard.get("player", null)
	var can_see: bool = (
		player != null and
		owner.global_position.distance_to(player.global_position) < sight_range
	)
	if debug: print("检查视觉条件: ", can_see)
	return can_see

# ===== 行为方法 =====
func _action_die(bt: BehaviorTree) -> void:
	var owner = bt.get_owner_instance()
	if not owner:
		return
		
	if debug: print(owner.name, " 死亡")
	owner.queue_free()

func _action_attack(bt: BehaviorTree) -> void:
	var owner = bt.get_owner_instance()
	if not owner:
		return
		
	if debug: print(owner.name, " 攻击玩家!")
	owner.velocity = Vector2.ZERO
	# 这里可以触发攻击动画或伤害逻辑


func _action_patrol(bt: BehaviorTree) -> void:
	var owner: CharacterBody2D = bt.get_owner_instance() as CharacterBody2D
	if not owner:
		return
	
	if patrol_points.is_empty():
		return
	
	var target: Vector2 = patrol_points[patrol_index]
	var direction: Vector2 = (target - owner.global_position).normalized()
	owner.velocity = direction * owner.speed
	
	if debug: print(owner.name, " 巡逻至: ", target, " 方向: ", direction)
	
	if owner.global_position.distance_to(target) < 5.0:
		patrol_index = (patrol_index + 1) % patrol_points.size()
