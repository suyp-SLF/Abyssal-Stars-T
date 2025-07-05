class_name utils_sence
extends RefCounted

static var _instance = null

static func get_instance():
	if _instance == null:
		_instance = utils_sence.new()
	return _instance

var _sences: Dictionary = {}
const _path_prefix: String = "res://Comman/config/cfg_sences_"
const _path_suffix: String = ".cfg"

func getSence(controller_code: String, res_path: String, sence_name: String) -> Resource:
	var sences = _sences.get(controller_code + sence_name)
	var dict = utils_file.load_dictionary(res_path, "sences")
	var path = dict.get(sence_name);
	if sences:
		return _sences.get(controller_code + sence_name)
	elif path != null:
		var res = load(path)
		print("未找到场景：" + sence_name + path)
		_sences.set(controller_code + sence_name, res)
		checkOver()
		return res
	else:
		return null
	pass
func getSencePath(module_name: String, sence_name: String) -> String:
	var cfg = utils_file.load_settings(_path_prefix + module_name + _path_suffix)
	var path = cfg.get_value( "normal", sence_name, "")
	return path
#检测缓存一共，后期优化删除不常用的资源
func checkOver():
	pass
