class_name utils_bullet

const sences: String = "res://Bullet/sences.cfg"

static func init_normal_bullet() -> Bullet_:
	var sence = utils_sence.get_instance().getSence("bullet", sences, "normal")
	var ins = sence.instantiate()
	return ins
