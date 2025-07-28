extends Control


# Called when the node enters the scene tree for the first time.
@onready var rain: ColorRect = $rain


func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_wether():
	rain.show()

func add_rain():
	rain.show()

func remove_rain():
	rain.hide()
