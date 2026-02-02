class_name Mask
extends Node3D

@export var fire_skin : StandardMaterial3D
@export var ice_skin : StandardMaterial3D
@export var earth_skin : StandardMaterial3D


func create_robo_skin(p_value) -> void:
	match p_value:
		0:
			%beveled_cuboid.set_surface_override_material(0,fire_skin)
		1:
			%beveled_cuboid.set_surface_override_material(0,ice_skin)
		2:
			%beveled_cuboid.set_surface_override_material(0,earth_skin)
