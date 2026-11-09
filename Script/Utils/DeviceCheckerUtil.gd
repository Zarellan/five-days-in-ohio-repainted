extends Node
class_name DeviceCheckerUtil

static var is_phone : bool = OS.get_name() == "Android" || OS.get_name() == "iOS" || OS.has_feature("web_android") || OS.has_feature("web_ios")

static func IsUsingPhone() -> bool:
	return is_phone
