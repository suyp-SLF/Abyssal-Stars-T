extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass

func create_texture() -> void:
	# 1. 创建一个 Image（尺寸 256x256，单通道格式 FORMAT_RF 用于浮点数据）
	var image = Image.new()
	var width = 4
	var height = 3
	image.create(width, height, false, Image.FORMAT_RGBA8)  # RGBA8 格式（常用）

	# 2. 填充像素数据（示例：生成渐变纹理）
	image.lock()  # 开始编辑像素
	#for x in width:
		#for y in height:
			## 计算颜色（示例：基于 UV 坐标的渐变）
			#var r = 0.3       # R 通道 = X 坐标归一化
			#var g = 0.6     # G 通道 = Y 坐标归一化
			#var b = 0.02                    # B 通道固定值
			#var a = 1.0                    # Alpha 不透明
			#image.set_pixel(r, g, Color(r, g, b, a))
	image.set_pixel(0, 0, Color(0.3, 0.3, 0.02, 0.3))
	image.unlock()  # 结束编辑

	# 3. 转换为 Texture 并传入 Shader
	var dynamic_texture = ImageTexture.new()
	dynamic_texture.create_from_image(image)

	# 4. 获取材质并设置 uniform
	var material = $Sprite.material
	material.set_shader_param("detect_data", dynamic_texture)
