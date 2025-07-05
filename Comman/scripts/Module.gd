class_name MODULE

enum MODULE_TYPE {
	PALYER
}
const MODULE_NAME = {
	MODULE_TYPE.PALYER:"player"
}

static func get_module_name(module_type: MODULE.MODULE_TYPE) -> String:
	return MODULE.MODULE_NAME.get(module_type, "UNKNOWN")
