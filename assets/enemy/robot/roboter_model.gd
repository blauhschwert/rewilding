extends Node3D

@export var fire_skin : StandardMaterial3D
@export var ice_skin : StandardMaterial3D
@export var earth_skin : StandardMaterial3D

func hurt() -> void:
	%AnimationPlayer.play("hurt")

func die() -> void:
	%AnimationPlayer.play("die")

func create_robo_skin(p_value) -> void:
	match p_value:
		0:
			%body_1.set_surface_override_material(0,fire_skin)
			%mask.create_robo_skin(0)
		1:
			%body_1.set_surface_override_material(0,ice_skin)
			%mask.create_robo_skin(1)
		2:
			%body_1.set_surface_override_material(0,earth_skin)
			%mask.create_robo_skin(2)
	
