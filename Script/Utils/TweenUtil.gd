class_name TweenUtils

enum Ease{
	OutCirc,
	InSine,
	InOutSine,
	OutBack,
	InBack,
	InOutBack,
	InOutBounce,
	OutBounce,
	OutSine,
	linear
	}


static func isAlive(twen:Tween):
	if (twen != null && twen.is_valid()):
		return true
	return false

static func StopTween(twen:Tween):
	if (twen != null && twen.is_valid()):
		twen.kill()


static func EasingType(tween, easing:Ease):
	var eas = Tween.EASE_IN_OUT
	var transition = Tween.TRANS_LINEAR
	
	match easing:
		Ease.OutCirc: 
			eas = Tween.EASE_OUT
			transition = Tween.TRANS_CIRC
		Ease.InSine: 
			eas = Tween.EASE_IN
			transition = Tween.TRANS_SINE

		Ease.InOutSine:
			eas = Tween.EASE_IN_OUT
			transition = Tween.TRANS_SINE
		Ease.OutBack:
			eas = Tween.EASE_OUT
			transition = Tween.TRANS_BACK
		Ease.InBack:
			eas = Tween.EASE_IN
			transition = Tween.TRANS_BACK
		Ease.InOutBack:
			eas = Tween.EASE_IN_OUT
			transition = Tween.TRANS_BACK
		Ease.InOutBounce:
			eas = Tween.EASE_IN_OUT
			transition = Tween.TRANS_BOUNCE
		Ease.OutBounce:
			eas = Tween.EASE_OUT
			transition = Tween.TRANS_BOUNCE
		Ease.OutSine:
			eas = Tween.EASE_OUT
			transition = Tween.TRANS_SINE
		Ease.linear:
			eas = Tween.EASE_IN_OUT
			transition = Tween.TRANS_LINEAR
	tween.set_trans(transition).set_ease(eas)

static func tweenX(object,position,duration,eas):
	var tween = object.create_tween()
	var step = tween.tween_property(object, "position:x", position, duration)
	EasingType(step, eas)
	return tween

static func tweenY(object,position,duration,eas):
	var tween = object.create_tween()
	var step = tween.tween_property(object, "position:y", position, duration)
	EasingType(step, eas)
	return tween

static func tweenRotation(object,position,duration,eas):
	var tween = object.create_tween()
	var step = tween.tween_property(object, "rotation_degrees", position, duration)
	EasingType(step, eas)
	return tween

static func tweenColor(object,position,duration,eas):
	var tween = object.create_tween()
	var step = tween.tween_property(object, "modulate", position, duration)
	EasingType(step, eas)
	return tween

static func tweenColorRGB(object, color, duration, eas):
	var tween = object.create_tween()
	var currentColor = object.modulate
	var step = tween.tween_method(func(col):
		object.modulate.r = col.r
		object.modulate.g = col.g
		object.modulate.b = col.b
	, currentColor, color, duration)
	EasingType(step, eas)
	return tween
static func tweenColorRGBself(object, color, duration, eas):
	var tween = object.create_tween()
	var currentColor = object.self_modulate
	var step = tween.tween_method(func(col):
		object.self_modulate.r = col.r
		object.self_modulate.g = col.g
		object.self_modulate.b = col.b
	, currentColor, color, duration)
	EasingType(step, eas)
	return tween
static func tweenColorRGBPingPong(object,startValue,endValue,duration,eas):
	var tween = object.create_tween().set_loops(-1)
	var currentColor = object.modulate
	var step = tween.tween_method(func(col):
		object.modulate.r = col.r
		object.modulate.g = col.g
		object.modulate.b = col.b
	, currentColor, startValue, duration)
	EasingType(step, eas)
	var currentColor2 = startValue
	var step2 = tween.tween_method(func(col):
		object.modulate.r = col.r
		object.modulate.g = col.g
		object.modulate.b = col.b
	, currentColor2, endValue, duration)
	EasingType(step2, eas)
	return tween

static func tweenAlpha(object,position,duration,eas):
	var tween = object.create_tween()
	var step = tween.tween_property(object, "modulate:a", position, duration)
	EasingType(step, eas)
	return tween
	
static func tweenAlphaPingPong(object,startValue,endValue,duration,eas, instant = false):
	var tween = object.create_tween().set_loops(-1)
	
	if (instant):
		object.scale = startValue
	var step1 = tween.tween_property(object, "alpha", startValue, duration)
	EasingType(step1, eas)

	var step2 = tween.tween_property(object, "alpha", endValue, duration)
	EasingType(step2, eas)

	return tween
static func tweenAlphaSelf(object,position,duration,eas):
	var tween = object.create_tween()
	var step = tween.tween_property(object, "self_modulate:a", position, duration)
	EasingType(step, eas)
	return tween
static func tweenAlphaSelfPingPong(object,startValue,endValue,duration,eas, instant = false):
	var tween = object.create_tween().set_loops(-1)
	
	if (instant):
		object.scale = startValue
	var step1 = tween.tween_property(object, "self_modulate:a", startValue, duration)
	EasingType(step1, eas)

	var step2 = tween.tween_property(object, "self_modulate:a", endValue, duration)
	EasingType(step2, eas)

	return tween
	
# example: TweenUtils.tweenCustom(self, 0, 100.0, 2.0, TweenUtils.Ease.linear, func(val): print(val))
static func tweenCustom(owner: Node, current_val: Variant, target_val: Variant, duration: float, eas: int, setter_callable: Callable,usePhysics:bool = false) -> Tween:
	var tween = owner.create_tween()
	if usePhysics:
		tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	# Pass the lambda function directly to the engine backend
	var step = tween.tween_method(setter_callable, current_val, target_val, duration)
	
	EasingType(step, eas)
	return tween

static func tweenScale(object,position,duration,eas):
	var tween = object.create_tween()
	var step = tween.tween_property(object, "scale", position, duration)
	EasingType(step, eas)
	return tween

static func tweenScalePingPong(object,startValue,endValue,duration,eas, instant = false):
	var tween = object.create_tween().set_loops(-1)
	
	if (instant):
		object.scale = startValue
	var step1 = tween.tween_property(object, "scale", startValue, duration)
	EasingType(step1, eas)

	var step2 = tween.tween_property(object, "scale", endValue, duration)
	EasingType(step2, eas)

	return tween

static func tweenScaleX(object,position,duration,eas):
	var tween = object.create_tween()
	var step = tween.tween_property(object, "scale:x", position, duration)
	EasingType(step, eas)
	return tween

static func tweenScaleY(object,position,duration,eas):
	var tween = object.create_tween()
	var step = tween.tween_property(object, "scale:y", position, duration)
	EasingType(step, eas)
	return tween

static func tweenSkew(object,value,duration,eas):
	var tween = object.create_tween()
	var step = tween.tween_property(object, "skew", value, duration)
	EasingType(step, eas)
	return tween

static func tweenSkewPingPong(object,startValue,endValue,duration,eas, instant = false):
	var tween = object.create_tween().set_loops(-1)
	
	if (instant):
		object.skew = startValue
	var step1 = tween.tween_property(object, "skew", startValue, duration)
	EasingType(step1, eas)

	var step2 = tween.tween_property(object, "skew", endValue, duration)
	EasingType(step2, eas)

	return tween

static func tweenScrollY(object,position,duration,eas):
	var tween = object.create_tween()
	var step = tween.tween_property(object, "scroll_vertical", position, duration)
	EasingType(step, eas)
	return tween

static func tweenScrollYRichText(object,position,duration,eas):
	var tween = object.create_tween()
	var step = tween.tween_property(object, "scroll_vertical", position, duration)
	EasingType(step, eas)
	return tween

static func tweenShake(object, strength: float, frequency: float, duration: float, eas: Ease) -> Tween:
	var tween = object.create_tween()
	var original_pos = object.position
	
	var step = tween.tween_method(func(progress: float):
		var decay = 1.0 - (progress / duration)
		
		var random_x = sin(progress * frequency * PI * 2.0) * strength * decay
		var random_y = cos(progress * frequency * PI * 1.5) * strength * decay
		
		object.position = original_pos + Vector2(random_x, random_y)
	, 0.0, duration, duration)
	
	EasingType(step, eas)
	
	tween.tween_callback(func():
		if isAlive(tween):
			object.position = original_pos
	)
	
	return tween

static func tweenShakeRotation(object, strength: float, frequency: float, duration: float, eas: Ease) -> Tween:
	var tween = object.create_tween()
	var original_rotation = object.rotation_degrees
	
	# Use tween_method to oscillate rotation degrees over time with a decay
	var step = tween.tween_method(func(progress: float):
		# Calculate decay multiplier (1.0 down to 0.0) so the shake fades out nicely
		var decay = 1.0 - (progress / duration)
		
		# Generate a trigonometric offset using frequency and time
		var random_rot = sin(progress * frequency * PI * 2.0) * strength * decay
		
		object.rotation_degrees = original_rotation + random_rot
	, 0.0, duration, duration)
	
	# Apply easing to the overall progress
	EasingType(step, eas)
	
	# Guarantee it snaps cleanly back to the original rotation at the end
	tween.tween_callback(func():
		if isAlive(tween):
			object.rotation_degrees = original_rotation
	)
	
	return tween

static func tweenShakeX(object, strength: float, frequency: float, duration: float, eas: Ease) -> Tween:
	var tween = object.create_tween()
	var original_x = object.position.x
	
	var step = tween.tween_method(func(progress: float):
		var decay = 1.0 - (progress / duration)
		var random_x = sin(progress * frequency * PI * 2.0) * strength * decay
		object.position.x = original_x + random_x
	, 0.0, duration, duration)
	
	EasingType(step, eas)
	
	tween.tween_callback(func():
		if isAlive(tween):
			object.position.x = original_x
	)
	
	return tween

static func tweenShakeY(object, strength: float, frequency: float, duration: float, eas: Ease) -> Tween:
	var tween = object.create_tween()
	var original_y = object.position.y
	
	var step = tween.tween_method(func(progress: float):
		var decay = 1.0 - (progress / duration)
		var random_y = sin(progress * frequency * PI * 2.0) * strength * decay
		object.position.y = original_y + random_y
	, 0.0, duration, duration)
	
	EasingType(step, eas)
	
	tween.tween_callback(func():
		if isAlive(tween):
			object.position.y = original_y
	)
	
	return tween
