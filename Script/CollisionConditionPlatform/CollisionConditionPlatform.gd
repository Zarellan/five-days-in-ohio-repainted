extends CollisionShape3D


var player:Node3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if (player.global_position.y-((player.get_node("CollisionShape3D") as CollisionShape3D).shape.height/2) >= global_position.y + shape.size.y/2):
		disabled = false
	else:
		disabled = true
	pass
