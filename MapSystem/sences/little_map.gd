class_name mini_map
extends ColorRect

var width = 50;
var heigh = 50;
var image = Image.create(width, heigh, false, Image.FORMAT_RGBAH)  # 使用 RGBA8 更常见
var sprite = Sprite2D.new()

func _ready():
	add_child(sprite)

func _physics_process(delta: float) -> void:
	
	var pos = Vector2(.5, .5)
	if G_Environment.get_character():
		pos = G_Environment.get_character().position
		$"../Label".text = str(pos) 
	# 更新图像内容（示例：动态噪声）
	

func update_texture(postions: PackedVector4Array):
	var iter = 0
	for vec in postions:
		print("Element ", iter, ": ", vec)
		image.set_pixel(iter, 0, Color(vec.x/2000, vec.y/2000, 0.02, 1.0))
		iter += 1
		print(vec.x / 1000, "  ", vec.y / 1000)
	var new_texture = ImageTexture.create_from_image(image);
	$"../color_map".texture = new_texture  # 重新赋值
	# 4. 获取材质并设置 uniform
	material.set_shader_parameter("detect_data", new_texture)
	material.set_shader_parameter("detect_count", iter)
