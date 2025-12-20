extends Spike

func _on_body_entered(body: Node3D) -> void:
	super(body)

func _physics_process(delta: float) -> void:
	if(global_position.z>10):
		queue_free()
