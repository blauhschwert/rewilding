class_name StepHandlerComponent
extends Node

@export_category("References")
@export var player : PlayerController
@export_category("Step Settings")
@export var surface_threshold : float = 0.3


func handle_step_climbing():
	for i in player.get_slide_collision_count():
		var collision = player.get_slide_collision(i)
		if _check_collision_normal(collision):
			prints("Vertical Collision Found!", collision.get_normal()) 
			break
		else:
			print("No vertical collision detected")

func _check_collision_normal(collision : KinematicCollision3D):
	var normal = collision.get_normal()
	if abs(normal.y) > surface_threshold:
		return false
	return true

#func _is_vertical_surface(collision: KinematicCollision3D) -> bool:
	#var normal = collision.get_normal()
	#if abs(normal.y) <= surface_threshold:
		##step_status = "CollisionShape: Verical Collision Found!" + str(normal)
		#return true
	#
	#return _check_collision_surface(collision)
	
