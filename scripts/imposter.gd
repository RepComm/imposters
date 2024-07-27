extends Sprite3D

class_name Imposter

var imposters: Imposters
@export var camera: Camera3D
@export var target_hirez: Node3D

#var textures: Array[ImageTexture]
var lastidx = -1

func _ready():
	if camera == null:
		camera = get_viewport().get_camera_3d()
	return

var time_last = 0
var time_elapsed = 0
var time_max = 1

func update_visuals():
	
	var textures = imposters.textures
	if textures == null or len(textures)<1:
		return
	var d = camera.global_position.distance_to(global_position)
	if d > imposters.lowrez_distance and target_hirez != null:
		if not visible or target_hirez.visible:
			target_hirez.visible = false
			visible = true
	else:
		if visible or not target_hirez.visible:
			visible = false
			target_hirez.visible = true
	
	var object_to_camera = camera.global_position - global_position
	var angle = rad_to_deg(atan2(object_to_camera.z, object_to_camera.x))
	angle = wrapf(angle, 0, 360)
	
	var weight = angle / 360 #a / deg_to_rad(180)
	
	var idx = floori(weight * len(textures))

	if lastidx == -1 or lastidx != idx:
		lastidx = idx
		texture = textures[idx]
	return

func _process(delta):
	time_elapsed += delta
	if time_elapsed > time_max:
		time_elapsed = 0
		update_visuals()
	
	return
