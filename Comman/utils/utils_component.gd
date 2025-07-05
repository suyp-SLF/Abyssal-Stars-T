class_name utils_component

const sences: String = "res://ComponentSystem/sences.cfg"

static func init_healthy_component() -> component_:
	var sence = utils_sence.get_instance().getSence("component", sences, "healthy")
	var ins = sence.instantiate()
	return ins

static func init_attack_component() -> component_:
	var sence = utils_sence.get_instance().getSence("component", sences, "attack")
	var ins = sence.instantiate()
	return ins

static func init_movement_component() -> component_:
	var sence = utils_sence.get_instance().getSence("component", sences, "movement")
	var ins = sence.instantiate()
	return ins

static func init_shoot_component() -> component_:
	var sence = utils_sence.get_instance().getSence("component", sences, "shoot")
	var ins = sence.instantiate()
	return ins

static func init_detect_component() -> component_:
	var sence = utils_sence.get_instance().getSence("component", sences, "detect")
	var ins = sence.instantiate()
	return ins

static func add_component(character: CharacterBody2D, component: component_) -> void:
	character.add_component(component)
	pass
