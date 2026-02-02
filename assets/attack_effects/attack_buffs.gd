class_name AttackBuff
extends Resource

@export_category("Attack Modifications")
@export_enum("Fire","Ice", "Earth") var buff_type: int

@export_category("Attack Stats")
@export var attack_title : String = ""
@export var attack_damage : int = 0
@export var attack_force : float = 0.0
@export var attack_ratio : float = 0.0
