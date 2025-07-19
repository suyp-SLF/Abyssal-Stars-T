extends Controller

@export var cameras = []

func _ready_after() -> void:
	controller_code = "camera"
	set_path_config("")
	pass
