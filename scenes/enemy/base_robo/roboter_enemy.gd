extends RigidBody3D

signal emit_damage(amount)
signal died

@export_category("Robo Ressource")
@export var enemy_data : RoboData

var max_health : int = 0
var cur_health : int = 0

@onready var roboter_model: Node3D = %roboter_model
@onready var player = get_node("/root/Game/Player")
@onready var progress_bar = %ProgressBar
@onready var close_attack = %CloseAttack

func _ready():
	roboter_model.create_robo_skin(enemy_data.robo_type)
	max_health = enemy_data.create_hp_stat()
	cur_health = max_health
	progress_bar.max_value = max_health
	create_character_stats(enemy_data)
	randomize()
	enemy_data.speed = randi_range(3,5)
	global_position.y = 0

func _physics_process(_delta):
	delta_health()
	var direction = global_position.direction_to(player.global_position)
	direction.y = 0.0
	linear_velocity = direction * enemy_data.speed
	roboter_model.rotation.y = Vector3.FORWARD.signed_angle_to(direction,Vector3.UP) + PI

func take_damage(p_amount : int):
	roboter_model.hurt()
	cur_health -= p_amount
	progress_bar.value -= p_amount 
	
	if cur_health == 0:
		set_physics_process(false)
		gravity_scale = 1.0
		var direction = -1.0 * global_position.direction_to(player.global_position)
		var randmow_upward_force = Vector3.UP * randf_range(1.0, 5.0)
		apply_central_impulse(direction * 10.0 + randmow_upward_force)
		$Timer.start(1.8)
		lock_rotation = false
		died.emit()


func create_character_stats(character_stats : RoboData) -> void:
	%LevelCounter.text = "LVL : " + str(character_stats.level)
	%HP.text = " HP : " + str(max_health) + " / " + str(cur_health)

func delta_health() -> void:
	%HP.text = " HP : " + str(max_health) + " / " + str(cur_health)

func _on_timer_timeout():
	queue_free()

func _on_ranged_attack_body_entered(body):
	if body is PlayerController:
		close_attack.explode()
		roboter_model.die()
		await close_attack.exploded
		emit_damage.emit(enemy_data.attack)
		queue_free()
