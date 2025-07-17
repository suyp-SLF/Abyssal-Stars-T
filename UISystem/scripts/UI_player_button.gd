extends Button

@onready var L_health: Label = $PlayerInfo/health/value
@onready var L_speed: Label = $PlayerInfo/speed/value
@onready var L_name: Label = $PlayerInfo/name/value

func _init():
	pass

func _ready() -> void:
	pass

func setup(label_name: String, health: float, speed: int) -> void:
	L_name.text = str(label_name)
	L_health.text = str(health)
	L_speed.text = str(speed)
	pass
