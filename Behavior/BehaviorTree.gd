@tool
class_name BehaviorTree
extends Node

## 行为树黑板（共享数据存储）
var blackboard: Dictionary = {}

## 行为树根节点
var root: BTNode = null
## 弱引用所有者
var _weak_owner: WeakRef = null

## 设置所有者（使用弱引用避免循环引用）
func set_owner_instance(node: Node) -> void:
	_weak_owner = weakref(node)

## 获取所有者
func get_owner_instance() -> Node:
	if _weak_owner and _weak_owner.get_ref():
		return _weak_owner.get_ref()
	return null

func _process(delta: float) -> void:
	var owner: Node = get_owner_instance()
	if root and owner:
		var result: bool = root.execute(self)
		if Engine.is_editor_hint() and owner.get("debug_ai"):
			print("BehaviorTree 执行结果: ", result)

## 行为树节点基类
class BTNode:
	## 执行节点逻辑
	func execute(_bt: BehaviorTree) -> bool:
		return true

## 组合节点基类
class BTComposite extends BTNode:
	var children: Array[BTNode] = []
	
	## 链式调用添加子节点
	func add_child(node: BTNode) -> BTComposite:
		children.append(node)
		return self

## 序列节点（全部成功才算成功）
class BTSequence extends BTComposite:
	func execute(bt: BehaviorTree) -> bool:
		for child in children:
			if not child.execute(bt):
				return false
		return true

## 选择节点（一个成功即返回）
class BTSelector extends BTComposite:
	func execute(bt: BehaviorTree) -> bool:
		for child in children:
			if child.execute(bt):
				return true
		return false

## 条件节点
class BTCondition extends BTNode:
	var condition_callable: Callable
	
	func _init(callable: Callable):
		condition_callable = callable
	
	func execute(bt: BehaviorTree) -> bool:
		return condition_callable.call(bt)

## 行为节点
class BTAction extends BTNode:
	var action_callable: Callable
	
	func _init(callable: Callable):
		action_callable = callable
	
	func execute(bt: BehaviorTree) -> bool:
		action_callable.call(bt)
		return true

## 装饰器：结果取反
class BTInverter extends BTNode:
	var child: BTNode
	
	func _init(child_node: BTNode):
		child = child_node
	
	func execute(bt: BehaviorTree) -> bool:
		return not child.execute(bt)

## 装饰器：重复执行
class BTRepeater extends BTNode:
	var child: BTNode
	var times: int  # 0=无限
	var count: int = 0
	
	func _init(child_node: BTNode, repeat_times: int = 0):
		child = child_node
		times = repeat_times
	
	func execute(bt: BehaviorTree) -> bool:
		count = 0
		while times == 0 or count < times:
			if not child.execute(bt):
				return false
			count += 1
		return true
