extends VehicleBody3D

# 引擎参数
@export var max_engine_force := 600.0  # 最大驱动力(N)
@export var engine_power_curve : Curve  # 引擎功率曲线(转速-扭矩)

# 转向参数
@export var max_steering_angle := 0.35  # 最大转向角(弧度)
@export var steering_responsiveness := 2.0  # 转向响应速度

# 刹车参数
@export var max_brake_force := 15.0  # 最大刹车力(N)
@export var handbrake_force := 30.0  # 手刹力度

# 悬挂参数
@export var suspension_stiffness := 50.0  # 悬挂刚度
@export var suspension_max_force := 5000.0  # 悬挂最大支撑力

# 私有变量
var current_steering := 0.0
var current_gear := 1  # 当前档位
var rpm := 0.0  # 发动机转速

func _ready():
	# 初始化所有轮子设置
	setup_wheels()

func _physics_process(delta):
	process_input(delta)
	update_rpm(delta)

func process_input(delta):
	# 获取输入
	var steer_input = Input.get_axis("move_right", "move_left")
	var accel_input = Input.get_axis("move_down", "move_up")
	var handbrake = Input.is_action_pressed("handbrake")
	
	# 转向控制(渐进式转向)
	current_steering = lerp(
		current_steering,
		steer_input * max_steering_angle,
		steering_responsiveness * delta
	)
	steering = current_steering
	
	# 引擎和刹车控制
	if handbrake:
		# 手刹模式(后轮锁死)
		brake = handbrake_force
		engine_force = 0.0
	elif accel_input > 0:
		# 加速
		var power = engine_power_curve.sample(rpm) if engine_power_curve else 1.0
		engine_force = accel_input * max_engine_force * power
		brake = 0.0
	elif accel_input < 0:
		# 刹车/倒车
		engine_force = accel_input * max_engine_force * 0.3  # 倒车动力降低
		brake = abs(accel_input) * max_brake_force
	else:
		# 滑行
		engine_force = 0.0
		brake = 0.5  # 轻微刹车模拟阻力

func update_rpm(delta):
	# 计算发动机转速(简化版)
	var speed = linear_velocity.length()
	rpm = clamp(speed * 30.0, 800.0, 7000.0)  # 模拟800-7000转
	
	# 简单的换挡逻辑
	if rpm > 6000.0 and current_gear == 1:
		current_gear = 2
		max_engine_force *= 0.7  # 高档位扭矩降低
	elif rpm < 2000.0 and current_gear == 2:
		current_gear = 1
		max_engine_force *= 1.3  # 低档位扭矩增加

func setup_wheels():
	# 配置所有轮子的物理参数
	for wheel in get_children():
		if wheel is VehicleWheel3D:
			wheel.suspension_stiffness = suspension_stiffness
			wheel.suspension_max_force = suspension_max_force
			wheel.wheel_friction_slip = 2.0  # 轮胎摩擦力
			
			# 根据位置设置轮子属性
			if "Front" in wheel.name:
				wheel.steering = true
				wheel.engine_force = true  # 前驱车设置
			else:
				wheel.brake = true
				
			# 轮子视觉效果(可选)
			wheel.wheel_roll_influence = 0.1  # 减少侧倾影响
