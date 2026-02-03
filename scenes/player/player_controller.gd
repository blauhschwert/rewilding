class_name PlayerController
extends CharacterBody3D

signal take_damage(amount)
signal health_finished

const MIN_RUN_VELOCITY := 1.0

@export var debug : bool = false
@export_category("Character Stats")
@export var health = 3 
@export_category("References")
@export var camera : CameraController
@export var camera_effects : CameraEffect
@export var state_chart : StateChart
@export var weaopon_controller : WeaponController
@export var standing_collision : CollisionShape3D
@export var crouching_collision : CollisionShape3D
@export var crouch_check : ShapeCast3D
@export var interaction_raycast : RayCast3D
@export_category("Movement Settings")
@export_group("Easing")
@export var acceleration : float = 0.2
@export var deceleration : float = 0.5
@export_group("Speed")
@export var default_speed : float = 3.5
@export var sprint_speed : float = 3.7
@export var crouch_speed : float = -5.0
@export_category("Camera Extras")
@export var sprint_field_of_view := 90.0
@export_category("Jump Settings")
@export var jump_velocity : float = 5.
@export var fall_velocity_threshold : float = -5.0
@export_category("Data Helpers")
@export var data_relative_velocity : Vector3

var _input_dir : Vector2 = Vector2.ZERO
var _movement_velocity : Vector3 = Vector3.ZERO
var sprint_modifier : float = 0.0
var crouch_modifier : float = 0.0
var speed : float = 0.0
var current_fall_velocity : float

var _target_speed := 0.0
var _target_fov := 0.0

@onready var shooting_point = %ShootingPoint
@onready var shooting_timer = %ShootingTimer
@onready var shooting_sound = %ShootingSound

@onready var _default_field_of_view := camera_effects.fov
@onready var _orginal_speed := default_speed

@onready var munition_label = %MunitionLabel
@onready var weapon_contoller = %WeaponContoller


func _ready():
	take_damage.connect(_take_damage)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_pressed("sprint") and velocity.length_squared() > MIN_RUN_VELOCITY:
		_target_speed = sprint_speed
		_target_fov = sprint_field_of_view
	else:
		_target_speed = _orginal_speed
		_target_fov = _default_field_of_view
	
	%InteractLabel.hide()
	if %RayCast3D.is_colliding():
		var target = $%RayCast3D.get_collider()
		if target.has_method("interact"):
			%InteractLabel.show()
			if Input.is_action_just_pressed("interactable"):
				target.interact()
	
	speed = lerp(default_speed, _target_speed, delta * acceleration)
	camera_effects.fov = lerp(camera_effects.fov, _target_fov, delta * acceleration)
	
	var speed_modifier = sprint_modifier + crouch_modifier
	speed = default_speed + speed_modifier
	
	_input_dir = Input.get_vector("move_left","move_right","move_forward","move_back")
	var current_velocity = Vector2(_movement_velocity.x, _movement_velocity.z)
	var direction = (transform.basis * Vector3(_input_dir.x, 0, _input_dir.y)).normalized()
	
	if direction:
		current_velocity = lerp(current_velocity, Vector2(direction.x, direction.z) * speed, acceleration)
	else:
		current_velocity = current_velocity.move_toward(Vector2.ZERO, deceleration)
		
	_movement_velocity = Vector3(current_velocity.x, velocity.y, current_velocity.y)
	
	velocity = _movement_velocity
		
	move_and_slide()
	
	#if Input.is_action_pressed("shoot") and %ShootingTimer.is_stopped():
		#shoot_bullet()

#func shoot_bullet():
	#const BULLET_3D = preload("res://scenes/player/bullet_3d.tscn")
	#var new_bullet = BULLET_3D.instantiate()
	#shooting_point.add_child(new_bullet)
	#
	#new_bullet.global_transform = shooting_point.global_transform
	#shooting_timer.start()
	#shooting_sound.play_shoot()

func _take_damage(amount) -> void:
	if health > 0:
		health -= amount
		print(health)
	else:
		health_finished.emit()


func update_rotation(rotation_input) -> void:
	global_transform.basis = Basis.from_euler(rotation_input)

func sprint() -> void:
	sprint_modifier = sprint_speed

func walk() -> void:
	sprint_modifier = 0.0

func stand() -> void:
	crouch_modifier = 0.0
	standing_collision.disabled = false
	crouching_collision.disabled = true

func crouch() -> void:
	crouch_modifier = crouch_speed
	standing_collision.disabled = true
	crouching_collision.disabled = false

func jump() -> void:
	velocity.y += jump_velocity

func check_fall_speed() -> bool:
	if current_fall_velocity < fall_velocity_threshold:
		current_fall_velocity = 0.0
		return true
	else:
		current_fall_velocity = 0.0
		return false

func _on_weapon_manager_send_ammo(cur_ammo):
	munition_label.text = "Munition : " + str(cur_ammo)
