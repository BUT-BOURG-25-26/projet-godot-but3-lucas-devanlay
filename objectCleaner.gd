extends Area3D

var previousPosition : Vector3

func _ready() -> void:
	previousPosition = Vector3(0,25,100)

func _process(delta: float) -> void:
	position = previousPosition

func _on_body_shape_entered(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	if(body is BaseBox or body is Spike ):
		print(body.name)
		body.queue_free()

func _on_area_shape_entered(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int) -> void:
	print(area.name)
	area.queue_free()
