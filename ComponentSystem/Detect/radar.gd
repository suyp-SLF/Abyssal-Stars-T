extends action_

# 雷达旋转速度（度/秒）
@export var rotation_speed := 360.0
# 雷达最大距离
@export var max_distance := 1000.0
# 存储检测到的物体
var detected_objects := []
var time = 0;

@export var area: Area2D

func _ready() -> void:
	pass

func _execute(delta: float) -> void:
	 # 持续获取重叠的 Area2D
	var overlapping_areas = area.get_overlapping_areas()
	var postions: PackedVector4Array =  []
	
	for area in overlapping_areas:
		#if ("entity" in area && area.entity.P_tag == "Player"):
		if ("entity" in area):
			print("当前重叠的 Area2D:", area.entity.position)
			var position = Vector4(
				(_component.entity.position.x - area.entity.position.x),
				(_component.entity.position.y - area.entity.position.y),
				0.02,
				1
			)
			postions.append(position)
	G_Environment.set_entity(postions)
	# 绘制雷达效果（可选）
	_draw()
	
func _draw():
	pass
