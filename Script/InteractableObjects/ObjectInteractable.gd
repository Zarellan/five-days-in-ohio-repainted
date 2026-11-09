extends StaticBody3D
class_name ObjectInteractable

var hint:String = ""
func _ready() -> void:
	set_process(false)
	set_physics_process(false)
	pass

func activate():
	print("acto")

func overlap():
	pass

func unactive():
	pass
