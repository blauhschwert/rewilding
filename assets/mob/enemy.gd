extends RigidBody3D

signal died

@export_range(3.0,5.0,0.5) var speed

var health = 3

@onready var bat_model: Node3D = %bat_model
@onready var player = get_node("/root/Game/Player") 

func _ready():
	randomize()
	speed = randi_range(3,5)

func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	direction.y = 0.0
	linear_velocity = direction * speed
	bat_model.rotation.y = Vector3.FORWARD.signed_angle_to(direction,Vector3.UP) + PI

func take_damage():
	bat_model.hurt()
	health -= 1
	
	if health == 0:
		set_physics_process(false)
		gravity_scale = 1.0
		var direction = -1.0 * global_position.direction_to(player.global_position)
		var randmow_upward_force = Vector3.UP * randf_range(1.0, 5.0)
		apply_central_impulse(direction * 10.0 + randmow_upward_force)
		$Timer.start(1.8)
		
		lock_rotation = false
		died.emit()


func _on_timer_timeout():
	queue_free()
