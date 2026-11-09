extends Area3D

@export var step_top_y_offset: float = 0.02

var player: CharacterBody3D = null
var is_overlapping: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D and body.is_in_group("Player"):
		player = body as CharacterBody3D
		is_overlapping = true

func _on_body_exited(body: Node3D) -> void:
	if body == player:
		is_overlapping = false
		if is_instance_valid(player):
			player.overrideOnFloor = false
		player = null

func calculate_step_top_y(player_body: CharacterBody3D, area_col: CollisionShape3D) -> float:
	var box_shape := area_col.shape as BoxShape3D
	if not box_shape:
		return player_body.global_position.y
		
	# 1. Step top face in world space (Center Y + Half Box Height)
	var box_scale_y := area_col.global_transform.basis.get_scale().y
	var step_top_surface := area_col.global_position.y + ((box_shape.size.y * box_scale_y) / 2.0) + step_top_y_offset

	# 2. Player feet offset (Half Capsule Height + Local Shape Offset)
	var player_col := player_body.get_node_or_null("CollisionShape3D") as CollisionShape3D
	var half_capsule_height := 0.0
	var player_col_local_y := 0.0

	if player_col and player_col.shape is CapsuleShape3D:
		var capsule := player_col.shape as CapsuleShape3D
		var player_scale_y := player_col.global_transform.basis.get_scale().y
		half_capsule_height = (capsule.height * player_scale_y) / 2.0
		player_col_local_y = player_col.position.y

	# 3. Position player origin so capsule bottom rests on the surface
	return step_top_surface + half_capsule_height - player_col_local_y

func _physics_process(_delta: float) -> void:
	if is_instance_valid(player) and is_overlapping:
		if player.velocity.y > 0:
			player.overrideOnFloor = false
			return

		var area_collision := $CollisionShape3D as CollisionShape3D
		var top_y := calculate_step_top_y(player, area_collision)

		if player.global_position.y < top_y:
			player.global_position.y = top_y
			if player.velocity.y < 0:
				player.velocity.y = 0.0
			player.overrideOnFloor = true
		else:
			player.overrideOnFloor = false
