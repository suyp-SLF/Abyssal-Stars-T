extends component_
class_name ShootComponent

#子弹速度
@export var speed := 300
#冷却时间
@export var cooldown_time := 0.2
var can_shoot := true  # 是否允许射击

func _ready_after() -> void:
	print(name + "射击组件加载")
	$Coldtime.timeout.connect(_on_cooldown_timeout)
	$Coldtime.one_shot = true  # 设置为一次性计时器

func _physics_process(delta: float) -> void:
	var click = Input.is_action_pressed("click_left")
	if click:
		_shoot()

func _shoot():
	if can_shoot:
		# 执行射击逻辑
		print("射击!")
		if entity is CharacterBody2D:
			var bullet = utils_bullet.init_normal_bullet()
			BulletPoolBus.add_child(bullet)
			var mouse_pos = G_Environment.get_mouse_position_visual()
			bullet.init(entity.global_position, mouse_pos)
			bullet.visual.z_index = entity.z_index
			
		# 进入冷却
		can_shoot = false
		$Coldtime.start(cooldown_time)
	else:
		print("冷却中...")

func _on_cooldown_timeout():
	can_shoot = true
