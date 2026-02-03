class_name WeaponController
extends Node

signal send_ammo(max,cur)

@export_category("Helpers")
@export var is_debug : bool = false

@export var camera: Camera3D
@export var current_weapon : Weapon
@export var weapon_model_parent: Node3D
@export var weapon_state_chart : StateChart
@export var player_character : PlayerController

var current_weapon_model: Node3D
var current_ammo : int
var can_fire_next: bool = true
var fire_rate_timer: float = 0.0

@onready var shooting_timer = %ShootingTimer
@onready var shooting_point = %ShootingPoint

func _ready() -> void:
	if current_weapon:
		spawn_weapon_model()
		current_ammo = current_weapon.max_ammo

func _process(delta : float) -> void:
	if fire_rate_timer > 0:
		fire_rate_timer -= delta
		if fire_rate_timer <= 0:
			can_fire_next = true

func spawn_weapon_model():
	if current_weapon_model:
		current_weapon_model.queue_free()
	
	if current_weapon.weapon_model:
		current_weapon_model = current_weapon.weapon_model.instantiate()
		weapon_model_parent.add_child(current_weapon_model)
		current_weapon_model.position = current_weapon.weapon_position

func can_fire() -> bool:
	var weapon_data = Managers.weapon_manager.weapons[Managers.weapon_manager.current_slot]
	return weapon_data.ammo > 0 and can_fire_next


func fire_weapon() -> void:
	if can_fire():
		Managers.weapon_manager.use_ammo(Managers.weapon_manager.current_slot)
		current_ammo -= 1
		
		if is_debug:
			print("Fired! Ammo: ",current_ammo)
		
		#player_character.shoot_bullet()
		
		can_fire_next = false
		fire_rate_timer = 1.0 / current_weapon.fire_rate
	
	if current_weapon.is_hitscan:
		_perform_hitscan()
	else:
		_spawn_projectile()

func _perform_hitscan() -> void:
	if not camera:
		print("No camera assigned")
		return
	
	var space_state = camera.get_world_3d().direct_space_state
	var from = camera.global_position
	
	# Calculate accuracy spread (Inverse relationship)
	var accuraccy_spread = (100 - current_weapon.accuracy) / 1000.0
	
	for i in current_weapon.pellet_count:
		var forward = -camera.global_transform.basis.z
		
		var accuracy_x = randf_range(-accuraccy_spread, accuraccy_spread)
		var accuracy_y = randf_range(-accuraccy_spread, accuraccy_spread)
		var direcition = forward + Vector3(accuracy_x, accuracy_y, 0) * camera.global_transform.basis
	
		if current_weapon.pellet_count > 1:
			var spread_x = randf_range(-current_weapon.spread_angle, current_weapon.spread_angle)
			var spread_y = randf_range(-current_weapon.spread_angle, current_weapon.spread_angle)
			direcition += Vector3(spread_x, spread_y, 0) * camera.global_transform.basis
		
		var to = from + direcition * current_weapon.projectile_range
	
		# var to = from + forward * current_weapon.range
	
		var query = PhysicsRayQueryParameters3D.create(from, to)
		#query.collision_mask = 2
		var result = space_state.intersect_ray(query)
		
	
		if result:
			print("Hit: ", result.collider.name, "at ", result.position)
			_spawn_impact_marker(result.position)

func _spawn_impact_marker(position: Vector3) -> void:
	var marker = MeshInstance3D.new()
	var box = BoxMesh.new()
	box.size = Vector3(0.1, 0.1, 0.1)
	marker.mesh = box
	
	var material = StandardMaterial3D.new()
	material.albedo_color = Color.RED
	marker.set_surface_override_material(0, material)
	
	get_tree().current_scene.add_child(marker)
	marker.global_position = position
	
	get_tree().create_timer(2.0).timeout.connect(marker.queue_free)

func _spawn_projectile() -> void:
	if not current_weapon.projectile_scene:
		print("No projectile scene assigned!")
		return
	
	if not camera:
		print("No camera assigned!")
		return
	
	var projectile = current_weapon.projectile_scene.instantiate() as Projectile
	get_tree().current_scene.add_child(projectile)
	
	projectile.global_position = shooting_point.global_position
	
	var accuraccy_spread = (100 - current_weapon.accuracy) / 1000.0
	
	var foward = -camera.global_transform.basis.z
	
	var accuracy_x = randf_range(-accuraccy_spread, accuraccy_spread)
	var accuracy_y = randf_range(-accuraccy_spread, accuraccy_spread)
	var direction = foward + Vector3(accuracy_x, accuracy_y, 0)
	
	
	var velocity = direction * current_weapon.projectile_speed
	projectile.look_at(projectile.global_position + foward, Vector3.UP)
	
	projectile.setup(velocity, current_weapon.damage)

func switch_weapon(weapon_data: WeaponData) -> void:
	current_weapon = weapon_data.weapon
	
	if current_weapon_model:
		current_weapon_model.queue_free()
		
	spawn_weapon_model()
	
	weapon_state_chart.send_event("onIdle")
	
	if is_debug:
		print(current_weapon.weapon_name)

func has_ammo() -> bool:
	var weapon_data = Managers.weapon_manager.weapons[Managers.weapon_manager.current_slot]
	return weapon_data.ammo > 0
