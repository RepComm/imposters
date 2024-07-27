extends Node3D

class_name Imposters

@export var generator: ImposterGenerator
#assumed each is the exact same scene / model
@export var hirez_placements: Array[Node3D] = []
@export var hirez_placements_target: Node3D

@export var lowrez_distance = 25

var textures: Array[ImageTexture]

var hirez_lowrez_map: Dictionary = {}

var pixel_size = 0.1

func _ready():
	if hirez_placements_target != null:
		var children = hirez_placements_target.get_children()
		hirez_placements.append_array(children)
	var imgheight = generator.viewport.size.x
	
	var first_placement = hirez_placements[0]
	textures = await generator.generate(first_placement)
	
	var height = generator.bounds.get_longest_axis_size()
	
	var pxsize = height / imgheight
	
	print("image height ", imgheight, " actual height: ", height, " px height ", pxsize)
	pixel_size = pxsize
	
	for hirez in hirez_placements:
		var lowrez = Imposter.new()#Sprite3D.new()
		lowrez.imposters = self
		lowrez.billboard = BaseMaterial3D.BILLBOARD_FIXED_Y
		lowrez.transparent = true
		lowrez.shaded = false
		
		lowrez.pixel_size = pixel_size
		add_child(lowrez)
		
		lowrez.global_position = hirez.global_position
		lowrez.global_position.y = generator.bounds.get_center().y
		
		
		hirez_lowrez_map[hirez] = lowrez
	
		#lowrez.set_script(Imposter)
		#lowrez.set_proper
		#(lowrez.get_script() as Imposter)
		lowrez.target_hirez = hirez
	return
