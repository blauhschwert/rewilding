class_name AttackBuff
extends Resource

@export_enum("Fire","Ice", "Earth") var buff_type: int

@export var buff_title : String = ""
@export var buff_damage : int = 0
@export var buff_effect : float = 0.0
@export var buff_frequence : float = 0.0
@export var buff_timer : float = 0.0
