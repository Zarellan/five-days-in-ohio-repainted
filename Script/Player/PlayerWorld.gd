extends CharacterBody3D
class_name PlayerWorld

const SPEED = 5.0
@export var JUMP_VELOCITY = 12
@export var gravity = 4
var cyclopeJump = 0
@export var cyclopejumpTolerance = 0.12
var mouseRelative

@export var head:Node3D
@export var camera:Camera3D

@export var raycast:RayCast3D
var offsetCameraIdle:Vector2
var isSprinting = false
var cameraVarX:float
var overrideOnFloor = false
func _ready() -> void:
	if (!DeviceCheckerUtil.IsUsingPhone()):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	GlobalSoundtrack.PlaySoundtrack("res://SoundTracks/Building Contraptions.ogg")
	#get_tree().set_auto_accept_quit(false)
	#Input.warp_mouse(Vector2(100, 100))
	
	cameraVarX = camera.rotation.x
	pass

func OnFloor():
	return is_on_floor() || overrideOnFloor
func SetPlayerMovePermission(permis:bool = true):
	canMove = permis
	canRotateMouse = permis
	if !permis:
		velocity = Vector3(0,velocity.y,0)
var canMove:bool = true
var canRotateMouse:bool = true
func rotate_view(relative: Vector2, sensitivity: float) -> void:
	if !canRotateMouse:
		return
	head.rotate_y(-relative.x * sensitivity)
	cameraVarX += -relative.y * sensitivity
	cameraVarX = clamp(cameraVarX,deg_to_rad(-90), deg_to_rad(60))
func _unhandled_input(event):
	if event is InputEventScreenDrag:
		if !Ui.virtualJoystick.get_global_rect().has_point(event.position):
			rotate_view(event.relative, 0.004)
	elif event is InputEventMouseMotion:
		rotate_view(event.relative, 0.004)
	pass
func _process(delta: float) -> void:
	if (is_instance_valid(current_target)\
	 && Input.is_action_just_pressed("activate")):
		current_target.activate()

var bobbingCameraY:float = 0.0
var bobbingSpeed:float = 0.6
var bobbingSizeDivide:float = 20
var SprintTiming:float = 0

var head1:Tween
var head2:Tween
var head3:Tween
var headPos1:Tween
var headPos2:Tween
var headPos3:Tween
var headٌRot1:Tween
var headRot2:Tween

var bobbedRun:bool = false
var currentRunning:bool = false
var footWalked:bool = false

var footSoundIndex:int = 0
func HeadBobbing(delta):
	if velocity.x != 0 || velocity.z != 0:
		if !isSprinting:
			bobbingCameraY += 20 * delta
			var bobInter:float = sin(bobbingCameraY*bobbingSpeed)
			camera.position.y = lerpf(camera.position.y,bobInter/bobbingSizeDivide,delta * 15.0)
			cameraOffsetRotationX = lerpf(cameraOffsetRotationX,0,delta*15)
			if (bobInter < -0.2):
				if (!footWalked):
					PlayAudioFoot()
					footWalked = true
			else:
				footWalked = false
		else:
			currentRunning = true
			if (!bobbedRun):
				RunHeadBop()
			bobbedRun = true
	else:
		footSoundIndex = 0
		timeIdleCameraOffset += delta
		bobbingCameraY = 0
		camera.position.y = lerpf(camera.position.y,0,delta*10)
		offsetCameraIdle = Vector2(cos(timeIdleCameraOffset * 1)/2,sin(timeIdleCameraOffset*0.7)/2)
func PlayAudioFoot(override:bool = false):
	GlobalAudio.PlayOneShot("res://Sounds/Footstep/Plank/"+str(footSoundIndex+1)+".ogg",-5,randf_range(0.95,1.05))
	footSoundIndex += 1
	if footSoundIndex > 3:
		footSoundIndex = 0

func RunHeadBop():
	head1 = TweenUtils.tweenCustom(self,cameraOffsetRotationX,-3.0,0.1,TweenUtils.Ease.OutSine,func(val):
		cameraOffsetRotationX = val)
	headPos1 = TweenUtils.tweenCustom(self,camera.position.y,-0.1,0.1,TweenUtils.Ease.OutSine,func(val):
		camera.position.y = val)
	head1.finished.connect(func():
		PlayAudioFoot(true)
		head2 = TweenUtils.tweenCustom(self,cameraOffsetRotationX+0.0,0.0,0.15,TweenUtils.Ease.OutSine,func(val):
			cameraOffsetRotationX = val)
		headPos2 = TweenUtils.tweenCustom(self,camera.position.y+0.0,0.0,0.15,TweenUtils.Ease.OutSine,func(val):
			camera.position.y = val)
		head2.finished.connect(func():
			head3 = TweenUtils.tweenCustom(self,cameraOffsetRotationX+0.0,-0.8,0.1,TweenUtils.Ease.InSine,func(val):
				cameraOffsetRotationX = val)
			footWalked = false
			headPos3 = TweenUtils.tweenCustom(self,camera.position.y+0.0,-0.05,0.1,TweenUtils.Ease.InSine,func(val):
				camera.position.y = val)
			head3.finished.connect(RunHeadBop))
		)
func StopRunBop():
	TweenUtils.StopTween(head1)
	TweenUtils.StopTween(head2)
	TweenUtils.StopTween(head3)
	TweenUtils.StopTween(headPos1)
	TweenUtils.StopTween(headPos2)
	TweenUtils.StopTween(headPos3)

	bobbedRun = false
var headJumpingY:float = 0
var jump_timer: float = 0.0
var cameraOffsetRotationX = 0
func HeadJumping(delta):
	jump_timer += delta
	
	if velocity.y > 0:
		if jump_timer < 0.1:
			cameraOffsetRotationX = lerpf(cameraOffsetRotationX, -5.0, delta * 20.0)
		else:
			cameraOffsetRotationX = lerpf(cameraOffsetRotationX, 0.0, delta * 5.0)
	else:
		cameraOffsetRotationX = lerpf(cameraOffsetRotationX, -velocity.y, delta * 3.0)
	bobbingCameraY = 0
	camera.position.y = lerpf(camera.position.y, 0, delta * 10)
var headJumpingY2:float = 0
var jump_timer2: float = 0.0
var cameraOffsetRotationX2 = 0
var headStumpAudioStart:bool = false
func HeadStumping(delta):
	jump_timer2 += delta
	if jump_timer2 < 0.1:
		cameraOffsetRotationX = lerpf(cameraOffsetRotationX, -5.0, delta * 15.0)
		camera.position.y = lerpf(camera.position.y, -0.5, delta * 15.0)
		headStumpAudioStart = false
	else:
		cameraOffsetRotationX = lerpf(cameraOffsetRotationX, 0, delta * 5.0)
		camera.position.y = lerpf(camera.position.y, 0, delta * 5.0)
		if (!headStumpAudioStart):
			footWalked = false
			PlayAudioFoot(true)
			headStumpAudioStart = true
	if isSprinting && camera.position.y > -0.13:
		stumpProcess = false
		if (!headStumpAudioStart):
			footWalked = false
			#PlayAudioFoot(true)
			headStumpAudioStart = true

		return
	if camera.position.y > -0.01:
		stumpProcess = false
var isJumping:bool = false
var stumpProcess:bool = false

func Jump():
	if !canMove:
		return
	if Input.is_action_just_pressed("ui_accept") and cyclopeJump < cyclopejumpTolerance:
		GlobalAudio.PlayOneShot("res://Sounds/Jump/Jump.ogg",-4,randf_range(0.90,1.10))
		velocity.y = JUMP_VELOCITY
		cyclopeJump = 99
		isJumping = true
func FloorCondition(delta):
	if OnFloor():
		cyclopeJump = 0
		if isJumping:
			stumpProcess = true
			jump_timer2 = 0.0
		isJumping = false
		jump_timer = 0.0
	cyclopeJump += delta

func MoveCondition():
	if !canMove:
		return
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var speedFinal = SPEED + (3 if isSprinting else 0)
	if direction:
		velocity.x = direction.x * speedFinal
		velocity.z = direction.z * speedFinal
	else:
		velocity.x = move_toward(velocity.x, 0, speedFinal)
		velocity.z = move_toward(velocity.z, 0, speedFinal)

var timeIdleCameraOffset:float = 0

var focusTarget:Node3D = null
var focusTargetOffset:Vector3 = Vector3.ZERO

func look_at_target(delta: float = 0.0) -> void:
	if !is_instance_valid(focusTarget):
		return
	
	var target_pos = focusTarget.global_position + focusTargetOffset
	var dir = (target_pos - camera.global_position).normalized()
	
	var target_pitch = asin(clamp(dir.y, -1.0, 1.0))
	target_pitch = clamp(target_pitch, deg_to_rad(-90), deg_to_rad(60))
	
	var flat_dir = Vector3(target_pos.x - head.global_position.x, 0, target_pos.z - head.global_position.z).normalized()
	if flat_dir.length_squared() > 0.001:
		var local_flat = global_transform.basis.inverse() * flat_dir
		var target_yaw = atan2(-local_flat.x, -local_flat.z)
		
		if delta > 0.0:
			head.rotation.y = lerp_angle(head.rotation.y, target_yaw, delta * 10.0)
			cameraVarX = lerp_angle(cameraVarX, target_pitch, delta * 10.0)
		else:
			head.rotation.y = target_yaw
			cameraVarX = target_pitch

var current_look_tween_x: Tween
var current_look_tween_y: Tween

func tweenCheck():
	return !isJumping && !currentRunning && (velocity.x == 0 && velocity.z == 0)
func tween_look_at(target_pos: Vector3, duration: float, easing_type: int = TweenUtils.Ease.OutSine) -> void:
	if !tweenCheck():
		return
	if current_look_tween_x and current_look_tween_x.is_valid():
		current_look_tween_x.kill()
	if current_look_tween_y and current_look_tween_y.is_valid():
		current_look_tween_y.kill()

	var dir = (target_pos - camera.global_position).normalized()
	var target_pitch = clamp(asin(clamp(dir.y, -1.0, 1.0)), deg_to_rad(-90), deg_to_rad(60))

	var flat_to_target = target_pos - global_position
	flat_to_target.y = 0
	
	if flat_to_target.length_squared() < 0.001:
		return
		
	var target_world_angle = atan2(-flat_to_target.x, -flat_to_target.z)
	var target_head_yaw = target_world_angle - global_rotation.y
	
	var current_yaw = head.rotation.y
	var diff = fposmod(target_head_yaw - current_yaw + PI, TAU) - PI
	var start_yaw = current_yaw
	var end_yaw = current_yaw + diff

	current_look_tween_x = TweenUtils.tweenCustom(
		self, 
		cameraVarX, 
		target_pitch, 
		duration,
		easing_type, 
		func(val): cameraVarX = val, 
		true
	)
	
	current_look_tween_y = TweenUtils.tweenCustom(
		self, 
		start_yaw, 
		end_yaw, 
		duration, 
		easing_type, 
		func(val): head.rotation.y = val, 
		true
	)
	mustLook = false
var mustLook:bool = false
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not OnFloor():
		velocity += (get_gravity() * gravity) * delta
	FloorCondition(delta)
	isSprinting = Input.is_action_pressed("Sprint") && !Input.is_action_pressed("ui_down")
	if Input.is_action_just_pressed("Sprint"):
		footWalked = false
	Jump()
	currentRunning = false
	if !stumpProcess:
		if !isJumping:
			HeadBobbing(delta)
		else:
			HeadJumping(delta)
	else:
		HeadStumping(delta)
	if (!currentRunning):
		StopRunBop()
	MoveCondition()
	look_at_target(delta)
	#if (Input.is_key_pressed(KEY_3)):
		#focusTarget = $"../StaticBody3D"
		#SetPlayerMovePermission(false)
	#if (mustLook):
		#SetPlayerMovePermission(false)
		#tween_look_at($"../StaticBody3D".position, 0.3,TweenUtils.Ease.InOutSine)
	camera.rotation.x = cameraVarX + deg_to_rad(cameraOffsetRotationX) + deg_to_rad(offsetCameraIdle.x)
	camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(60))
	camera.rotation.y = deg_to_rad(offsetCameraIdle.y)
	RaycastInteraction()
	move_and_slide()
	

var current_target: ObjectInteractable = null
func RaycastInteraction():
	var new_target: ObjectInteractable = null
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider is ObjectInteractable:
			new_target = collider
	if current_target != new_target:
		if (is_instance_valid(current_target)):
			current_target.unactive()
		current_target = new_target
		if (is_instance_valid(current_target)):
			current_target.overlap()
			Ui.get_node("HintText").text = current_target.hint
		else:
			Ui.get_node("HintText").text = ""
