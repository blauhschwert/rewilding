class_name WeaponManager
extends Node

@export_category("Debug")
@export var is_debug : bool = true

@export_category("References")
@export var weapons: Dictionary[int, WeaponData] = {}
@export var player: PlayerController

var current_slot: int = 1

func _ready() -> void:
	add_to_group("weapon_manager")
	
	for i in range(0,10):
		var action_name = "weapon_" + str(i)
		if not InputMap.has_action(action_name):
			InputMap.add_action(action_name)
			var event = InputEventKey.new()
			event.keycode = KEY_0 + i 
			
			InputMap.action_add_event(action_name,event)
	
	# Initialize starting weapon
	call_deferred("initialize_starting_weapon")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP and current_slot < 2:
				current_slot += 1
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and current_slot > 1:
				current_slot -= 1
		switch_to_slot(current_slot)
	
	for i in range(0,9):
		if event.is_action_pressed("weapon_" + str(i)):
			switch_to_slot(i) 

func switch_to_slot(slot: int) -> void:
	var weapon_data = weapons.get(slot)
	
	if weapon_data and weapon_data.unlocked:
		current_slot = slot
		player.weaopon_controller.switch_weapon(weapon_data)

func use_ammo(slot: int, amount: int = 1) -> void:
	if slot in weapons:
		weapons[slot].ammo = max(0, weapons[slot].ammo - amount)
		
		if is_debug:
			print("Fired ", weapons[slot].weapon.weapon_name, "! Ammo:  ", weapons[slot].ammo)

func get_current_ammo() -> int:
	return weapons[current_slot].ammo 


func initialize_starting_weapon() -> void:
	# Find first unlocked weapon
	for slot in range(1, 10):
		if weapons.has(slot) and weapons[slot].unlocked:
			switch_to_slot(slot)
			return

func unlock_weapon(slot: int, weapon: Weapon) -> void:
	weapons[slot].weapon = weapon
	weapons[slot].unlocked = true
	weapons[slot].ammo = weapon.max_ammo
