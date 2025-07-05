# attack_component.gd
extends component_
class_name AttackComponent

@export var damage := 10
@export var attack_cooldown := 1.0

var can_attack := true

func input(event):
	if event.is_action_pressed("attack") and can_attack:
		perform_attack()
		can_attack = false
		#get_tree().create_timer(attack_cooldown).connect("timeout", self, "_on_cooldown_end")

func perform_attack():
	# 这里实现攻击逻辑，例如播放动画、检测命中等
	print("Attacking for ", damage, " damage!")
	# 实际游戏中可能会发射射线或检测碰撞区域

func _on_cooldown_end():
	can_attack = true
