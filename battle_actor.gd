class_name BattleActor extends Resource

signal hp_changed(hp, hp_max, amount_change)

@export var name: String = ""
@export var hp_max: int = 1
@export var mp_max: int = 0

var hp: int = hp_max
var mp: int = mp_max

func init() -> void:
	hp = hp_max
	mp = mp_max

func copy() -> BattleActor:
	var dup: BattleActor = duplicate()
	dup.init()
	return dup

func healhurt(value: int) -> void:
	var previous_hp: int = hp
	hp += value
	hp = clampi(hp, 0, hp_max)
	hp_changed.emit(hp, hp_max, previous_hp - hp)
	print(name, " ", hp)
