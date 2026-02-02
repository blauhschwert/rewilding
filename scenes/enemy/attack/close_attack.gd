class_name RangedAttack
extends Area3D

signal exploded

@onready var explosion = $Explosion

func explode():
	explosion.explode()
	await get_tree().create_timer(1.2).timeout
	exploded.emit()
