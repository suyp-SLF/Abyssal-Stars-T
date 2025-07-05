class_name utils_file

static var Map_dict_sections = {} 

# 先定义函数
static func load_json_file(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		push_error("JSON文件不存在: " + path)
		return {}
	
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var error = json.parse(content)
	if error != OK:
		push_error("JSON解析错误: %s (行 %d)" % [json.get_error_message(), json.get_error_line()])
		return {}
	
	return json.get_data()
	
static func load_config_resource(path: String):
	if ResourceLoader.exists(path, "cfg"):
		return ResourceLoader.load(path)
	return null
	
static func save_settings():
	var config = ConfigFile.new()
	
	# 存储各种类型的值
	config.set_value("Player", "name", "Hero")
	config.set_value("Audio", "master_volume", 0.8)  # float类型
	config.set_value("Video", "fullscreen", true)
	config.set_value("Video", "resolution", Vector2i(1920, 1080))
	
	# 保存到用户目录
	var err = config.save("user://settings.cfg")
	if err != OK:
		push_error("保存配置失败: " + str(err))

static func load_settings(path: String) -> ConfigFile:
	var config = ConfigFile.new()
	var err = config.load(path)
	
	if err == OK:
		# 获取值，第二个参数是默认值
		return config
	else:
		print("使用默认配置，加载失败: ", err)
		return config
static func load_dictionary(path: String, section_name: String) -> Dictionary:
	var file_name = path
	var dict_section = {}
	dict_section = Map_dict_sections.get(file_name + section_name)
	if dict_section == null or dict_section == {}:
		var sections = load_settings(path)
		for section in sections.get_sections():
			# 获取每个小节的数据。
			dict_section = {}
			for key in sections.get_section_keys(section):
				var value = sections.get_value(section, key)
				dict_section.set(key, value)
			Map_dict_sections.set(file_name + section, dict_section)
		dict_section = Map_dict_sections.get(file_name + section_name)
		return dict_section
	else:
		return dict_section
	pass
