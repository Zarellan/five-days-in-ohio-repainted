extends ObjectInteractable
class_name Door

var door:Node3D
var doorOpened:bool = false
var player
var tweenDoor:Tween

func _ready() -> void:
	super._ready()
	door = get_parent()
	hint = "Press E to activate door"

func overlap():
	var mat = door.get_active_material(0)
	if mat and mat.next_pass:
		mat.next_pass.set_shader_parameter("enable_outline", true)
	
func unactive():
	var mat = door.get_active_material(0)
	if mat and mat.next_pass:
		mat.next_pass.set_shader_parameter("enable_outline", false)

func activate():
	player = get_tree().get_first_node_in_group("Player")
	TweenUtils.StopTween(tweenDoor)
	if !doorOpened:
		if !is_player_in_front(player, door):
			tweenDoor = TweenUtils.tweenCustom(self,door.rotation_degrees.y,90,0.7,TweenUtils.Ease.OutCirc,func(val):
				door.rotation_degrees.y = val)
		else:
			tweenDoor = TweenUtils.tweenCustom(self,door.rotation_degrees.y,-90,0.7,TweenUtils.Ease.OutCirc,func(val):
				door.rotation_degrees.y = val)
		doorOpened = true
	else:
		tweenDoor = TweenUtils.tweenCustom(self,door.rotation_degrees.y,0,0.7,TweenUtils.Ease.InSine,func(val):
				door.rotation_degrees.y = val)
		doorOpened = false

func is_player_in_front(p_node: Node3D, target_door: Node3D) -> bool:
	var dir_to_player = (p_node.global_position - target_door.global_position).normalized()
	var door_forward = -target_door.global_transform.basis.z 
	return door_forward.dot(dir_to_player) > 0
