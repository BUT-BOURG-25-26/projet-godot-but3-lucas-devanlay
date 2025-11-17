class_name DirtBox
extends BaseBox
 
func _on_body_entered(body: Node3D) -> void:
	super(body)

func _on_body_shape_entered(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	super(body_rid, body, body_shape_index, local_shape_index)
