extends CanvasLayer

@export var phoneControls:Control
@export var virtualJoystick:VirtualJoystick
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !DeviceCheckerUtil.IsUsingPhone():
		phoneControls.queue_free()
	set_process(false)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
