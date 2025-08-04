extends Node3D

@export var attack_range: float = 30.0
@onready var range_indicator: Decal = $RangeDecal
@onready var ray: RayCast3D = $RayCast3D
var red_ball: MeshInstance3D = null

func _ready():
	setup_range_indicator()
	
func _physics_process(delta: float) -> void:
	show_range()

func getDecalPoint() -> Vector3:
	var decal = ray.get_collision_point()  # 交点位置
	return decal

func setup_range_indicator():
	# 调整大小匹配攻击范围
	range_indicator.size = Vector3(attack_range * 2, 5.5, attack_range * 2)
	range_indicator.visible = false
	
	# 创建圆形材质（或在编辑器中预设）
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(1, 0, 0, 0.3)
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
	material.albedo_texture = create_circle_texture()
	range_indicator.texture_albedo = material.albedo_texture

func create_circle_texture() -> ImageTexture:
	var image = Image.create(512, 512, false, Image.FORMAT_RGBA8)
	image.fill(Color(0, 0, 0, 0))
	
	var center = Vector2(image.get_width() / 2, image.get_height() / 2)
	var radius = center.x * 0.9
	
	for x in image.get_width():
		for y in image.get_height():
			var dist = Vector2(x, y).distance_to(center)
			if dist <= radius and dist > radius - 10:
				image.set_pixel(x, y, Color(1, 0, 0, 0.7))
			elif dist <= radius:
				image.set_pixel(x, y, Color(1, 0, 0, 0.2))
	
	var texture = ImageTexture.create_from_image(image)
	return texture

func show_range():
	range_indicator.visible = true
	# 确保Decal贴在地面上
	range_indicator.global_position = getDecalPoint() + Vector3(0, 0.01, 0)
	spawn_or_move_red_ball(range_indicator.global_position)
	
func hide_range():
	range_indicator.visible = false
	
func spawn_or_move_red_ball(position: Vector3):
	if red_ball == null:
		red_ball = MeshInstance3D.new()
		var sphere_mesh = SphereMesh.new()
		sphere_mesh.radius = 0.5
		sphere_mesh.material = StandardMaterial3D.new()
		sphere_mesh.material.albedo_color = Color.RED
		red_ball.mesh = sphere_mesh
		add_child(red_ball)
	
	red_ball.position = position  # 更新位置
