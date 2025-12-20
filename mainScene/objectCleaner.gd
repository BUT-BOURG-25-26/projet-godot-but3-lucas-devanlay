class_name ObjectCleaner
extends Area3D

var previousPosition : Vector3

func _ready() -> void:
	previousPosition = Vector3(0,25,100)

func _process(delta: float) -> void:
	position = previousPosition

func _on_body_shape_entered(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	if(body.global_position.z>10):
		body.queue_free()
	elif(body is BaseBox or body is Spike or body is MeshInstance3D ):
		body.queue_free()
