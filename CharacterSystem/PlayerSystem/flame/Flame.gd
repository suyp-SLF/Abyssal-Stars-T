extends GPUParticles2D

@export var max_particles: int = 150
@export var min_speed: float = 150.0
@export var max_speed: float = 300.0
@export var flame_length: float = 0.6

func _ready():
	setup_particles()

func setup_particles():
	
	var mat = ParticleProcessMaterial.new()
	
	# === 1. 基础运动参数 ===
	mat.direction = Vector3(1, 0, 0)
	mat.spread = 12.0
	mat.initial_velocity_min = min_speed
	mat.initial_velocity_max = max_speed
	mat.linear_accel_min = -250.0
	mat.linear_accel_max = -250.0
	
	# === 2. 粒子大小设置 ===
	mat.scale_min = 0.6
	mat.scale_max = 1.4
	
	# === 3. 正确设置大小曲线 ===
	var scale_curve = Curve.new()
	scale_curve.add_point(Vector2(0.0, 0.3))  # 出生时较小
	scale_curve.add_point(Vector2(0.2, 1.0))  # 快速膨胀
	scale_curve.add_point(Vector2(1.0, 0.0))  # 逐渐消失
	
	var curve_texture = CurveTexture.new()
	curve_texture.curve = scale_curve
	mat.scale_curve = curve_texture  # 关键修正点
	
	# === 4. 颜色设置 ===
	var gradient = Gradient.new()
	gradient.add_point(0.0, Color(1.0, 0.9, 0.3, 1.0))
	gradient.add_point(1.0, Color(1.0, 0.2, 0.0, 0.0))
	
	var gradient_texture = GradientTexture1D.new()
	gradient_texture.gradient = gradient
	mat.color_ramp = gradient_texture
	
	# === 5. 应用设置 ===
	process_material = mat
	amount = max_particles
	lifetime = flame_length
	emitting = true
