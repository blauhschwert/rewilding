extends Node3D

@onready var debris = $Debris
@onready var smoke = $Smoke
@onready var fire = $Fire
@onready var explosion_sound = $ExplosionSound

func explode():
	debris.emitting = true
	smoke.emitting = true
	fire.emitting = true
	explosion_sound.play()
