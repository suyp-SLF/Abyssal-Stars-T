class_name utils_camera

const sences: String = "res://CameraSystem/sences.cfg"

static func init_normal_camera() -> Camera_:
	var sence = utils_sence.get_instance().getSence("camera", sences, "normal")
	var ins = sence.instantiate()
	return ins

static func add_camera(camera: Camera_) -> void:
	G_Environment.CONTROLLER_CAMERA.add_child(camera)
