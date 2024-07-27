extends Node3D

class_name ImposterGenerator

@export var start_degrees = 90
@export var end_degrees = 360+90
var camera_dist = 10
@export var subdivisions = 8

var viewport: SubViewport
var camera: Camera3D
var pivot: Node3D
var bounds = AABB()

func _ready():
	viewport = get_node("SubViewport")
	pivot = get_node("SubViewport/pivot")
	camera = get_node("SubViewport/pivot/Camera3D")
	
	return

func get_all_children(in_node,arr:=[]):
	arr.push_back(in_node)
	for child in in_node.get_children():
		arr = get_all_children(child,arr)
	return arr

func recalc_bounds():
	bounds = AABB()
	
	var children = get_all_children(self)
	for ch in children:
		if ch is VisualInstance3D:
			var b = ch.get_aabb()
			
			#make sure our bounds can fit all bounds found in our local scene
			bounds = bounds.merge( b )
	var center = bounds.get_center()
	#center our camera around
	pivot.global_position = center
	camera_dist = bounds.get_longest_axis_size() #/ deg_to_rad(camera.fov)
	
func generate(root: Node3D) -> Array[ImageTexture]:
	var old_parent = root.get_parent_node_3d()
	old_parent.remove_child(root)
	viewport.add_child(root)
	root.visible = true
	
	recalc_bounds()
	
	var image_textures: Array[ImageTexture] = []
	camera.position.z = camera_dist
	camera.size = camera_dist
	pivot.rotation_degrees.y = 0
	
	var weight = 0
	var degrees = 0
	for s in range(0, subdivisions):
		weight = float(s)/subdivisions
		degrees = lerpf(end_degrees, start_degrees, weight)
		#print("degrees", degrees, "idx", s)
		pivot.rotation_degrees.y = degrees
		
		viewport.render_target_clear_mode = SubViewport.CLEAR_MODE_ONCE
		viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
		
		await get_tree().process_frame
		var img = viewport.get_texture().get_image()
		
		var imgtex = ImageTexture.create_from_image(img)
		image_textures.append(imgtex)
		#imgtex.get_image().save_png(
			#str("./test_", s, ".png")
			#)
	
	if old_parent != null:
		viewport.remove_child(root)
		old_parent.add_child(root)
	
	return image_textures
